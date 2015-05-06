//
//  XYPerformance.h
//  JoinShow
//
//  Created by Heaven on 13-8-23.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//  Copy from bee Framework http://www.bee-framework.com

// 性能分析

#import "XYQuick_Predefine.h"

#pragma mark -

#if (1 ==  __XY_PERFORMANCE__)

    #define	PERF_TIME( block )			{ _PERF_ENTER(__PRETTY_FUNCTION__, __LINE__); block; _PERF_LEAVE(__PRETTY_FUNCTION__, __LINE__); }
    #define	PERF_ENTER_( __tag)         [[XYPerformance sharedInstance] enter:__tag];
    #define	PERF_LEAVE_( __tag)         [[XYPerformance sharedInstance] leave:__tag];

#else

    #define	PERF_TIME( block )				{ block }
    #define	PERF_ENTER_( __tag)
    #define	PERF_LEAVE_( __tag)
#endif

#pragma mark -

@interface XYPerformance : NSObject __AS_SINGLETON

- (void)enter:(NSString *)tag;
- (void)leave:(NSString *)tag;

@end
