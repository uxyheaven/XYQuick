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
