//
//  XYAppController.h
//  JoinShow
//
//  Created by heaven on 15/4/22.
//  Copyright (c) 2015年 Heaven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYPredefine.h"

// AppDelegate流程控制类
@interface XYAppController : NSObject __AS_SINGLETON

// 待补全
// 单例有问题
#pragma mark- rewrite下列方法实现控制流程的一些重载
- (void)before_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
- (void)after_application_didFinishLaunchingWithOptions;

@end
