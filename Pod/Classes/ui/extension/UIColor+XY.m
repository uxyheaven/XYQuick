//
//  __  __          ____           _          _
//  \ \/ / /\_/\   /___ \  _   _  (_)   ___  | | __
//   \  /  \_ _/  //  / / | | | | | |  / __| | |/ /
//   /  \   / \  / \_/ /  | |_| | | | | (__  |   <
//  /_/\_\  \_/  \___,_\   \__,_| |_|  \___| |_|\_\
//
//  Copyright (C) Heaven.
//
//	https://github.com/uxyheaven/XYQuick
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.
//

#import "UIColor+XY.h"

@implementation UIColor (XYExtension)

+ (instancetype)uxy_colorFromHexString:(NSString *)hexString
{
    NSString *str = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    NSUInteger size = strtoul([str UTF8String], nil, 16);
    return [UIColor uxy_colorFromHex:size alpha:1.0];
}

+ (instancetype)uxy_colorFromHex:(NSUInteger)hex alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:(((hex & 0xFF0000) >> 16)) / 255.0 green:(((hex & 0xFF00) >> 8)) / 255.0 blue:((hex & 0xFF)) / 255.0 alpha:alpha];
}

- (instancetype)uxy_blackOrWhiteContrastingColor
{
    CGFloat r = 0;
    CGFloat g = 0;
    CGFloat b = 0;
    
    [self getRed:&r green:&g blue:&b alpha:NULL];
    
    double a = 1 - ((0.299 * r) + (0.587 * g) + (0.114 * b));
    return a < 0.5 ? [UIColor blackColor] : [UIColor whiteColor];
}

- (NSString *)uxy_hexString
{
    CGFloat r = 0;
    CGFloat g = 0;
    CGFloat b = 0;
    
    [self getRed:&r green:&g blue:&b alpha:NULL];
    
    r *= 255;
    g *= 255;
    b *= 255;
    
    return [NSString stringWithFormat:@"#%02f%02f%02f", r, g, b];
}

@end
