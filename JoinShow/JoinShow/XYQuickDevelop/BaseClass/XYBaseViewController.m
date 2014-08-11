//
//  BaseViewController.m
//  MyLib
//
//  Created by jax on 13-9-2.
//  Copyright (c) 2013年 Bao. All rights reserved.
//

#import "XYBaseViewController.h"

@implementation XYBaseViewController

- (id) init {
    self = [super init];
    if (self) {
        NSLogDSelf
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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

-(void) createFields {
  // [super createFields];
}

-(void) destroyFields {
    // [super destroyFields];
}

-(void) createViews {
    // [super createViews];
}

-(void) destroyViews {
    // [super destroyViews];
}

-(void) createEvents {
    // [super createEvents];
    // 保存当前状态
    if ([self respondsToSelector:@selector(saveCurrentState)]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveCurrentState) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    
}

-(void) destroyEvents {
    // [super destroyEvents];

    // 移除此对象所有观察的消息
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) loadData {
    // [super loadData];
}

#pragma mark - api
// 对外的接口

#pragma mark - rewrite
// 额外的重写的父类的方法
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) didReceiveMemoryWarning{
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


#pragma mark - 响应 model 的地方
#pragma mark 1 notification


#pragma mark 2 KVO


#pragma mark - 响应 view 的地方
#pragma mark 1 target-action


#pragma mark 2 delegate dataSource protocol


@end
