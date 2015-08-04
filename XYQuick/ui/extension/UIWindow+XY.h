//
//  UIWindow+XY.h
//  JoinShow
//
//  Created by heaven on 15/5/6.
//  Copyright (c) 2015年 Heaven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWindow (XY)

/// 返回目前可见的最上层显示的 viewController
+ (UIViewController *)uxy_visibleViewController;

/// 返回优化后的目前可见的最上层显示的 viewController, UITabBarController会取selectedViewController, UINavigationController取visibleViewController
+ (UIViewController*)uxy_optimizedVisibleViewController;

@end
