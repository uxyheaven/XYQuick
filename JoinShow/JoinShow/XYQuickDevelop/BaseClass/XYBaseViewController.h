//
//  BaseViewController.h
//  MyLib
//
//  Created by jax on 13-9-2.
//  Copyright (c) 2013年 Bao. All rights reserved.
//

#import "XYPrecompile.h"
#import "XYControllerProtocol.h"

#if (0 == __XY_HOOK_VC__)
@interface XYBaseViewController : UIViewController<XYControllerProtocol>

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
/*************************************************************************************/
#pragma mark -

#pragma mark- 生命周期

// 创建/销毁页面级变量, model的地方。
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
#pragma mark -
// 以下方法的消息已经注册过,需要实现的时候,请直接写
//- (void)enterBackground;        // 进入后台时
//- (void)enterForeground;        // 进入前台时

#pragma mark -
typedef UIViewController XYBaseViewController;

@interface UIViewController (base)<XYControllerProtocol>
#pragma mark- model
// 定义model

#pragma mark- view
// 定义view
@end
#endif
