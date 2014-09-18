//
//  BaseViewController.m
//  MyLib
//
//  Created by jax on 13-9-2.
//  Copyright (c) 2013年 Bao. All rights reserved.
//

#import "XYBaseViewController.h"
#import "XYCommon.h"

#if (0 == __XY_HOOK__VC__)
@implementation XYBaseViewController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        NSLogDSelf
    }
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        NSLogDSelf
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)loadView
{
    // 如果想自己通过代码来创建UIViewController的view，就不需要调用[super loadView]
    // 若没有xib文件，[super loadView]默认会创建一个空白的UIView。
    [super loadView];
    
    [self createFields];
    [self createViews];
    [self createEvents];
}

- (void)dealloc
{
    NSLogDSelf
    
    [self destroyEvents];
    [self destroyViews];
    [self destroyFields];
}

- (void)createFields
{
  // [super createFields];
}

- (void)destroyFields
{
    // [super destroyFields];
}

- (void)createViews
{
    // [super createViews];
}

- (void)destroyViews
{
    // [super destroyViews];
}

- (void)createEvents
{
    // [super createEvents];

    if ([self respondsToSelector:@selector(enterBackground)])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    
    if ([self respondsToSelector:@selector(enterForeground)])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
}

- (void)destroyEvents
{
    // [super destroyEvents];

    // 移除此对象所有观察的消息
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadData
{
    // [super loadData];
}

#pragma mark - api
// 对外的接口

#pragma mark - rewrite
// 额外的重写的父类的方法

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
#pragma mark todo
    /*
     // Add code to clean up any of your own resources that are no longer necessary.
     if ([self.view window] == nil)
     {
     // Add code to preserve data stored in the views that might be
     // needed later.
     
     // Add code to clean up other strong references to the view in
     // the view hierarchy.
     self.view = nil;
     }
     */
}



#pragma mark - private
// 私有方法
- (void)handleNotification:(NSNotification *)notification
{
    if ( [notification.name isEqualToString:UIApplicationDidEnterBackgroundNotification] )
	{
	}
	else if ( [notification.name isEqualToString:UIApplicationWillEnterForegroundNotification] )
	{
	}
	else if ( [notification.name isEqualToString:UIApplicationWillChangeStatusBarOrientationNotification] )
	{
	}
	else if ( [notification.name isEqualToString:UIApplicationDidChangeStatusBarOrientationNotification] )
	{
	}
}

#pragma mark - 响应 model 的地方
#pragma mark 1 notification


#pragma mark 2 KVO


#pragma mark - 响应 view 的地方
#pragma mark 1 target-action


#pragma mark 2 delegate dataSource protocol

@end

#else
#pragma mark -
#pragma mark -
@implementation XYBaseViewController
@end

@implementation UIViewController (base)

+(void)load{
    XY_swizzleInstanceMethod([UIViewController class], @selector(loadView), @selector(xy__loadView));
    XY_swizzleInstanceMethod([UIViewController class], @selector(viewDidLoad), @selector(xy__viewDidLoad));
    XY_swizzleInstanceMethod([UIViewController class], NSSelectorFromString(@"dealloc"), @selector(xy__dealloc));
}

- (void)xy__loadView
{
    [self xy__loadView];
    
    if ([self respondsToSelector:@selector(createFields)])
        [self performSelector:@selector(createFields)];
    
    if ([self respondsToSelector:@selector(createViews)])
        [self performSelector:@selector(createViews)];
    
    if ([self respondsToSelector:@selector(enterBackground)])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    
    if ([self respondsToSelector:@selector(enterForeground)])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    
    if ([self respondsToSelector:@selector(createEvents)])
        [self performSelector:@selector(createEvents)];
}

- (void)xy__dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
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
    if ([self respondsToSelector:@selector(loadData)])
        [self performSelector:@selector(loadData)];
    
    [self xy__viewDidLoad];
}

@end

#endif






