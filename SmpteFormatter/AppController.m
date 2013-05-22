/*!
 
 \file		AppController.m
 \brief		Application controller.
 \details   Handles all UI interaction with the main window.
 
 \author	Christian Floisand
 \version	1.0
 \date		Created: 2013/05/22
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


#import "AppController.h"


// global constants
NSString *const applicationDidChangeDropFrame = @"notifyDropFrameChanged";
NSString *const nonDropFrameFormatString = @"00:00:00:00";
NSString *const dropFrameFormatString = @"00:00:00;00";

BOOL isDropFrame;


@implementation AppController


- (void)awakeFromNib
{
    isDropFrame = NO;
    [_dropFrameCheckbox setState:NSOffState];
}


- (IBAction)dropFrameCheckboxClicked:(id)sender
{
    if ([sender state] == NSOnState)
    {
        isDropFrame = YES;
        [[_timeCode1Field cell] setPlaceholderString:dropFrameFormatString];
		[[_timeCode2Field cell] setPlaceholderString:dropFrameFormatString];
    }
    else
    {
        isDropFrame = NO;
        [[_timeCode1Field cell] setPlaceholderString:nonDropFrameFormatString];
		[[_timeCode2Field cell] setPlaceholderString:nonDropFrameFormatString];
    }
    
    
    // get the current field editor for the text box which has focus, and send it with the notification
    
    id controlWithFocus = ([_timeCode1Field currentEditor] ? [_timeCode1Field currentEditor] : [_timeCode2Field currentEditor]);
    
	[[NSNotificationCenter defaultCenter] postNotificationName:applicationDidChangeDropFrame object:controlWithFocus];
}

@end
