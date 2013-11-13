//
//  DataLiteVC.m
//  JoinShow
//
//  Created by Heaven on 13-9-10.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import "DataLiteVC.h"
#if (1 == __XYQuick_Framework__)
#import <XYQuick/XYQuickDevelop.h>
#else
#import "XYQuickDevelop.h"
#endif


@interface DataLiteVC ()

@end

@implementation DataLiteVC

DEF_DataLite_object(TestTitle, YES, nil, nil)
DEF_DataLite_object(TestSting, YES, @"DataLiteSting", nil)
DEF_DataLite_object(TestDic, YES, nil, @"default_TestDic.plist")

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
    UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 320, 300)];
    tempLabel.text = @"Please read code in [DataLiteVC.m]";
    [self.view addSubview:tempLabel];
    [tempLabel release];
    
    self.TestTitle = nil;
    NSLogD(@"%@", self.TestTitle);
    self.TestTitle = @"test1";
    NSLogD(@"%@", self.TestTitle);
    
    NSLogD(@"%@", self.TestSting);
    
    NSLogD(@"%@", self.TestDic);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
