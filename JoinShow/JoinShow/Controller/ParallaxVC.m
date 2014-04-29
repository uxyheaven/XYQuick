//
//  ParallaxVC.m
//  JoinShow
//
//  Created by Heaven on 13-10-9.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import "ParallaxVC.h"
#if (1 == __XYQuick_Framework__)
#import <XYQuick/XYQuickDevelop.h>
#else
#import "XYQuickDevelop.h"
#endif


@interface ParallaxVC ()

@end

@implementation ParallaxVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)dealloc
{
    NSLogDD
     [[XYParallaxHelper sharedInstance] stop];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 30)];
    tempLabel.text = @"test1";
    tempLabel.textColor = [UIColor whiteColor];
    tempLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tempLabel];
    [[XYParallaxHelper sharedInstance] setView:tempLabel intensity:10];
    
    tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 150, 100, 30)];
    tempLabel.text = @"test2";
    tempLabel.textColor = [UIColor whiteColor];
    tempLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tempLabel];
    [[XYParallaxHelper sharedInstance] setView:tempLabel intensity:20];
    
    tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 200, 100, 30)];
    tempLabel.text = @"test3";
    tempLabel.textColor = [UIColor whiteColor];
    tempLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tempLabel];
    [[XYParallaxHelper sharedInstance] setView:tempLabel intensity:30];
    
    tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 250, 100, 30)];
    tempLabel.text = @"test4";
    tempLabel.textColor = [UIColor whiteColor];
    tempLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tempLabel];
    [[XYParallaxHelper sharedInstance] setView:tempLabel intensity:40];
    
    [self.view bg:@"bg.jpg"];
    [[XYParallaxHelper sharedInstance] setView:self.view intensity:-10];
    
    [[XYParallaxHelper sharedInstance] start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 设备方向改变
@end
