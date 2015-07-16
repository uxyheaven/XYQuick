//
//  BaseViewController.h
//  JoinShow
//
//  Created by Heaven on 13-9-2.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import "XYQuick_Predefine.h"

#pragma mark -  生命周期
/**
 生命周期
 loadView
 1. uxy_createFields
 2. uxy_createViews
 3. uxy_createEvents
 
 viewDidLoad
 1. uxy_loadData
 
 dealloc
 1. uxy_destroyEvents
 2. uxy_destroyViews
 3. uxy_destroyFields
 
 didReceiveMemoryWarning
 1. uxy_cleanData
 
 
 规则
 1. 在uxy_createFields方法中接收从上一个页面传递过来的参数
 2. 在uxy_createFields方法中初始化变量
 3. 将要操作的控件, 都在ViewController中作为类级别的变量来声明
 3. 在uxy_createViews方法中, 加载xib文件，并通过Tag给控件一次性赋值
 4. 在uxy_createEvent方法中, 为控件挂上事件方法, 比如按钮的点击
 5. 如果有Notification, 统一在uxy_createEvent方法中addObserver, 在uxy_destroyEvent方法中removeObserver
 6. 在uxy_destroyFields方法中, 释放/销毁所有引用型变量。
 7. 在uxy_destroyViews方法中, 释放/销毁所有控件。
 8) 在uxy_cleanData方法中释放一些可以释放的数据
 */

#pragma mark -

@protocol XYViewController <NSObject>

@optional
// 创建/销毁页面级变量, model的地方
- (void)uxy_createFields;
- (void)uxy_destroyFields;

// 创建/销毁页面内控件的地方。
- (void)uxy_createViews;
- (void)uxy_destroyViews;

// 创建/销毁页面内控件事件的地方
- (void)uxy_createEvents;
- (void)uxy_destroyEvents;

// 如果页面加载过程需要读取数据, 则写在这个地方。
- (void)uxy_loadData;
// 进入后台时
- (void)uxy_enterBackground;
// 进入前台时
- (void)uxy_enterForeground;
// 已经加载,不在window上的vc, 收到内存警告
- (void)uxy_cleanData;

@end

typedef UIViewController XYBaseViewController;

@interface UIViewController (XYBase)
#pragma mark- as

#pragma mark- model

#pragma mark- view

#pragma mark- api

@end
