//
//  PaintCodeView.m
//  JoinShow
//
//  Created by Heaven on 14-2-24.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import "PaintCodeView.h"

@implementation PaintCodeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* color = [UIColor colorWithRed: 0.592 green: 0.275 blue: 0.102 alpha: 1];
    UIColor* color2 = [UIColor colorWithRed: 0.302 green: 0.119 blue: 0.02 alpha: 1];
    UIColor* color3 = [UIColor colorWithRed: 0.424 green: 0.18 blue: 0.086 alpha: 1];
    UIColor* color4 = [UIColor colorWithRed: 1 green: 0.534 blue: 0.208 alpha: 1];
    
    //// Gradient Declarations
    NSArray* gradientColors = [NSArray arrayWithObjects:
                               (id)color.CGColor,
                               (id)color2.CGColor,
                               (id)color3.CGColor,
                               (id)[UIColor colorWithRed: 0.712 green: 0.357 blue: 0.147 alpha: 1].CGColor,
                               (id)color4.CGColor, nil];
    CGFloat gradientLocations[] = {0, 0.3, 0.83, 0.93, 1};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)gradientColors, gradientLocations);
    
    //// Graphic 形状 1 GradientOverlay Drawing
    UIBezierPath* graphic1GradientOverlayPath = [UIBezierPath bezierPath];
    [graphic1GradientOverlayPath moveToPoint: CGPointMake(84.81, 18.72)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(86.72, 18.72) controlPoint1: CGPointMake(85.45, 18.72) controlPoint2: CGPointMake(86.08, 18.72)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(86.72, 24.26) controlPoint1: CGPointMake(86.72, 20.57) controlPoint2: CGPointMake(86.72, 22.41)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(88.97, 24.26) controlPoint1: CGPointMake(87.47, 24.26) controlPoint2: CGPointMake(88.22, 24.26)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(88.97, 45.56) controlPoint1: CGPointMake(88.97, 31.36) controlPoint2: CGPointMake(88.97, 38.46)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(92.78, 64.27) controlPoint1: CGPointMake(90.47, 51.61) controlPoint2: CGPointMake(91.12, 58.07)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(95.03, 75) controlPoint1: CGPointMake(93.67, 67.58) controlPoint2: CGPointMake(94.72, 71.47)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(10, 75) controlPoint1: CGPointMake(66.69, 75) controlPoint2: CGPointMake(38.34, 75)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(13.98, 35.35) controlPoint1: CGPointMake(11.33, 61.79) controlPoint2: CGPointMake(12.66, 48.56)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(12.25, 35.35) controlPoint1: CGPointMake(13.41, 35.35) controlPoint2: CGPointMake(12.83, 35.35)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(12.25, 28.94) controlPoint1: CGPointMake(12.25, 33.21) controlPoint2: CGPointMake(12.25, 31.07)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(16.41, 28.94) controlPoint1: CGPointMake(13.64, 28.94) controlPoint2: CGPointMake(15.02, 28.94)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(16.58, 32.06) controlPoint1: CGPointMake(16.67, 29.69) controlPoint2: CGPointMake(16.59, 31.03)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(18.66, 32.06) controlPoint1: CGPointMake(17.27, 32.06) controlPoint2: CGPointMake(17.97, 32.06)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(18.66, 28.59) controlPoint1: CGPointMake(18.66, 30.9) controlPoint2: CGPointMake(18.66, 29.75)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(20.39, 28.59) controlPoint1: CGPointMake(19.24, 28.59) controlPoint2: CGPointMake(19.81, 28.59)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(20.39, 12.66) controlPoint1: CGPointMake(20.39, 23.28) controlPoint2: CGPointMake(20.39, 17.97)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(21.78, 12.66) controlPoint1: CGPointMake(20.85, 12.66) controlPoint2: CGPointMake(21.31, 12.66)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(21.78, 13.7) controlPoint1: CGPointMake(21.78, 13.01) controlPoint2: CGPointMake(21.78, 13.35)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(32.86, 13.87) controlPoint1: CGPointMake(24.92, 13.67) controlPoint2: CGPointMake(30.71, 13.21)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(32.86, 14.04) controlPoint1: CGPointMake(32.86, 13.93) controlPoint2: CGPointMake(32.86, 13.99)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(25.59, 16.82) controlPoint1: CGPointMake(31.76, 14.15) controlPoint2: CGPointMake(25.89, 16.22)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(25.76, 16.82) controlPoint1: CGPointMake(25.64, 16.82) controlPoint2: CGPointMake(25.7, 16.82)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(29.92, 19.41) controlPoint1: CGPointMake(26.85, 17.84) controlPoint2: CGPointMake(28.53, 18.74)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(29.92, 19.59) controlPoint1: CGPointMake(29.92, 19.47) controlPoint2: CGPointMake(29.92, 19.53)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(21.95, 19.59) controlPoint1: CGPointMake(27.26, 19.59) controlPoint2: CGPointMake(24.6, 19.59)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(21.78, 28.59) controlPoint1: CGPointMake(21.18, 21.89) controlPoint2: CGPointMake(21.76, 25.91)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(22.99, 28.59) controlPoint1: CGPointMake(22.18, 28.59) controlPoint2: CGPointMake(22.58, 28.59)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(22.99, 32.23) controlPoint1: CGPointMake(22.99, 29.8) controlPoint2: CGPointMake(22.99, 31.02)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(24.89, 32.23) controlPoint1: CGPointMake(23.62, 32.23) controlPoint2: CGPointMake(24.26, 32.23)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(24.89, 28.94) controlPoint1: CGPointMake(24.89, 31.13) controlPoint2: CGPointMake(24.89, 30.03)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(28.53, 28.94) controlPoint1: CGPointMake(26.11, 28.94) controlPoint2: CGPointMake(27.32, 28.94)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(28.53, 35.35) controlPoint1: CGPointMake(28.53, 31.07) controlPoint2: CGPointMake(28.53, 33.21)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(26.8, 35.35) controlPoint1: CGPointMake(27.95, 35.35) controlPoint2: CGPointMake(27.38, 35.35)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(28.36, 45.04) controlPoint1: CGPointMake(27.32, 38.58) controlPoint2: CGPointMake(27.84, 41.81)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(31.65, 45.04) controlPoint1: CGPointMake(29.45, 45.04) controlPoint2: CGPointMake(30.55, 45.04)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(31.65, 47.99) controlPoint1: CGPointMake(31.65, 46.02) controlPoint2: CGPointMake(31.65, 47.01)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(34.76, 48.16) controlPoint1: CGPointMake(32.4, 48.25) controlPoint2: CGPointMake(33.74, 48.17)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(34.76, 47.99) controlPoint1: CGPointMake(34.76, 48.1) controlPoint2: CGPointMake(34.76, 48.05)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(34.94, 47.99) controlPoint1: CGPointMake(34.82, 47.99) controlPoint2: CGPointMake(34.88, 47.99)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(34.94, 45.04) controlPoint1: CGPointMake(34.94, 47.01) controlPoint2: CGPointMake(34.94, 46.02)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(39.61, 45.04) controlPoint1: CGPointMake(36.5, 45.04) controlPoint2: CGPointMake(38.06, 45.04)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(39.61, 48.16) controlPoint1: CGPointMake(39.61, 46.08) controlPoint2: CGPointMake(39.61, 47.12)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(43.25, 48.16) controlPoint1: CGPointMake(40.83, 48.16) controlPoint2: CGPointMake(42.04, 48.16)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(43.25, 45.04) controlPoint1: CGPointMake(43.25, 47.12) controlPoint2: CGPointMake(43.25, 46.08)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(47.93, 45.04) controlPoint1: CGPointMake(44.81, 45.04) controlPoint2: CGPointMake(46.37, 45.04)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(47.93, 48.16) controlPoint1: CGPointMake(47.93, 46.08) controlPoint2: CGPointMake(47.93, 47.12)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(51.39, 48.16) controlPoint1: CGPointMake(49.08, 48.16) controlPoint2: CGPointMake(50.24, 48.16)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(51.39, 45.04) controlPoint1: CGPointMake(51.39, 47.12) controlPoint2: CGPointMake(51.39, 46.08)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(56.59, 45.04) controlPoint1: CGPointMake(53.12, 45.04) controlPoint2: CGPointMake(54.85, 45.04)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(56.59, 48.16) controlPoint1: CGPointMake(56.59, 46.08) controlPoint2: CGPointMake(56.59, 47.12)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(59.88, 48.16) controlPoint1: CGPointMake(57.68, 48.16) controlPoint2: CGPointMake(58.78, 48.16)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(60.05, 45.04) controlPoint1: CGPointMake(59.85, 46.49) controlPoint2: CGPointMake(59.92, 46.25)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(65.07, 45.04) controlPoint1: CGPointMake(61.72, 45.04) controlPoint2: CGPointMake(63.4, 45.04)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(65.07, 48.16) controlPoint1: CGPointMake(65.07, 46.08) controlPoint2: CGPointMake(65.07, 47.12)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(67.5, 48.16) controlPoint1: CGPointMake(65.88, 48.16) controlPoint2: CGPointMake(66.69, 48.16)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(67.5, 24.26) controlPoint1: CGPointMake(67.5, 40.2) controlPoint2: CGPointMake(67.5, 32.23)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(69.75, 24.26) controlPoint1: CGPointMake(68.25, 24.26) controlPoint2: CGPointMake(69, 24.26)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(69.75, 18.72) controlPoint1: CGPointMake(69.75, 22.41) controlPoint2: CGPointMake(69.75, 20.57)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(71.65, 18.72) controlPoint1: CGPointMake(70.38, 18.72) controlPoint2: CGPointMake(71.02, 18.72)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(71.65, 12.66) controlPoint1: CGPointMake(71.65, 16.7) controlPoint2: CGPointMake(71.65, 14.68)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(75.63, 10.06) controlPoint1: CGPointMake(72.98, 11.79) controlPoint2: CGPointMake(74.31, 10.93)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(75.98, 8.68) controlPoint1: CGPointMake(75.92, 9.63) controlPoint2: CGPointMake(75.78, 9.16)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(77.89, 4) controlPoint1: CGPointMake(76.59, 7.23) controlPoint2: CGPointMake(77.47, 5.63)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(78.23, 4) controlPoint1: CGPointMake(78, 4) controlPoint2: CGPointMake(78.12, 4)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(80.31, 10.06) controlPoint1: CGPointMake(78.32, 4.67) controlPoint2: CGPointMake(80.01, 9.69)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(84.81, 12.49) controlPoint1: CGPointMake(80.88, 10.76) controlPoint2: CGPointMake(84.38, 11.86)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(84.81, 18.72) controlPoint1: CGPointMake(84.81, 14.56) controlPoint2: CGPointMake(84.81, 16.64)];
    [graphic1GradientOverlayPath closePath];
    [graphic1GradientOverlayPath moveToPoint: CGPointMake(74.77, 36.21)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(82.22, 36.21) controlPoint1: CGPointMake(77.25, 36.21) controlPoint2: CGPointMake(79.73, 36.21)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(82.22, 28.76) controlPoint1: CGPointMake(82.22, 33.73) controlPoint2: CGPointMake(82.22, 31.25)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(79.1, 24.95) controlPoint1: CGPointMake(81.68, 27.15) controlPoint2: CGPointMake(80.18, 26.06)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(77.71, 24.95) controlPoint1: CGPointMake(78.64, 24.95) controlPoint2: CGPointMake(78.17, 24.95)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(74.77, 28.59) controlPoint1: CGPointMake(76.64, 25.99) controlPoint2: CGPointMake(75.27, 27.01)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(74.77, 36.21) controlPoint1: CGPointMake(74.77, 31.13) controlPoint2: CGPointMake(74.77, 33.67)];
    [graphic1GradientOverlayPath closePath];
    [graphic1GradientOverlayPath moveToPoint: CGPointMake(19.01, 36.21)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(19.01, 40.02) controlPoint1: CGPointMake(19.01, 37.48) controlPoint2: CGPointMake(19.01, 38.75)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(22.47, 40.02) controlPoint1: CGPointMake(20.16, 40.02) controlPoint2: CGPointMake(21.31, 40.02)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(22.64, 36.38) controlPoint1: CGPointMake(22.77, 39.13) controlPoint2: CGPointMake(22.66, 37.55)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(22.47, 36.38) controlPoint1: CGPointMake(22.58, 36.38) controlPoint2: CGPointMake(22.53, 36.38)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(22.47, 36.21) controlPoint1: CGPointMake(22.47, 36.33) controlPoint2: CGPointMake(22.47, 36.27)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(19.01, 36.21) controlPoint1: CGPointMake(21.31, 36.21) controlPoint2: CGPointMake(20.16, 36.21)];
    [graphic1GradientOverlayPath closePath];
    [graphic1GradientOverlayPath moveToPoint: CGPointMake(19.01, 56.47)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(22.47, 56.47) controlPoint1: CGPointMake(20.16, 56.47) controlPoint2: CGPointMake(21.31, 56.47)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(22.47, 43.14) controlPoint1: CGPointMake(22.47, 52.03) controlPoint2: CGPointMake(22.47, 47.58)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(19.18, 43.14) controlPoint1: CGPointMake(21.37, 43.14) controlPoint2: CGPointMake(20.28, 43.14)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(19.01, 47.29) controlPoint1: CGPointMake(18.84, 44.17) controlPoint2: CGPointMake(19.01, 45.97)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(19.01, 56.47) controlPoint1: CGPointMake(19.01, 50.35) controlPoint2: CGPointMake(19.01, 53.41)];
    [graphic1GradientOverlayPath closePath];
    [graphic1GradientOverlayPath moveToPoint: CGPointMake(77.19, 43.31)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(77.19, 47.81) controlPoint1: CGPointMake(77.19, 44.81) controlPoint2: CGPointMake(77.19, 46.31)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(77.37, 47.81) controlPoint1: CGPointMake(77.25, 47.81) controlPoint2: CGPointMake(77.31, 47.81)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(80.66, 47.64) controlPoint1: CGPointMake(78.18, 47.28) controlPoint2: CGPointMake(80.27, 47.68)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(80.66, 43.31) controlPoint1: CGPointMake(80.32, 46.69) controlPoint2: CGPointMake(80.33, 44.26)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(77.19, 43.31) controlPoint1: CGPointMake(79.5, 43.31) controlPoint2: CGPointMake(78.35, 43.31)];
    [graphic1GradientOverlayPath closePath];
    [graphic1GradientOverlayPath moveToPoint: CGPointMake(52.26, 56.47)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(55.72, 56.47) controlPoint1: CGPointMake(53.41, 56.47) controlPoint2: CGPointMake(54.56, 56.47)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(55.72, 52.14) controlPoint1: CGPointMake(55.72, 55.03) controlPoint2: CGPointMake(55.72, 53.59)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(52.43, 52.14) controlPoint1: CGPointMake(54.62, 52.14) controlPoint2: CGPointMake(53.53, 52.14)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(52.26, 56.47) controlPoint1: CGPointMake(52.07, 53.21) controlPoint2: CGPointMake(52.24, 55.11)];
    [graphic1GradientOverlayPath closePath];
    [graphic1GradientOverlayPath moveToPoint: CGPointMake(39.79, 52.32)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(39.79, 56.47) controlPoint1: CGPointMake(39.79, 53.7) controlPoint2: CGPointMake(39.79, 55.09)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(43.25, 56.47) controlPoint1: CGPointMake(40.94, 56.47) controlPoint2: CGPointMake(42.1, 56.47)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(43.25, 52.32) controlPoint1: CGPointMake(43.25, 55.09) controlPoint2: CGPointMake(43.25, 53.7)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(39.79, 52.32) controlPoint1: CGPointMake(42.1, 52.32) controlPoint2: CGPointMake(40.94, 52.32)];
    [graphic1GradientOverlayPath closePath];
    [graphic1GradientOverlayPath moveToPoint: CGPointMake(77.19, 52.49)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(77.19, 56.82) controlPoint1: CGPointMake(77.19, 53.93) controlPoint2: CGPointMake(77.19, 55.38)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(80.66, 56.82) controlPoint1: CGPointMake(78.35, 56.82) controlPoint2: CGPointMake(79.5, 56.82)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(80.66, 56.65) controlPoint1: CGPointMake(80.66, 56.76) controlPoint2: CGPointMake(80.66, 56.7)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(80.48, 52.49) controlPoint1: CGPointMake(80.17, 55.89) controlPoint2: CGPointMake(80.46, 53.6)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(77.19, 52.49) controlPoint1: CGPointMake(79.39, 52.49) controlPoint2: CGPointMake(78.29, 52.49)];
    [graphic1GradientOverlayPath closePath];
    [graphic1GradientOverlayPath moveToPoint: CGPointMake(77.19, 61.15)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(77.19, 65.48) controlPoint1: CGPointMake(77.19, 62.59) controlPoint2: CGPointMake(77.19, 64.04)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(77.37, 65.48) controlPoint1: CGPointMake(77.25, 65.48) controlPoint2: CGPointMake(77.31, 65.48)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(80.48, 65.48) controlPoint1: CGPointMake(78.1, 64.99) controlPoint2: CGPointMake(79.54, 65.44)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(80.66, 65.31) controlPoint1: CGPointMake(80.64, 65.29) controlPoint2: CGPointMake(80.47, 65.46)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(80.48, 61.15) controlPoint1: CGPointMake(80.31, 64.28) controlPoint2: CGPointMake(80.47, 62.46)];
    [graphic1GradientOverlayPath addCurveToPoint: CGPointMake(77.19, 61.15) controlPoint1: CGPointMake(79.39, 61.15) controlPoint2: CGPointMake(78.29, 61.15)];
    [graphic1GradientOverlayPath closePath];
    CGContextSaveGState(context);
    [graphic1GradientOverlayPath addClip];
    CGContextDrawLinearGradient(context, gradient,
                                CGPointMake(52.52, 75),
                                CGPointMake(52.52, 4),
                                kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    CGContextRestoreGState(context);
    
    
    //// Cleanup
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}


@end
