/*!
 
 \file		CFSmpteFormatter.m
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

#import "CFSmpteFormatter.h"


NSString *const CFNonDropFrameFormatString = @"00:00:00:00";
NSString *const CFDropFrameFormatString = @"00:00:00;00";
NSString *const CFValidInput = @"0123456789:;";

@interface CFSmpteFormatter ()
{
    NSMutableString *_formatString;
    NSCharacterSet *_validCharacterSet;
}
@end

@implementation CFSmpteFormatter

- (id)init
{
    self = [super init];
    if (self) {
        _formatString = [NSMutableString stringWithString:CFNonDropFrameFormatString];
        _validCharacterSet = [NSCharacterSet characterSetWithCharactersInString:CFValidInput];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _formatString = [NSMutableString stringWithString:CFNonDropFrameFormatString];
        _validCharacterSet = [NSCharacterSet characterSetWithCharactersInString:CFValidInput];
    }
    return self;
}

- (void)setSmpteMode:(CFSmpteMode)smpteMode
{
    _smpteMode = smpteMode;
    switch (smpteMode) {
        case CFSmpteModeNonDropFrame:
            _formatString = [CFNonDropFrameFormatString mutableCopy];
            break;
            
        case CFSmpteModeDropFrame:
            _formatString = [CFDropFrameFormatString mutableCopy];
            break;
            
        default:
            break;
    }
}

- (NSString*)stringForObjectValue:(id)obj
{
    if ( ! [obj isKindOfClass:[NSNumber class]] ) {
        return nil;
    }
    
    NSInteger length = (NSInteger)[[obj stringValue] length];
    NSInteger insertLocation = 9;
    
    
    // Scan the object value and insert HH, MM, SS, FF into the format string.
    
    NSMutableString *returnString = [_formatString mutableCopy];
    
    if (length == 1) {
        if ([obj intValue] == 0)
            return @"";
        
        [returnString replaceCharactersInRange:NSMakeRange(10, 1) withString:[obj stringValue]];
    } else {
        NSString *temp;
        
        while (length > 1) {
            temp = [[obj stringValue] substringFromIndex:length-2];
            [returnString replaceCharactersInRange:NSMakeRange(insertLocation, 2) withString:temp];
            
            obj = [NSNumber numberWithInt:[obj intValue]/100];
            length -= 2;
            insertLocation -= 3;
        }
        
        // Handle remaining character if there is one.
        if (length == 1) {
            [returnString replaceCharactersInRange:NSMakeRange(insertLocation+1, 1) withString:[obj stringValue]];
        }
    }
    
    return returnString;
}


- (BOOL)getObjectValue:(out __autoreleasing id *)obj forString:(NSString *)string errorDescription:(out NSString *__autoreleasing *)error
{
    // Remove the delimiters so object value can be returned.
    // This method is called in real-time as editing is taking place, so using a range-based search-and-replace would
    // not be as efficient.
    
    NSString *returnString = [string stringByReplacingOccurrencesOfString:@":" withString:@""];
    returnString = [returnString stringByReplacingOccurrencesOfString:@";" withString:@""];
    
    if (obj) {
        *obj = [NSNumber numberWithInt:[returnString intValue]];
        return YES;
    }
    
    return NO;
}


- (BOOL)isPartialStringValid:(NSString *)partialString
            newEditingString:(NSString *__autoreleasing *)newString errorDescription:(NSString *__autoreleasing *)error
{
    if ([partialString isEqualToString:@""]) {
        return YES;
    }
    
    NSScanner *scanner = [NSScanner scannerWithString:partialString];
    if ( ! ([scanner scanCharactersFromSet:_validCharacterSet intoString:NULL] && [scanner isAtEnd]) ) {
        return NO;
    }
    
    return YES;
}

@end
