//
//  BaseTableViewController.m
//  JoinShow
//
//  Created by Heaven on 14-2-20.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import "XYBaseTableViewController.h"

@interface XYBaseTableViewController ()

@end

@implementation XYBaseTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
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

-(void) createFields {
    // [super createFields];
}

-(void) destroyFields {
    // [super destroyFields];
    self.children = nil;
    self.curChild = nil;
    self.curParent = nil;
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

-(void) loadData
{
    // [super loadData];
}

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
}


#pragma mark - private
// 私有方法
-(NSMutableDictionary *) children{
    if (_children == nil) {
        self.children = [NSMutableDictionary dictionaryWithCapacity:6];
    }
    
    return _children;
}


#pragma mark - 响应 model 的地方
#pragma mark 1 notification


#pragma mark 2 KVO


#pragma mark - 响应 view 的地方
#pragma mark 1 target-action


#pragma mark 2 delegate


#pragma mark 3 dataSource


@end
