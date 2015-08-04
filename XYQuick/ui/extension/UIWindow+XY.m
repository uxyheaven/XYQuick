//
//  UIWindow+XY.m
//  JoinShow
//
//  Created by heaven on 15/5/6.
//  Copyright (c) 2015年 Heaven. All rights reserved.
//

#import "UIWindow+XY.h"

@implementation UIWindow (XY)

+ (UIViewController *)uxy_visibleViewController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController)
        topController = topController.presentedViewController;
    
    return topController;
}

+ (UIViewController*)uxy_optimizedVisibleViewController
{
    return [self __uxy_visibleViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}
+ (UIViewController*)__uxy_visibleViewControllerWithRootViewController:(UIViewController*)rootViewController
{
    if ([rootViewController isKindOfClass:[UITabBarController class]])
    {
        UITabBarController *tbc = (UITabBarController*)rootViewController;
        return [self __uxy_visibleViewControllerWithRootViewController:tbc.selectedViewController];
    }
    else if ([rootViewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *nvc = (UINavigationController*)rootViewController;
        return [self __uxy_visibleViewControllerWithRootViewController:nvc.visibleViewController];
    }
    else if (rootViewController.presentedViewController)
    {
        UIViewController *presentedVC = rootViewController.presentedViewController;
        return [self __uxy_visibleViewControllerWithRootViewController:presentedVC];
    }
    else
    {
        return rootViewController;
    }
}

@end
