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

-(void) createFields
{
    // [super createFields];
}

-(void) destroyFields
{
    // [super destroyFields];
    self.children = nil;
    self.curChild = nil;
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
}

-(void) destroyEvents
{
    // [super destroyEvents];
}

-(void) loadData
{
    // [super loadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.children = nil;
}

-(NSMutableDictionary *) children{
    if (_children == nil) {
        self.children = [NSMutableDictionary dictionaryWithCapacity:6];
    }
    
    return _children;
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
