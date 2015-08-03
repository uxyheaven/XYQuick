//
//  UIWindow+XY.h
//  JoinShow
//
//  Created by heaven on 15/5/6.
//  Copyright (c) 2015年 Heaven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWindow (XY)

// 返回最顶层的 ViewController
+ (UIViewController *)uxy_topViewController;

// 返回优化后的最顶层的ViewController, UITabBarController会取selectedViewController, UINavigationController取visibleViewController
+ (UIViewController*)uxy_optimizedTopViewController;

@end
