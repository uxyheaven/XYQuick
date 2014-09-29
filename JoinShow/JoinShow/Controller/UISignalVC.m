//
//  UISignalVC.m
//  JoinShow
//
//  Created by Heaven on 14-5-20.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import "UISignalVC.h"




@implementation Signal1

DEF_SIGNAL( click1 )

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blueColor];
        Signal2 *view = [[Signal2_child alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
        [self addSubview:view];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 110, 50, 33);
        [btn setTitle:@"click1" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(click1:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
    }
    return self;
}

- (void)click1:(id)sender{
    [self sendUISignal:self.click1 withObject:sender];
}

ON_SIGNAL( signal ){
    NSLogD(@"%@", signal);
}

@end

@implementation Signal2

DEF_SIGNAL( click2 )

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 60, 33);
        [btn setTitle:@"click2" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(click2:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    return self;
}

- (void)click2:(id)sender{
    [self sendUISignal:self.click2 withObject:sender];
}

ON_SIGNAL( signal ){
    NSLogD(@"%@", signal);
}

@end

@implementation Signal2_child

@end

@interface UISignalVC ()

@end

@implementation UISignalVC

DEF_SIGNAL( click3 )

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
    Signal1 *view = [[Signal1 alloc] initWithFrame:CGRectMake(0, 0, 250, 250)];
    [self.view addSubview:view];
    [view.po_frameBuilder alignToTopInSuperviewWithInset:66];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(0, 320, 44, 44);
    [btn setTitle:@"3" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(click3:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(50, 320, 44, 44);
    [btn setTitle:@"4" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(click4:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

ON_SIGNAL( signal ){
    NSLogD(@"%@", signal);
}
/*
ON_SIGNAL2(click1, signal){
    NSLogD(@"%@", signal);
}
*/
ON_SIGNAL3(Signal1, click1, signal){
    NSLogD(@"%@", signal);
}

- (void)click3:(id)sender{
    //UILabel *label = [[UILabel alloc] init];
    //self.tempObject = label;
    //[self.view addSubview:label];
   // NSLogD(@"%@", label);
    [self sendUISignal:self.click3 withObject:sender];
}
- (void)click4:(id)sender{
    //id temp = self.tempObject;
    //if (temp) {
   //     NSLogD(@"%@", self.tempObject);
   // }
    
}
@end
