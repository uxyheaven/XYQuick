//
//  IndicatorHelper.m
//  JoinShow
//
//  Created by Heaven on 14-6-11.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import "IndicatorHelper.h"
#import "XYExternal.h"

@implementation IndicatorHelper

DEF_SINGLETON(IndicatorHelper)

+ (id)originalIndicator
{
    UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    view.hidesWhenStopped = YES;
    
    return view;
}

+ (id)MBProgressHUD
{
    static dispatch_once_t once;
    static MBProgressHUD *MB_HUD;
    dispatch_once(&once, ^ {
        MB_HUD = [[self alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    });
    
    return MB_HUD;
}

+ (id)indicatorView{
    return [IndicatorHelper MBProgressHUD];
}


//
- (id)message:(NSString *)message
{
    MBProgressHUD *hud = [IndicatorHelper indicatorView];
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    
    [self bringViewToFront:hud];
    
    return hud;
}

- (id)inView:(UIView *)view{
    MBProgressHUD *hud = [IndicatorHelper indicatorView];
    [view addSubview:hud];
    
    return hud;
}
- (id)show{
    MBProgressHUD *hud = [IndicatorHelper indicatorView];
    
    [hud show:YES];
    [hud hide:YES afterDelay:[self displayDurationForString:hud.labelText]];
    
    return hud;
}

- (NSTimeInterval)displayDurationForString:(NSString *)str
{
    return MIN((float)str.length * 0.06 + 0.3, .5);
}

- (void)bringViewToFront:(UIView *)view
{
    //Getting rootViewController
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    //Getting topMost ViewController
    while (topController.presentedViewController)
        topController = topController.presentedViewController;
    
    [topController.view addSubview:view];
}

@end
