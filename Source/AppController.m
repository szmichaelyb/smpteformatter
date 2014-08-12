/*!
 
 \file		AppController.m
 \brief		Application controller.
 \details   Handles all UI interaction with the main window.
 
 \author	Christian Floisand
 \version	1.0
 \date		Created: 2013/05/22
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

#import "AppController.h"
#import "CFSmpteFormatter/CFSmpteFormatter.h"
#import "CFSmpteTextField/CFSmpteTextField.h"


// The KVO key-path is the NSButton's NSCell state property.
static NSString *const CheckboxStateKeyPath = @"cell.state";

@interface AppController ()

@end

@implementation AppController

- (void)awakeFromNib
{
    self.timeCode1Field.formatter = [[CFSmpteFormatter alloc] init];
    self.timeCode2Field.formatter = [[CFSmpteFormatter alloc] init];
    [self.dropFrameCheckbox setState:NSOffState];
    
    [self.dropFrameCheckbox addObserver:self.timeCode1Field
                             forKeyPath:CheckboxStateKeyPath
                                options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                                context:nil];
    [self.dropFrameCheckbox addObserver:self.timeCode2Field
                             forKeyPath:CheckboxStateKeyPath
                                options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                                context:nil];
}

- (void)dealloc
{
    [self.dropFrameCheckbox removeObserver:self.timeCode1Field forKeyPath:CheckboxStateKeyPath context:nil];
    [self.dropFrameCheckbox removeObserver:self.timeCode2Field forKeyPath:CheckboxStateKeyPath context:nil];
}

@end
