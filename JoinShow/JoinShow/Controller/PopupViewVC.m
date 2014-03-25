//
//  PopupViewVC.m
//  JoinShow
//
//  Created by Heaven on 13-11-1.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import "PopupViewVC.h"
#if (1 == __XYQuick_Framework__)
#import <XYQuick/XYQuickDevelop.h>
#else
#import "XYQuickDevelop.h"
#endif
#import "TestView.h"

@interface PopupViewVC ()

@end

@implementation PopupViewVC

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
    [self.view bg:@"bg.jpg"];
   // [self registerObserver];
}
- (void)dealloc
{
    NSLogDD
    [self unregisterAllMessage];
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)registerObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowBecomeKey:) name:UIWindowDidBecomeKeyNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowResignKey:) name:UIWindowDidResignKeyNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowBecomeVisible:) name:UIWindowDidBecomeVisibleNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowBecomeHidden:) name:UIWindowDidBecomeHiddenNotification object:nil];
}

- (IBAction)clickBase:(id)sender {
    UIView *view = [[[TestView alloc] initWithFrame:CGRectMake(50, 100, 100, 100)] autorelease];
    view.backgroundColor = [UIColor redColor];
    
    [view popupWithtype:PopupViewOption_none succeedBlock:nil dismissBlock:nil];
}

- (IBAction)clickDark:(id)sender {
    UIView *view = [[[TestView alloc] initWithFrame:CGRectMake(50, 100, 100, 100)] autorelease];
    view.backgroundColor = [UIColor redColor];
    
    [view popupWithtype:PopupViewOption_colorLump succeedBlock:nil dismissBlock:nil];
}

- (IBAction)clickBlur:(id)sender {
    UIView *view = [[[TestView alloc] initWithFrame:CGRectMake(50, 100, 100, 100)] autorelease];
    view.backgroundColor = [UIColor redColor];
    
    [view popupWithtype:PopupViewOption_blur succeedBlock:nil dismissBlock:^(UIView *aView) {
        NSLogD(@"a");
    }];
}

- (IBAction)clickAnimation:(id)sender {
    UIView *view = [[[TestView alloc] initWithFrame:CGRectMake(50, 200, 100, 100)] autorelease];
    view.backgroundColor = [UIColor redColor];
    
    [[XYPopupViewHelper sharedInstance] setShowAnimationBlock:^(UIView *aView) {
        CGPoint point = aView.center;
        aView.center = CGPointMake(aView.center.x, -aView.bounds.size.height * .5);
        [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            aView.center = point;
        } completion:nil];
    }];
    [view popupWithtype:PopupViewOption_blur succeedBlock:nil dismissBlock:nil];
}

- (IBAction)clickAlertView:(id)sender {
    UIAlertView *alertview = [[[UIAlertView alloc] initWithTitle:@"title" message:@"line1\nline2\nline3\nline4\nline4\nline4\nline4\nline4\nline4\nline4\nline4\nline4\nline4\nline4\nline4\nline4\nline4\nline4\nline4\nline4\nline4\nline4\nline4\nline4\nline4\nline4\nline4\nline4\nline4\nline4" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:@"ok", @"ok2", nil] autorelease];
    alertview.tag = 100001;
    [alertview handlerDidPresent:^(UIAlertView *alertView) {
        /*
        UIViewController *vc = [XYCommon topMostController];
        
        UIView *view = [[[TestView alloc] initWithFrame:CGRectMake(50, 100, 30, 30)] autorelease];
        view.tag = 1112;
        view.backgroundColor = [UIColor blueColor];
        [vc.view addSubview:view];
        */
      //  NSString *str =  [XYCommon displayViews:alertview];
       // NSLogD(@"%@", str);
    }];
    [alertview show];

    UIView *view = [[[TestView alloc] initWithFrame:CGRectMake(50, 200, 100, 100)] autorelease];
    view.tag = 1111;
    view.backgroundColor = [UIColor redColor];
    
   // UIViewController *vc = [XYCommon topMostController];
   // [vc.view addSubview:view];
}

- (IBAction)clickKeywindow:(id)sender {
    UIWindow *alertLevelWindow = [[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
    alertLevelWindow.windowLevel = UIWindowLevelAlert;
    alertLevelWindow.backgroundColor = [UIColor redColor];
    [alertLevelWindow makeKeyAndVisible];
}

#pragma mark - NSNotificationCenter
- (void)windowBecomeKey:(NSNotification*)noti
{
    UIWindow *window = noti.object;
    NSArray *windows = [UIApplication sharedApplication].windows;
    NSLogD(@"current window count %d", windows.count);
    NSLogD(@"Window has become keyWindow: %@, window level: %f, index of windows: %d", window, window.windowLevel, [windows indexOfObject:window]);
}

- (void)windowResignKey:(NSNotification*)noti
{
    UIWindow *window = noti.object;
    NSArray *windows = [UIApplication sharedApplication].windows;
    NSLogD(@"current window count %d", windows.count);
    NSLogD(@"Window has Resign keyWindow: %@, window level: %f, index of windows: %d", window, window.windowLevel, [windows indexOfObject:window]);
}

- (void)windowBecomeVisible:(NSNotification*)noti
{
    UIWindow *window = noti.object;
    NSArray *windows = [UIApplication sharedApplication].windows;
    NSLogD(@"current window count %d", windows.count);
    NSLogD(@"Window has become visible: %@, window level: %f, index of windows: %d", window, window.windowLevel, [windows indexOfObject:window]);
}

- (void)windowBecomeHidden:(NSNotification*)noti
{
    UIWindow *window = noti.object;
    NSArray *windows = [UIApplication sharedApplication].windows;
    NSLogD(@"current window count %d", windows.count);
    NSLogD(@"Window has become hidden: %@, window level: %f, index of windows: %d", window, window.windowLevel, [windows indexOfObject:window]);
}
@end
