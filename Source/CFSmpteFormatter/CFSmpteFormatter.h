/*!
 
 \file		CFSmpteFormatter.h
 \brief		Defines SMPTE time code format for use in an NSTextField control.
 \details   The SMPTE time code format follows the pattern HH:MM:SS:FF (HH:MM:SS;FF for drop-frame mode).
            This custom formatter formats and validates the input of the text box control to one of the masking patterns
            above, and dynamically switches formats according to the drop-frame mode.
 
 \author	Christian Floisand
 \version	2.0
 \date		Created: 2013/05/19
            Updated: 2014/08/11
 
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


typedef enum : NSUInteger {
    CFSmpteModeNonDropFrame,
    CFSmpteModeDropFrame
} CFSmpteMode;

extern NSString *const CFNonDropFrameFormatString;
extern NSString *const CFDropFrameFormatString;


@interface CFSmpteFormatter : NSFormatter

/*! @brief Specifies whether formatting should be for non-drop-frame or drop-frame frame rates.
    @details Default is non-drop-frame. */
@property (nonatomic) CFSmpteMode smpteMode;

@end
