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

#import "UINavigationBar+XY.h"
#import <objc/runtime.h>

@implementation UINavigationBar (XYExtension)

uxy_staticConstString(xy_navigationBar_overlay)

- (UIView *)overlay
{
    return objc_getAssociatedObject(self, xy_navigationBar_overlay);
}

- (void)setOverlay:(UIView *)overlay
{
    objc_setAssociatedObject(self, xy_navigationBar_overlay, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

uxy_staticConstString(xy_navigationBar_image)

- (UIImage *)emptyImage
{
    return objc_getAssociatedObject(self, xy_navigationBar_image);
}

- (void)setEmptyImage:(UIImage *)image
{
    objc_setAssociatedObject(self, xy_navigationBar_image, image, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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

- (void)uxy_setTranslationY:(CGFloat)translationY
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
