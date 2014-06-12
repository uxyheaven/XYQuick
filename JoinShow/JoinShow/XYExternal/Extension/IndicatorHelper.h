//
//  IndicatorHelper.h
//  JoinShow
//
//  Created by Heaven on 14-6-11.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//
// 指示器帮助类

#import "XYPrecompile.h"
// MBProgressHUD指示器
#import "MBProgressHUD.h"

@interface IndicatorHelper : NSObject

AS_SINGLETON(IndicatorHelper)

// apple原生的UIActivityIndicatorView
+(id) originalIndicator;
+(id) MBProgressHUD;

//
-(void) showMessage:(NSString *)message;

-(void) show;



-(NSTimeInterval) displayDurationForString:(NSString *)str;

@end
