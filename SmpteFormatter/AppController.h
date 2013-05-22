/*!
 
 \file		AppController.h
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


#import <Foundation/Foundation.h>


@interface AppController : NSObject


@property (assign) IBOutlet NSTextField *timeCode1Field;
@property (assign) IBOutlet NSTextField *timeCode2Field;
@property (assign) IBOutlet NSButton    *dropFrameCheckbox;

- (IBAction)dropFrameCheckboxClicked:(id)sender;


@end
