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

#import "UIViewController+XY.h"
#import <objc/runtime.h>

#import "UIImage+XY.h"
#import "UIControl+XY.h"

@implementation UIViewController (XYExtension)

uxy_staticConstString(UIViewController_key_parameters)

- (id)uxy_parameters
{
    return objc_getAssociatedObject(self, UIViewController_key_parameters);
}

- (void)setUxy_parameters:(id)anObject
{
    [self willChangeValueForKey:@"uxy_parameters"];
    objc_setAssociatedObject(self, UIViewController_key_parameters, anObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"uxy_parameters"];
}

- (void)uxy_pushVC:(NSString *)vcName
{
    [self uxy_pushVC:vcName object:nil];
}
- (void)uxy_pushVC:(NSString *)vcName object:(id)object
{
    Class class = NSClassFromString(vcName);
    NSAssert(class != nil, @"Class 必须存在");
    UIViewController *vc = nil;
    
    if ([class conformsToProtocol:@protocol(XYSwitchControllerProtocol)])
    {
        vc = [[NSClassFromString(vcName) alloc] initWithObject:object];
    }
    else
    {
        vc = [[NSClassFromString(vcName) alloc] init];
        vc.uxy_parameters = object;
    }

    [self.navigationController pushViewController:vc animated:YES];
}

- (void)uxy_popVC
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)uxy_modalVC:(NSString *)vcName withNavigationVC:(NSString *)navName
{
    [self uxy_modalVC:vcName withNavigationVC:navName object:nil succeed:nil];
}

- (void)uxy_modalVC:(NSString *)vcName withNavigationVC:(NSString *)nvcName object:(id)object succeed:(UIViewController_block_void)block
{
    Class class = NSClassFromString(vcName);
    NSAssert(class != nil, @"Class 必须存在");
    
    UIViewController *vc = nil;
    
    if ([class conformsToProtocol:@protocol(XYSwitchControllerProtocol)])
    {
        vc = [[NSClassFromString(vcName) alloc] initWithObject:object];
    }
    else
    {
        vc = [[NSClassFromString(vcName) alloc] init];
        vc.uxy_parameters = object;
    }
    
    UINavigationController *nvc = nil;
    if (nvcName)
    {
        nvc = [[NSClassFromString(nvcName) alloc] initWithRootViewController:vc];
        [self presentViewController:nvc animated:YES completion:block];
        
        return;
    }
    
    [self presentViewController:vc animated:YES completion:block];
}

- (void)uxy_dismissModalVC
{
    [self uxy_dismissModalVCWithSucceed:nil];
}
- (void)uxy_dismissModalVCWithSucceed:(UIViewController_block_void)block
{
    [self dismissViewControllerAnimated:YES completion:block];
}

- (id)uxy_showUserGuideViewWithImage:(NSString *)imgName
                                 key:(NSString *)key
                          alwaysShow:(BOOL)isAlwaysShow
                               frame:(NSString *)frameString
                          tapExecute:(UIViewController_block_view)block
{
    NSString *guideKey = [NSString stringWithFormat:@"_guide_%@", key];
    NSInteger isShow   = [[NSUserDefaults standardUserDefaults] integerForKey:guideKey];
    if (isAlwaysShow || isShow == 0)
    {
        if (isShow != 1)
        {
            [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:key];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }

        
        // 用户引导视图
        UIView *userGuideView = [[UIView alloc] initWithFrame:UIScreen.mainScreen.bounds];
        userGuideView.backgroundColor = [UIColor clearColor];
        
        // 用户引导背景图
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:userGuideView.bounds];
        imageView.tag = UserGuide_tag;
        UIImage *image = [UIImage uxy_imageWithFileName:imgName];

        if ([frameString isEqualToString:@"full"] || frameString.length == 0)
        {
            imageView.image = image;
        }
        else if ([frameString isEqualToString:@"center"])
        {
            // 高清屏幕就缩小图片显示尺寸
            imageView.bounds = CGRectMake(0, 0, image.size.width / [UIScreen mainScreen].scale, image.size.height / [UIScreen mainScreen].scale);
            imageView.center = userGuideView.center;
            imageView.image = image;
        }
        else if (frameString.length > 0)
        {
            // 坐标是string类型
            CGRect rect = CGRectFromString(frameString);
            if (!CGRectIsEmpty(rect))
            {
                imageView.frame = rect;
                imageView.image = image;
            }
            else
            {
                CGPoint point = CGPointFromString(frameString);
                imageView.bounds = CGRectMake(0, 0, image.size.width / [UIScreen mainScreen].scale, image.size.height / [UIScreen mainScreen].scale);
                imageView.center = point;
                imageView.image = image;
            }
        }
        
        [userGuideView addSubview:imageView];
        
        // 按钮(作用：隐藏蒙版)
        UIButton *btnHide = [UIButton buttonWithType:UIButtonTypeCustom];
        btnHide.frame = userGuideView.bounds;
        [btnHide uxy_handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            UIView *bgView = ((UIView *)sender).superview;
            if (block)
            {
                block(bgView);
            }
            else
            {
                if (bgView)
                {
                    bgView.hidden = YES;
                    
                    // 淡入淡出
                    CAAnimation *animation = [NSClassFromString(@"CATransition") animation];
                    [animation setValue:@"kCATransitionFade" forKey:@"type"];
                    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
                    animation.duration = 0.3;
                    [bgView.layer addAnimation:animation forKey:nil];
                    
                    [bgView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:.3];
                }
            }
            
        }];
        [userGuideView addSubview:btnHide];
        userGuideView.window.windowLevel = UIWindowLevelStatusBar + 1;
        [self.view addSubview:userGuideView];
        
        // 淡入淡入
        CAAnimation *animation = [NSClassFromString(@"CATransition") animation];
        [animation setValue:@"kCATransitionFade" forKey:@"type"];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        animation.duration = .15;
        [self.view.layer addAnimation:animation forKey:nil];
        
        return userGuideView;
    }
    
    return nil;
}



@end

