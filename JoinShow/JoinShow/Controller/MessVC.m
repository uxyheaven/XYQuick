//
//  MessVC.m
//  JoinShow
//
//  Created by Heaven on 13-9-1.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import "MessVC.h"
#if (1 == __XYQuick_Framework__)
#import <XYQuick/XYQuickDevelop.h>
#else
#import "XYQuickDevelop.h"
#endif
@interface MessVC ()

@end

@implementation MessVC

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
    UIImage *img = LoadImage_cache(@"bg_trends.png");
    img = [img stretched];
    
    UIImageView *imgView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 200, 200, 200)] autorelease];
    imgView.image = img;
    [self.view addSubview:imgView];
    
    img = LoadImage_cache(@"bg_trends.png");
    img = [img stretched:UIEdgeInsetsMake(15, 15, 15, 15)];
    imgView = [[[UIImageView alloc] initWithFrame:CGRectMake(220, 200, 200, 200)] autorelease];
    imgView.image = img;
    [self.view addSubview:imgView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickBtnShade:(id)sender {
    [self.view addShadeWithTarget:self action:@selector(closeShade) color:nil alpha:0.7];
}

- (IBAction)clickBtnBlockAlertView:(id)sender {
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"title" message:@"msg" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:@"ok", nil] autorelease];
    [alertView handlerClickedButton:^(UIAlertView *alertView, NSInteger btnIndex) {
        NSLogD(@"%d", btnIndex);
    }];
    [alertView show];
}

- (IBAction)clickBtnBlockActionSheet:(id)sender {
    UIActionSheet *actionSheet = [[[UIActionSheet alloc] initWithTitle:@"title" delegate:nil cancelButtonTitle:@"cancel" destructiveButtonTitle:@"destructive" otherButtonTitles:@"other1", @"other2", nil] autorelease];
    [actionSheet handlerClickedButton:^(UIActionSheet *actionSheet, NSInteger btnIndex) {
        NSLogD(@"%d", btnIndex);
    }];
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (IBAction)clickBtnSHOWMBProgressHUDIndeterminate:(id)sender {
    SHOWMBProgressHUDIndeterminate(@"title", @"message", NO)
    BACKGROUND_BEGIN
    sleep(3);
    FOREGROUND_BEGIN
    HIDDENMBProgressHUD
    FOREGROUND_COMMIT
    BACKGROUND_COMMIT
}
-(void) closeShade{
    [self.view removeShade];
}
@end
