//
//  DemoViewController.m
//  JoinShow
//
//  Created by Heaven on 14-4-2.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import "DemoViewController.h"

#if (1 == __XYQuick_Framework__)
#import <XYQuick/XYQuickDevelop.h>
#else
#import "XYQuickDevelop.h"
#endif


@interface DemoViewController ()

@end

@implementation DemoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (_viewDidLoadBlock) {
        _viewDidLoadBlock(self);
        self.viewDidLoadBlock = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView{
    [super loadView];
    
    if (_loadViewBlock) {
        _loadViewBlock(self);
        self.loadViewBlock = nil;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)dealloc
{
    NSLogDD;
    self.viewDidLoadBlock = nil;
    self.loadViewBlock = nil;
    self.methodBlock = nil;
    self.methodBlock2 = nil;
    
}

- (void)funny:(id)sender{
    if (_methodBlock) {
        _methodBlock(self, sender);
    }
}
- (void)funny2:(id)sender{
    if (_methodBlock2) {
        _methodBlock2(self, sender);
    }
}

- (void)memoryWarning
{
    NSLogD(@"%@", self.name);
}
@end
