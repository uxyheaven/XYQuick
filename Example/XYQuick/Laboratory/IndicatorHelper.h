//
//  IndicatorHelper.h
//  JoinShow
//
//  Created by Heaven on 14-6-11.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//
// 指示器帮助类

#import "XYQuick_Predefine.h"
// MBProgressHUD指示器
#import "MBProgressHUD.h"

@interface IndicatorHelper : NSObject uxy_as_singleton

// 返回一个indicatorView
+ (id)indicatorView;

// apple原生的UIActivityIndicatorView
+ (id)originalIndicator;
+ (id)MBProgressHUD;

//
- (id)message:(NSString *)message;
- (id)inView:(UIView *)view;

- (id)show;



- (NSTimeInterval)displayDurationForString:(NSString *)str;

@end
