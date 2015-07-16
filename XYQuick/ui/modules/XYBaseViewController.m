//
//  BaseViewController.m
//  JoinShow
//
//  Created by Heaven on 13-9-2.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import "XYBaseViewController.h"
#import "XYCommon.h"
#import "XYRuntime.h"

#pragma mark - def

#pragma mark - override

#pragma mark - api

#pragma mark - model event
#pragma mark 1 notification
#pragma mark 2 KVO

#pragma mark - view event
#pragma mark 1 target-action
#pragma mark 2 delegate dataSource protocol

#pragma mark - private
#pragma mark - get / set

#pragma mark -
@interface UIViewController (XYBase_private)

// 某些vc(UITableViewController)加载的时候不执行loadView方法
@property (nonatomic, assign) BOOL __uxy_isLoadedLoadView;

@end

@implementation UIViewController (XYBase)

+ (void)load
{
    [XYRuntime swizzleInstanceMethodWithClass:[UIViewController class] originalSel:@selector(loadView) replacementSel:@selector(__uxy__loadView)];
    [XYRuntime swizzleInstanceMethodWithClass:[UIViewController class] originalSel:@selector(viewDidLoad) replacementSel:@selector(__uxy__viewDidLoad)];
    [XYRuntime swizzleInstanceMethodWithClass:[UIViewController class] originalSel:NSSelectorFromString(@"dealloc") replacementSel:@selector(__uxy__dealloc)];
    [XYRuntime swizzleInstanceMethodWithClass:[UIViewController class] originalSel:@selector(didReceiveMemoryWarning) replacementSel:@selector(__uxy__didReceiveMemoryWarning)];
}

- (void)__uxy__loadView
{
    [self __uxy__loadView];
    [self __uxy__loadViewHandle];
}

- (void)__uxy__dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    
    if ([self respondsToSelector:@selector(uxy_destroyEvents)])
        [self performSelector:@selector(uxy_destroyEvents)];
    
    if ([self respondsToSelector:@selector(uxy_destroyViews)])
        [self performSelector:@selector(uxy_destroyViews)];
    
    if ([self respondsToSelector:@selector(uxy_destroyFields)])
        [self performSelector:@selector(uxy_destroyFields)];
    
    [self __uxy__dealloc];
}

- (void)__uxy__viewDidLoad
{
    [self __uxy__loadViewHandle];
    
    if ([self respondsToSelector:@selector(uxy_loadData)])
        [self performSelector:@selector(uxy_loadData)];
    
    [self __uxy__viewDidLoad];
}

- (void)xy__didReceiveMemoryWarning
{
    if ([self isViewLoaded] && [self.view window] == nil)
    {
        if ([self respondsToSelector:@selector(uxy_cleanData)])
            [self performSelector:@selector(uxy_cleanData)];
    }
    
    [self xy__didReceiveMemoryWarning];
}

#pragma mark - private
- (void)__uxy__loadViewHandle
{
    if (self.__uxy_isLoadedLoadView) return;
    
    self.__uxy_isLoadedLoadView = YES;

    if ([self respondsToSelector:@selector(uxy_createFields)])
        [self performSelector:@selector(uxy_createFields)];
    
    if ([self respondsToSelector:@selector(uxy_createViews)])
        [self performSelector:@selector(uxy_createViews)];
    
    if ([self respondsToSelector:@selector(uxy_enterBackground)])
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uxy_enterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    if ([self respondsToSelector:@selector(uxy_enterForeground)])
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uxy_enterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    if ([self respondsToSelector:@selector(uxy_createEvents)])
        [self performSelector:@selector(uxy_createEvents)];
}
@end

@implementation UIViewController(XYBase_private)

@dynamic __uxy_isLoadedLoadView;

- (BOOL)__uxy_isLoadedLoadView
{
    return [objc_getAssociatedObject(self, "VC.isLoadedLoadView") boolValue];
}
- (void)set__uxy_isLoadedLoadView:(BOOL)isLoadedLoadView
{
    objc_setAssociatedObject(self, "VC.isLoadedLoadView", @(isLoadedLoadView), OBJC_ASSOCIATION_ASSIGN);
}
@end





