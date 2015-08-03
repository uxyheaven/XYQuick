//
//  UIWindow+XY.m
//  JoinShow
//
//  Created by heaven on 15/5/6.
//  Copyright (c) 2015年 Heaven. All rights reserved.
//

#import "UIWindow+XY.h"

@implementation UIWindow (XY)

+ (UIViewController *)uxy_topViewController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController)
        topController = topController.presentedViewController;
    
    return topController;
}

+ (UIViewController*)uxy_optimizedTopViewController
{
    return [self __uxy_topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}
+ (UIViewController*)__uxy_topViewControllerWithRootViewController:(UIViewController*)rootViewController
{
    if ([rootViewController isKindOfClass:[UITabBarController class]])
    {
        UITabBarController *tbc = (UITabBarController*)rootViewController;
        return [self __uxy_topViewControllerWithRootViewController:tbc.selectedViewController];
    }
    else if ([rootViewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *nvc = (UINavigationController*)rootViewController;
        return [self __uxy_topViewControllerWithRootViewController:nvc.visibleViewController];
    }
    else if (rootViewController.presentedViewController)
    {
        UIViewController *presentedVC = rootViewController.presentedViewController;
        return [self __uxy_topViewControllerWithRootViewController:presentedVC];
    }
    else
    {
        return rootViewController;
    }
}

@end
