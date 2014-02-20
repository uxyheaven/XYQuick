//
//  BaseTableViewController.m
//  JoinShow
//
//  Created by Heaven on 14-2-20.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

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
    [self destroyEvents];
    [self destroyViews];
    [self destroyFields];
    
    [super dealloc];
}

-(void) createFields
{
    
}

-(void) destroyFields
{
    
}

-(void) createViews {
    
}

-(void) destroyViews
{
    
}

-(void) createEvents
{
    
}

-(void) destroyEvents
{
    
}

-(void) loadData
{
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - rewrite

#pragma mark - event

#pragma mark - delegate

#pragma mark - private

@end
