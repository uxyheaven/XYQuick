//
//  UINavigationBar+XY.m
//  JoinShow
//
//  Created by heaven on 15/4/9.
//  Copyright (c) 2015年 Heaven. All rights reserved.
//

#import "UINavigationBar+XY.h"
#import "NSObject+XY.h"

@implementation UINavigationBar (XY)

- (UIView *)overlay
{
    return [self uxy_getAssociatedObjectForKey:"xy.navigationBar.overlay"];
}

- (void)setOverlay:(UIView *)overlay
{
    [self uxy_retainAssociatedObject:overlay forKey:"xy.navigationBar.overlay"];
}

- (UIImage *)emptyImage
{
    return [self uxy_getAssociatedObjectForKey:"xy.navigationBar.image"];
}

- (void)setEmptyImage:(UIImage *)image
{
    [self uxy_retainAssociatedObject:image forKey:"xy.navigationBar.image"];
}

- (void)uxy_setBackgroundColor:(UIColor *)backgroundColor
{
    if (self.overlay == nil)
    {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [self setShadowImage:[UIImage new]];
        self.overlay = [[UIView alloc] initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, 64)];
        self.overlay.userInteractionEnabled = NO;
        self.overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self insertSubview:self.overlay atIndex:0];
    }
    
    self.overlay.backgroundColor = backgroundColor;
}

- (void)xy_setTranslationY:(CGFloat)translationY
{
    self.transform = CGAffineTransformMakeTranslation(0, translationY);
}

- (void)uxy_setContentAlpha:(CGFloat)alpha
{
    if (self.overlay == nil)
    {
        [self uxy_setBackgroundColor:self.barTintColor];
    }
    
    [self uxy_setAlpha:alpha forSubviewsOfView:self];
    
    if (alpha == 1)
    {
        if (self.emptyImage == nil)
        {
            self.emptyImage = [UIImage new];
        }
        
        self.backIndicatorImage = self.emptyImage;
    }
}

- (void)uxy_setAlpha:(CGFloat)alpha forSubviewsOfView:(UIView *)view
{
    for (UIView *subview in view.subviews)
    {
        if (subview == self.overlay)
        {
            continue;
        }
        subview.alpha = alpha;
        [self uxy_setAlpha:alpha forSubviewsOfView:subview];
    }
}

- (void)uxy_reset
{
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self setShadowImage:nil];
    
    [self.overlay removeFromSuperview];
    self.overlay = nil;
}

@end
