//
//  UIColor+XY.m
//  JoinShow
//
//  Created by Heaven on 14-2-14.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import "UIColor+XY.h"

@implementation UIColor (XY)

+ (instancetype)colorFromHexString:(NSString *)hexString{
    unsigned rgbValue = 0;
    hexString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    
    [scanner scanHexInt:&rgbValue];
    return [[self class] colorFromHex:rgbValue];
}

+ (instancetype)colorFromHex:(int)hex{
   return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0];
}
- (instancetype)blackOrWhiteContrastingColor
{
    NSArray *rgbaArray = [self rgbaArray];
    double a = 1 - ((0.299 * [rgbaArray[0] doubleValue]) + (0.587 * [rgbaArray[1] doubleValue]) + (0.114 * [rgbaArray[2] doubleValue]));
    return a < 0.5 ? [[self class] blackColor] : [[self class] whiteColor];
}
- (NSString *)hexString{
    NSArray *colorArray	= [self rgbaArray];
    int r = [colorArray[0] floatValue] * 255;
    int g = [colorArray[1] floatValue] * 255;
    int b = [colorArray[2] floatValue] * 255;
    NSString *red = [NSString stringWithFormat:@"%02x", r];
    NSString *green = [NSString stringWithFormat:@"%02x", g];
    NSString *blue = [NSString stringWithFormat:@"%02x", b];
    
    return [NSString stringWithFormat:@"#%@%@%@", red, green, blue];
}

- (NSArray *)rgbaArray
{
    // Takes a [self class] and returns R,G,B,A values in NSNumber form
    CGFloat r = 0;
    CGFloat g = 0;
    CGFloat b = 0;
    CGFloat a = 0;
    
    if ([self respondsToSelector:@selector(getRed:green:blue:alpha:)])
    {
        [self getRed:&r green:&g blue:&b alpha:&a];
    }
    else
    {
        const CGFloat *components = CGColorGetComponents(self.CGColor);
        r = components[0];
        g = components[1];
        b = components[2];
        a = components[3];
    }
    
    return @[@(r), @(g), @(b), @(a)];
}
@end
