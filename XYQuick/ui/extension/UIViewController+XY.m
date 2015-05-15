//
//  UIViewController+XY.m
//  JoinShow
//
//  Created by Heaven on 14-4-24.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import "UIViewController+XY.h"
#import "XYSystemInfo.h"
#import "UIImage+XY.h"
#import "UIControl+XY.h"
#import "NSObject+XY.h"

#undef	UIViewController_key_parameters
#define UIViewController_key_parameters	"UIViewController.parameters"

@implementation UIViewController (XY)

@dynamic uxy_parameters;

- (id)uxy_parameters
{
    return [self uxy_getAssociatedObjectForKey:UIViewController_key_parameters];
}

- (void)setUxy_parameters:(id)anObject
{
    [self willChangeValueForKey:@"uxy_parameters"];
    [self uxy_retainAssociatedObject:anObject forKey:UIViewController_key_parameters];
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
        UIView *userGuideView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_WIDTH, Screen_HEIGHT)];
        userGuideView.backgroundColor = [UIColor clearColor];
        
        // 用户引导背景图
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:userGuideView.bounds];
        imageView.tag = UserGuide_tag;
        UIImage *image = [UIImage imageWithFileName:imgName];

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
        [btnHide handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
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

