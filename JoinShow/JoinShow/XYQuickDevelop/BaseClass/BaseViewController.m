//
//  BaseViewController.m
//  MyLib
//
//  Created by jax on 13-9-2.
//  Copyright (c) 2013年 Bao. All rights reserved.
//

#import "BaseViewController.h"

@implementation BaseViewController

- (id) init {
    self = [super init];
    if (self) {
    
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

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
    NSLogD(@"Class:%@ ", [self class]);
    
    [self destroyEvents];
    [self destroyViews];
    [self destroyFields];
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) createFields
{
  // [super createFields];
}

-(void) destroyFields
{
    // [super destroyFields];
}

-(void) createViews {
    // [super createViews];
}

-(void) destroyViews
{
    // [super destroyViews];
}

-(void) createEvents
{
    // [super createEvents];
    // 保存当前状态
    if ([self respondsToSelector:@selector(saveCurrentState)]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveCurrentState) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    
}

-(void) destroyEvents
{
    // [super destroyEvents];
    // 移除此对象所有观察的消息
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) loadData
{
    // [super loadData];
}

#pragma mark - rewrite
// 额外的重写的父类的方法

#pragma mark - event
// 事件

#pragma mark - interface
// 对外的接口,委托,协议都写在这

#pragma mark - private
// 私有方法

@end
