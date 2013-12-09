//
//  XYDebug.h
//  JoinShow
//
//  Created by Heaven on 13-12-9.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//  Copy from bee Framework http://www.bee-framework.com

// debug模式下的nslog

/*
 * 说明 仅在debug下才显示nslog
 */

#if (1 == __XYDEBUG__)
#undef	NSLogD
#undef	NSLogDD
#define NSLogD(fmt, ...) {NSLog((@"%s [Line %d] DEBUG: \n" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
#define NSLogDD NSLogD(@"%@", @"");

#else
#define NSLogD(format, ...)
#define NSLogDD
#endif


#import "XYPerformance.h"

@interface UIWindow(XYDebug)

+ (void)hook;

@end

#import <Foundation/Foundation.h>

@interface XYDebug : NSObject

@end

#pragma mark - BorderView
// uiview点击时 加边框
@interface BorderView : UIView
- (void)startAnimation;
@end



