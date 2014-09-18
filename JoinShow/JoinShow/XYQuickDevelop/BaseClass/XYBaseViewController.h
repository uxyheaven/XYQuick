//
//  BaseViewController.h
//  MyLib
//
//  Created by jax on 13-9-2.
//  Copyright (c) 2013年 Bao. All rights reserved.
//

#import "XYPrecompile.h"
#import "XYControllerProtocol.h"

#if (0 == __XY_HOOK__VC__)
@interface XYBaseViewController : UIViewController<XYControllerProtocol>


#pragma mark- model
// 定义model

#pragma mark- view
// 定义view

#pragma mark- 生命周期
/**
 生命周期
 loadView
 1 createFields
 2 createViews
 3 createEvents
 
 viewDidLoad
 1 loadData
 
 dealloc
 1 destroyViews
 2 destroyEvents
 3 destroyFields
 
 规则
 1）在createFields方法中接收从上一个页面传递过来的参数
 2）在createFields方法中初始化变量
 3）将要操作的控件，都在ViewController中作为类级别的变量来声明
 3）在createViews方法中，加载xib文件，并通过Tag给控件一次性赋值
 4）在createEvent方法中，为控件挂上事件方法，比如按钮的点击
 5）如果有NotificationCenter，统一在createEvent方法中addObserver，在destroyEvent方法中removeObserver。
 6）在DestroyFields方法中，释放/销毁所有引用型变量。
 7）在DestroyViews方法中，释放/销毁所有控件。
 **
 */


// 创建/销毁页面级变量, model的地方。
- (void)createFields;
- (void)destroyFields;

// 创建/销毁页面内控件的地方。
- (void)createViews;
- (void)destroyViews;

// 创建/销毁页面内控件的target-action,delegate,dataSource mode的Notification,KVO的地方。
- (void)createEvents;
- (void)destroyEvents;

// 如果页面加载过程需要调用MobileAPI，则写在这个地方。
- (void)loadData;

#pragma mark -
// 以下方法的消息已经注册过,需要实现的时候,请直接写
/*
- (void)enterBackground;        // 进入后台时
- (void)enterForeground;        // 进入前台时
*/

@end

#else
#pragma mark -
#pragma mark -

@interface XYBaseViewController : UIViewController<XYControllerProtocol>
@end

@interface UIViewController (base)<XYControllerProtocol>
//- (void)createFields;
//- (void)destroyFields;

// 创建/销毁页面内控件的地方。
//- (void)createViews;
//- (void)destroyViews;

// 创建/销毁页面内控件的target-action,delegate,dataSource mode的Notification,KVO的地方。
//- (void)createEvents;
//- (void)destroyEvents;

// 如果页面加载过程需要调用MobileAPI，则写在这个地方。
//- (void)loadData;

//- (void)enterBackground;        // 进入后台时
//- (void)enterForeground;        // 进入前台时
@end
#endif
