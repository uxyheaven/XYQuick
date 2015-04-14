//
//  XYThread.h
//  TWP_SkyBookShelf
//
//  Created by Heaven on 13-7-10.
//  Copy from bee Framework
//
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

#import "XYCommonDefine.h"

#pragma mark -
// 主线程
#undef	dispatch_async_foreground
#define dispatch_async_foreground( block ) \
        dispatch_async( dispatch_get_main_queue(), block )

#undef	dispatch_after_foreground
#define dispatch_after_foreground( seconds, block ) \
    { \
        dispatch_time_t __time = dispatch_time( DISPATCH_TIME_NOW, seconds * 1ull * NSEC_PER_SEC ); \
        dispatch_after( __time, dispatch_get_main_queue(), block ); \
    }

#undef	dispatch_barrier_async_foreground
#define dispatch_barrier_async_foreground( seconds, block ) \
    dispatch_barrier_async( dispatch_get_main_queue(), block )

// 系统默认的后台并行线程
#undef	dispatch_async_background_concurrent
#define dispatch_async_background_concurrent( block ) \
        dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), block )

#undef	dispatch_after_background_concurrent
#define dispatch_after_background_concurrent( seconds, block ) \
    { \
        dispatch_time_t __time = dispatch_time( DISPATCH_TIME_NOW, seconds * 1ull * NSEC_PER_SEC ); \
        dispatch_after( __time, dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), block ); \
    }

#undef	dispatch_barrier_async_background_concurrent
#define dispatch_barrier_async_background_concurrent( seconds, block ) \
        dispatch_barrier_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), block )

// 自己建的的后台串行线程
#undef	dispatch_async_background_serial
#define dispatch_async_background_serial( block ) \
    dispatch_async( [XYGCD sharedInstance].backQueue, block )

#undef	dispatch_after_background_serial
#define dispatch_after_background_serial( seconds, block ) \
    { \
        dispatch_time_t __time = dispatch_time( DISPATCH_TIME_NOW, seconds * 1ull * NSEC_PER_SEC ); \
        dispatch_after( __time, [XYGCD sharedInstance].backQueue, block ); \
    }

#undef	dispatch_barrier_async_background_serial
#define dispatch_barrier_async_background_serial( seconds, block ) \
    dispatch_barrier_async( [XYGCD sharedInstance].backQueue, block )

// 自己建写文件用的串行后台线程
#undef	dispatch_async_background
#define dispatch_async_background_writeFile( block ) \
        dispatch_async( [XYGCD sharedInstance].backIOFileQueue, block )
#pragma mark -

@interface XYGCD : NSObject __AS_SINGLETON

// dispatch_get_main_queue()
@property (nonatomic, strong, readonly) dispatch_queue_t foreQueue;
// "com.XY.taskQueue", DISPATCH_QUEUE_SERIAL
@property (nonatomic, strong, readonly) dispatch_queue_t backQueue;
// 写文件用 "com.XY.ioTaskQueue", DISPATCH_QUEUE_SERIAL
@property (nonatomic, strong, readonly) dispatch_queue_t backIOFileQueue;

@end
