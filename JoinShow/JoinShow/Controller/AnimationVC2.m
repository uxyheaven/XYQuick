//
//  AnimationVC2.m
//  JoinShow
//
//  Created by Heaven on 13-11-19.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import "AnimationVC2.h"
#import "XYQuickDevelop.h"
@interface AnimationVC2 ()

@end

@implementation AnimationVC2

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
    UIButton *tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tempBtn.frame = CGRectMake(0, 480 - 44, 60, 44);
    tempBtn.backgroundColor = [UIColor lightGrayColor];
    [tempBtn setTitle:@"play1" forState:UIControlStateNormal];
    [tempBtn addTarget:self action:@selector(clickPlay1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tempBtn];
    
    tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tempBtn.frame = CGRectMake(140, 480 - 44, 60, 44);
    tempBtn.backgroundColor = [UIColor lightGrayColor];
    [tempBtn setTitle:@"play2" forState:UIControlStateNormal];
    [tempBtn addTarget:self action:@selector(clickPlay2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tempBtn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    NSLogDD
    [super dealloc];
}
-(void) clickPlay1{
    UIView *tempView = [self.view viewWithTag:300001];
    [tempView removeFromSuperview];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 50, 50)];
    view.backgroundColor = [UIColor redColor];
    view.tag = 300001;
    [self.view addSubview:view];
    __block UIView *safeView = view;
    XYAnimateSerialStep *steps = [[[XYAnimateSerialStep alloc] init] autorelease];
    
    XYAnimateStep *step = [XYAnimateStep duration:1 animate:^{
        safeView.center = CGPointMake(safeView.center.x, safeView.center.y + 100);
    }];
    [steps addStep:step];
    step = [XYAnimateStep duration:1 animate:^{
        safeView.center = CGPointMake(safeView.center.x, safeView.center.y + 100);
    }];
    [steps addStep:step];
    step = [XYAnimateStep duration:0.5 animate:^{
        safeView.center = CGPointMake(safeView.center.x, safeView.center.y - 50);
    }];
    [steps addStep:step];
    step = [XYAnimateStep duration:0.25 animate:^{
        safeView.center = CGPointMake(safeView.center.x, safeView.center.y + 25);
    }];
    [steps addStep:step];
    step = [XYAnimateStep duration:0.125 animate:^{
        safeView.center = CGPointMake(safeView.center.x, safeView.center.y - 12.5);
    }];
    [steps addStep:step];
    step = [XYAnimateStep duration:1 animate:^{
        safeView.backgroundColor = [UIColor blueColor];
    }];
    [steps addStep:step];
    step = [XYAnimateStep duration:1 animate:^{
        safeView.backgroundColor = [UIColor blueColor];
    }];
    [steps addStep:step];
    step = [XYAnimateStep duration:0.15 animate:^{
        safeView.transform = CGAffineTransformMakeScale(.5, .5);
    }];
    [steps addStep:step];
    step = [XYAnimateStep duration:0.2 animate:^{
        safeView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
    [steps addStep:step];
    step = [XYAnimateStep duration:0.15 animate:^{
        safeView.transform = CGAffineTransformMakeScale(.8, .8);
    }];
    [steps addStep:step];
    step = [XYAnimateStep duration:.1 animate:^{
        safeView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
    [steps addStep:step];
    
    [steps run];
}
-(void) clickPlay2{
    UIView *tempView = [self.view viewWithTag:300001];
    [tempView removeFromSuperview];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 50, 50)];
    view.backgroundColor = [UIColor redColor];
    view.tag = 300001;
    [self.view addSubview:view];
    __block UIView *safeView = view;
    XYAnimateParallelStep *steps = [XYAnimateParallelStep animate];
    XYAnimateStep *step = [XYAnimateStep duration:1 animate:^{
        safeView.center = CGPointMake(safeView.center.x, safeView.center.y + 100);
    }];
    XYAnimateStep *step2 = [XYAnimateStep duration:3 animate:^{
        safeView.backgroundColor = [UIColor blueColor];
    }];
    
    
    XYAnimateSerialStep *steps2 = [XYAnimateSerialStep animate];
    XYAnimateStep *step3 = [XYAnimateStep duration:1.5 animate:^{
        safeView.transform = CGAffineTransformMakeScale(.5, .5);
    }];
    XYAnimateStep *step4 = [XYAnimateStep duration:1.2 animate:^{
        safeView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
    XYAnimateStep *step5 = [XYAnimateStep duration:1.5 animate:^{
        safeView.transform = CGAffineTransformMakeScale(.8, .8);
    }];
    
  
    XYAnimateStep *step6 = [XYAnimateStep duration:1 animate:^{
        safeView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
    
    [[[steps2 addStep:step3] addStep:step4] addStep:step5];
    [[[[steps addStep:step] addStep:step2] addStep:steps2] addStep:step6];
    
    [steps run];
}
@end
