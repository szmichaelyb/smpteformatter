/*!
 
 \file		SmpteFormatter.m
 \brief		Defines SMPTE time code format for use in an NSTextField control.
 \details   The SMPTE time code format follows the pattern HH:MM:SS:FF and HH:MM:SS;FF when drop-frame mode is on. 
            This custom formatter formats and validates the input of the text box control to one of the masking patterns 
            above, and dynamically switches formats according to the drop-frame mode.
 
            The formatter only accepts numbers as input.  The delimiters are also included in the valid input character set, 
            because otherwise validation would fail trying to edit the formatted string.  This could perhaps be extended so 
            that the formatter accepts the delimiters as part of the format, but not as input.
 
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
extern NSString *nonDropFrameFormatString;
extern NSString *dropFrameFormatString;
extern BOOL     isDropFrame;

static NSString *const validInput = @"0123456789:;";


@interface SmpteFormatter : NSFormatter
{
    NSMutableString *formatString;
    NSCharacterSet *validCharacterSet;
}

- (void)dropFrameChanged:(NSNotification*)obj;

@end

//---------------------------------------------------------------------------------------------

@implementation SmpteFormatter


- (id)init
{
    self = [super init];
    if (self)
    {
        formatString = [NSMutableString stringWithString:nonDropFrameFormatString];
        validCharacterSet = [NSCharacterSet characterSetWithCharactersInString:validInput];
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


- (void)dropFrameChanged:(NSNotification*)obj
{
    if (isDropFrame)
    {
        formatString = (NSMutableString*)dropFrameFormatString;
    }
    else
    {
        formatString = (NSMutableString*)nonDropFrameFormatString;
    }
}


- (NSString*)stringForObjectValue:(id)obj
{
    if ( ! [obj isKindOfClass:[NSNumber class]] )
    {
        return nil;
    }
    
    int length = (int)[[obj stringValue] length];
    int insertLocation = 9;
    
    
    // scan the object value and "insert" HH, MM, SS, FF into the format string
    
    NSMutableString *returnString = [[NSString stringWithString:formatString] mutableCopy];
    
    if (length == 1)
    {
        if ([obj intValue] == 0)
            return @"";
        
        [returnString replaceCharactersInRange:NSMakeRange(10, 1) withString:[obj stringValue]];
    }
    else
    {
        NSString *temp;
        
        while (length > 1)
        {
            temp = [[obj stringValue] substringFromIndex:length-2];
            [returnString replaceCharactersInRange:NSMakeRange(insertLocation, 2) withString:temp];
            
            obj = [NSNumber numberWithInt:[obj intValue]/100];
            length -= 2;
            insertLocation -= 3;
        }
        
        // handle remaining character if there is one
        if (length == 1)
        {
            [returnString replaceCharactersInRange:NSMakeRange(insertLocation+1, 1) withString:[obj stringValue]];
        }
    }
    
    return returnString;
}


- (BOOL)getObjectValue:(out __autoreleasing id *)obj forString:(NSString *)string errorDescription:(out NSString *__autoreleasing *)error
{
    // remove the delimiters
    //      Note: this method is called in real-time as editing is taking place, so using a range-based search-and-replace would
    //      not be as efficient
    
    NSString *returnString = [string stringByReplacingOccurrencesOfString:@":" withString:@""];
    returnString = [returnString stringByReplacingOccurrencesOfString:@";" withString:@""];
    
    if (obj)
    {
        *obj = [NSNumber numberWithInt:[returnString intValue]];
        return YES;
    }
    
    return NO;
}


- (BOOL)isPartialStringValid:(NSString *)partialString
            newEditingString:(NSString *__autoreleasing *)newString errorDescription:(NSString *__autoreleasing *)error
{
    if ([partialString isEqualToString:@""])
    {
        return YES;
    }
    
    NSScanner *scanner = [NSScanner scannerWithString:partialString];
    
    if ( ! ([scanner scanCharactersFromSet:validCharacterSet intoString:NULL] && [scanner isAtEnd]) )
    {
        return NO;
    }
    
    return YES;
}


@end
