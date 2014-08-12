/*!
 
 \file		CFSmpteTextField.m
 \brief		Defines SMPTE time code custom text field control.
 \details   This custom control validates the input of the text field, making sure that the hours, minutes, seconds, and frames
            fall within acceptable bounds (for now, frames is arbitrarily set to 30 fps).  The input is not valid, the control
            returns itself to the previous value it contained.
 
            The dynamic updating of the text field's format is handled here (through observing).  This was initially a very
            persistent problem, in that the text field with focus would not update the format change until it lost focus.  To
            make this work, when the drop-frame mode is changed, the text field's NSTextView instance simply replaces the
            ":" character with ";" and vice-versa.  However, this only happens when the string present in the control is full.
 
 \author	Christian Floisand
 \version	1.0
 \date		Created: 2013/05/19
            Updated: 2014/08/11
 \copyright	Copyright (C) 2013  Christian Floisand
 
 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.
 
 */

#import "CFSmpteTextField.h"
#import "CFSmpteFormatter.h"


@interface CFSmpteTextField ()
{
    NSString *_lastValue;
}
@end

@implementation CFSmpteTextField

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // ...
    }
    return self;
}

- (void)textDidEndEditing:(NSNotification *)notification
{
	if ( ! [self.stringValue isEqualToString:@""] ) {
		int hh = [[self.stringValue substringWithRange:NSMakeRange(0, 2)] intValue];
		int mm = [[self.stringValue substringWithRange:NSMakeRange(3, 2)] intValue];
		int ss = [[self.stringValue substringWithRange:NSMakeRange(6, 2)] intValue];
		int ff = [[self.stringValue substringWithRange:NSMakeRange(9, 2)] intValue];
		
		if ((hh <= 99) && (mm <= 59) && (ss <= 59) && (ff <= 30)) {
            // Save last valid value so it can be set to this when input is invalid.
			_lastValue = self.stringValue;
		} else {
			NSBeep();
            // If input is not valid, replace with previous contents of text field if it exists, otherwise clear it.
			if ( ! [_lastValue isEqualToString:@""] )
				self.stringValue = _lastValue;
			else
				self.stringValue = @"";
		}
	} else {
        // Indicates a cleared text field.
		_lastValue = @"";
	}
    
    [super textDidEndEditing:notification];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ( ! [keyPath isEqualToString:@"cell.state"] ) {
        return;
    }
    
    NSUInteger state = [[change objectForKey:NSKeyValueChangeNewKey] unsignedIntegerValue];
    switch (state) {
        case NSOnState:
            [self.cell setPlaceholderString:CFDropFrameFormatString];
            ((CFSmpteFormatter *)self.formatter).smpteMode = CFSmpteModeDropFrame;
            break;
            
        case NSOffState:
            [self.cell setPlaceholderString:CFNonDropFrameFormatString];
            ((CFSmpteFormatter *)self.formatter).smpteMode = CFSmpteModeNonDropFrame;
            break;
            
        default:
            break;
    }
}

@end
