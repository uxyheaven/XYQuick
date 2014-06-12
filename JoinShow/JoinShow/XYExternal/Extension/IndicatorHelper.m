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

+(id) originalIndicator{
    /*
    static dispatch_once_t once;
    static UIActivityIndicatorView *activityIndicatorView;
    dispatch_once(&once, ^ {
        activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicatorView.hidesWhenStopped = YES;
    });
    */
    UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    view.hidesWhenStopped = YES;
    
    return view;
}

+(id) MBProgressHUD{
    /*
    static dispatch_once_t once;
    static MBProgressHUD *MB_HUD;
    dispatch_once(&once, ^ {
        MB_HUD = [[self alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    });
    */
    return [[self alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
}

//
-(void) showMessage:(NSString *)message{
    MBProgressHUD *hud = [IndicatorHelper MBProgressHUD];
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.removeFromSuperViewOnHide = YES;
    
    [self bringViewToFront:hud];
    
    [hud show:YES];
    [hud hide:YES afterDelay:[self displayDurationForString:message]];
}


-(void) show{
    
}

-(NSTimeInterval) displayDurationForString:(NSString *)str{
    return MIN((float)str.length * 0.06 + 0.3, .5);
}

-(id) indicatorView{
    return [IndicatorHelper MBProgressHUD];
}

-(void) bringViewToFront:(UIView *)view{
    //Getting rootViewController
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    //Getting topMost ViewController
    while (topController.presentedViewController)
        topController = topController.presentedViewController;
    
    [topController.view addSubview:view];
}
@end
