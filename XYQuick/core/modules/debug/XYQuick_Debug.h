//
//  XYQuick_Debug.h
//  JoinShow
//
//  Created by heaven on 15/5/6.
//  Copyright (c) 2015年 Heaven. All rights reserved.
//

#import <Foundation/Foundation.h>


#pragma mark -
/*
 * 说明 仅在debug下才显示nslog
 */
#if (1 == __XY_DEBUG__)
    #undef	NSLogD
    #undef	NSLogDD
    #define NSLogD(fmt, ...) {NSLog((@"%s [Line %d] DEBUG: \n" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
    #define NSLogDD NSLogD(@"%@", @"");
    #define NSLogDSelf NSLogD(@"Class: %@", NSStringFromClass([self class]));
#else
    #define NSLogD(format, ...)
    #define NSLogDD
    #define NSLogDSelf
    #define NSLog(...) {}
#endif

#pragma mark -
// Modules
#import "XYPerformance.h"                   // 性能分析
#import "XYDebugToy.h"                      // 一些debug用的小工具

// Extensions

#pragma mark -
