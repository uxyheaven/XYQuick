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
@property (nonatomic, assign) BOOL isLoadedLoadView;

@end

@implementation UIViewController (XYBase)

+ (void)load
{
    [XYRuntime swizzleInstanceMethodWithClass:[UIViewController class] originalSel:@selector(loadView) replacementSel:@selector(xy__loadView)];
    [XYRuntime swizzleInstanceMethodWithClass:[UIViewController class] originalSel:@selector(viewDidLoad) replacementSel:@selector(xy__viewDidLoad)];
    [XYRuntime swizzleInstanceMethodWithClass:[UIViewController class] originalSel:NSSelectorFromString(@"dealloc") replacementSel:@selector(xy__dealloc)];
    [XYRuntime swizzleInstanceMethodWithClass:[UIViewController class] originalSel:@selector(didReceiveMemoryWarning) replacementSel:@selector(xy__didReceiveMemoryWarning)];
}

- (void)xy__loadView
{
    [self xy__loadView];
    
    [self __handleLoadView];
}

- (void)xy__dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    
    if ([self respondsToSelector:@selector(destroyEvents)])
        [self performSelector:@selector(destroyEvents)];
    
    if ([self respondsToSelector:@selector(destroyViews)])
        [self performSelector:@selector(destroyViews)];
    
    if ([self respondsToSelector:@selector(destroyFields)])
        [self performSelector:@selector(destroyFields)];
    
    [self xy__dealloc];
}

- (void)xy__viewDidLoad
{
    [self __handleLoadView];
    
    if ([self respondsToSelector:@selector(loadData)])
        [self performSelector:@selector(loadData)];
    
    [self xy__viewDidLoad];
}

- (void)xy__didReceiveMemoryWarning
{
    if ([self isViewLoaded] && [self.view window] == nil)
    {
        if ([self respondsToSelector:@selector(cleanData)])
            [self performSelector:@selector(cleanData)];
    }
    
    [self xy__didReceiveMemoryWarning];
}

#pragma mark - private
- (void)__handleLoadView
{
    if (self.isLoadedLoadView)
        return;
    
    self.isLoadedLoadView = YES;

    if ([self respondsToSelector:@selector(createFields)])
        [self performSelector:@selector(createFields)];
    
    if ([self respondsToSelector:@selector(createViews)])
        [self performSelector:@selector(createViews)];
    
    if ([self respondsToSelector:@selector(enterBackground)])
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    if ([self respondsToSelector:@selector(enterForeground)])
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    if ([self respondsToSelector:@selector(createEvents)])
        [self performSelector:@selector(createEvents)];
}
@end

@implementation UIViewController(XYBase_private)

@dynamic isLoadedLoadView;

- (BOOL)isLoadedLoadView
{
    return [objc_getAssociatedObject(self, "VC.isLoadedLoadView") boolValue];
}
- (void)setIsLoadedLoadView:(BOOL)isLoadedLoadView
{
    objc_setAssociatedObject(self, "VC.isLoadedLoadView", @(isLoadedLoadView), OBJC_ASSOCIATION_ASSIGN);
}
@end





