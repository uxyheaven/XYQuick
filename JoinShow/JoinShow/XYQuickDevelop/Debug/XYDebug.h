//
//  XYDebug.h
//  JoinShow
//
//  Created by Heaven on 13-12-9.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//  Copy from bee Framework http://www.bee-framework.com


// 性能分析
#import "XYPerformance.h"

// 一些debug用的小工具
#import "XYDebugToy.h"

// 单元测试
#import "XYUnitTest.h"


#pragma mark -
/*
 * 说明 仅在debug下才显示nslog
 */
#if (1 == __XYDEBUG__)

    #undef	NSLogD
    #undef	NSLogDD
    #define NSLogD(fmt, ...) {NSLog((@"%s [Line %d] DEBUG: \n" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
    #define NSLogDD NSLogD(@"%@", @"");
    #define NSLogDSelf NSLogD(@"Class: %@", NSStringFromClass([self class]));

#else

    #define NSLogD(format, ...)
    #define NSLogDD
    #define NSLogDSelf

#endif




