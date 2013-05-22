/*!
 
 \file		SmpteTextField.m
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
            Updated: 2013/05/22
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


extern NSString *applicationDidChangeDropFrame;     // notification from AppController
extern BOOL     isDropFrame;


@interface SmpteTextField : NSTextField<NSTextFieldDelegate>
{
    int lastValue;
}

- (void)dropFrameChanged:(NSNotification*)obj;

- (BOOL)validateHH:(int)hh;
- (BOOL)validateMM:(int)mm;
- (BOOL)validateSS:(int)ss;
- (BOOL)validateFF:(int)ff;

@end

//---------------------------------------------------------------------------------------------

@implementation SmpteTextField


- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        lastValue = -1;
    }
    
    return self;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:applicationDidChangeDropFrame object:nil];
}


- (void)awakeFromNib
{
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dropFrameChanged:)
                                                 name:applicationDidChangeDropFrame
                                               object:nil];
}


// The notification posted from the controller passes in the instance of NSTextView that is currently being edited as argument.
// The currently selected text in the control is stored and set at the end of the call in order to preserve the state.

- (void)dropFrameChanged:(NSNotification*)obj
{
    NSString *string = [NSString stringWithString:[[obj object] string]];
    NSRange selectedRange = [[obj object] selectedRange];
    
    if ([string length] == 11)
    {
        if (isDropFrame)
        {
            [[obj object] replaceCharactersInRange:NSMakeRange(8, 1) withString:@";"];
        }
        else
        {
            [[obj object] replaceCharactersInRange:NSMakeRange(8, 1) withString:@":"];
        }
        
        [[obj object] setSelectedRange:selectedRange];
    }
}


- (void)controlTextDidEndEditing:(NSNotification *)obj
{
    id sender = [obj object];
	
    
    // validate input string
    
	if ( ! [[sender stringValue] isEqual: @""] )
	{
		int hh = [[[sender stringValue] substringWithRange:NSMakeRange(0, 2)] intValue];
		int mm = [[[sender stringValue] substringWithRange:NSMakeRange(3, 2)] intValue];
		int ss = [[[sender stringValue] substringWithRange:NSMakeRange(6, 2)] intValue];
		int ff = [[[sender stringValue] substringWithRange:NSMakeRange(9, 2)] intValue];
		
		if ([self validateHH:hh] && [self validateMM:mm] && [self validateSS:ss] && [self validateFF:ff])
		{
			lastValue = [sender intValue];
			[sender setStringValue:[sender stringValue]];
		}
		else
		{
            // if input is not valid, replace with previous contents of text field if it exists, otherwise clear it
            
			NSBeep();
            
			if (lastValue != -1)
				[sender setIntValue:lastValue];
			else
				[sender setStringValue:@""];
		}
	}
	else
	{
        // indicates a cleared text field
		lastValue = -1;
	}
}


// These methods can be used to send specific error messages based on which SMPTE field raises an error.

- (BOOL)validateHH:(int)hh
{
	if (hh > 99)
	{
		return NO;
	}
	return YES;
}


- (BOOL)validateMM:(int)mm
{
	if (mm > 59)
	{
		return NO;
	}
	return YES;
}


- (BOOL)validateSS:(int)ss
{
	if (ss > 59)
	{
		return NO;
	}
	return YES;
}


- (BOOL)validateFF:(int)ff
{
	if (ff >= 30)
	{
		return NO;
	}
	return YES;
}


@end
