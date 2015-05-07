//
//  UIWindow+XY.m
//  JoinShow
//
//  Created by heaven on 15/5/6.
//  Copyright (c) 2015年 Heaven. All rights reserved.
//

#import "UIWindow+XY.h"

@implementation UIWindow (XY)

+ (UIViewController *)uxy_KeyWindowTopMostController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController)
        topController = topController.presentedViewController;
    
    return topController;
}

@end
