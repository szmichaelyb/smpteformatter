/*!
 
 \file		CFSmpteTextField.h
 \brief		Defines SMPTE time code custom text field control.
 \details   This custom control validates the input of the text field, making sure that the hours, minutes, seconds, and frames
            fall within acceptable bounds (for now, frames is arbitrarily set to 30 fps).  The input is not valid, the control
            returns itself to the previous value it contained.
 
            The dynamic updating of the text field's format is handled here (through observing).  This was initially a very
            persistent problem, in that the text field with focus would not update the format change until it lost focus.  To
            make this work, when the drop-frame mode is changed, the text field's NSTextView instance simply replaces the
            ":" character with ";" and vice-versa.  However, this only happens when the string present in the control is full.
 
 \author	Christian Floisand
 \version	2.0
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

#import <Cocoa/Cocoa.h>


@interface CFSmpteTextField : NSTextField

@end
