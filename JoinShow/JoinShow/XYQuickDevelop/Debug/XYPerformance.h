//
//  XYPerformance.h
//  JoinShow
//
//  Created by Heaven on 13-8-23.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//  Copy from bee Framework http://www.bee-framework.com

// 性能分析

//////////////////////////////////////////////////////////////////
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//
//	Copyright (c) 2013-2014, {Bee} open source community
//	http://www.bee-framework.com
//
//
//	Permission is hereby granted, free of charge, to any person obtaining a
//	copy of this software and associated documentation files (the "Software"),
//	to deal in the Software without restriction, including without limitation
//	the rights to use, copy, modify, merge, publish, distribute, sublicense,
//	and/or sell copies of the Software, and to permit persons to whom the
//	Software is furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//	IN THE SOFTWARE.
//


#import <Foundation/Foundation.h>
#import "XYCommonDefine.h"
#pragma mark -

#if (1 ==  __XY_PERFORMANCE__)

#define PERF_TAG( __X )		[NSString stringWithFormat:@"%s", __X]
#define PERF_TAG1( __X )	[NSString stringWithFormat:@"enter %s", __X]
#define PERF_TAG2( __X )	[NSString stringWithFormat:@"leave %s", __X]

#define	PERF_MARK( __X ) \
[XYPerformance markTag:PERF_TAG(#__X)];

#define	PERF_TIME( __X1, __X2 ) \
[XYPerformance betweenTag:PERF_TAG(#__X1) andTag:PERF_TAG(#__X2)]

#define PERF_ENTER \
[XYPerformance markTag:PERF_TAG1("")];

#define PERF_ENTER_( __X ) \
[XYPerformance markTag:PERF_TAG1(#__X)];

#define PERF_LEAVE \
[XYPerformance markTag:PERF_TAG2("")]; \
[XYPerformance recordName:PERF_TAG("") andTime:[XYPerformance betweenTag:PERF_TAG1("") andTag:PERF_TAG2("")]];

#define PERF_LEAVE_( __X ) \
[XYPerformance markTag:PERF_TAG2(#__X)]; \
[XYPerformance recordName:PERF_TAG(#__X) andTime:[XYPerformance betweenTag:PERF_TAG1(#__X) andTag:PERF_TAG2(#__X)]];

#else	// #if (1 ==  __XY_PERFORMANCE__)

#define	PERF_MARK( __TAG )
#define	PERF_TIME( __TAG1, __TAG2 )	(0.0f)

#define PERF_ENTER
#define PERF_LEAVE

#define PERF_ENTER_( __X )
#define PERF_LEAVE_( __X )

#endif	// #if (1 ==  __XY_PERFORMANCE__)

#pragma mark -

@interface XYPerformance : NSObject

XY_SINGLETON( XYPerformance );

@property (nonatomic, readonly, strong) NSMutableDictionary     *records;
@property (nonatomic, strong) NSMutableDictionary               *tags;

+ (double)timestamp;

+ (double)markTag:(NSString *)tag;
+ (double)betweenTag:(NSString *)tag1 andTag:(NSString *)tag2;
+ (double)betweenTag:(NSString *)tag1 andTag:(NSString *)tag2 shouldRemove:(BOOL)remove;

+ (void)watchClass:(Class)clazz;
+ (void)watchClass:(Class)clazz andSelector:(SEL)selector;

+ (void)recordName:(NSString *)name andTime:(NSTimeInterval)time;

@end
