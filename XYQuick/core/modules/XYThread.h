//
//  __  __          ____           _          _
//  \ \/ / /\_/\   /___ \  _   _  (_)   ___  | | __
//   \  /  \_ _/  //  / / | | | | | |  / __| | |/ /
//   /  \   / \  / \_/ /  | |_| | | | | (__  |   <
//  /_/\_\  \_/  \___,_\   \__,_| |_|  \___| |_|\_\
//
//  Copyright (C) Heaven.
//
//	https://github.com/uxyheaven/XYQuick
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.
//
//  This file Copy from Samurai.

#import "XYQuick_Predefine.h"
#pragma mark -


// 主队列
#define uxy_dispatch_async_foreground( dispatch_block_t ) \
        dispatch_async( dispatch_get_main_queue(), dispatch_block_t )

#define uxy_dispatch_after_foreground( seconds, dispatch_block_t ) \
        { \
            dispatch_time_t __time = dispatch_time( DISPATCH_TIME_NOW, seconds * 1ull * NSEC_PER_SEC ); \
            dispatch_after( __time, dispatch_get_main_queue(), dispatch_block_t ); \
        }

// 自己建的后台并行队列
#define uxy_dispatch_async_background( dispatch_block_t )      \
        uxy_dispatch_async_background_concurrent( dispatch_block_t )

#define uxy_dispatch_async_background_concurrent( dispatch_block_t ) \
        dispatch_async( [XYGCD sharedInstance].backConcurrentQueue, dispatch_block_t )

#define uxy_dispatch_after_background_concurrent( seconds, dispatch_block_t ) \
        { \
            dispatch_time_t __time = dispatch_time( DISPATCH_TIME_NOW, seconds * 1ull * NSEC_PER_SEC ); \
            dispatch_after( __time, [XYGCD sharedInstance].backConcurrentQueue, dispatch_block_t ); \
        }

// 自己建的后台串行队列
#define uxy_dispatch_async_background_serial( dispatch_block_t ) \
        dispatch_async( [XYGCD sharedInstance].backSerialQueue, dispatch_block_t )

#define uxy_dispatch_after_background_serial( seconds, dispatch_block_t ) \
        { \
            dispatch_time_t __time = dispatch_time( DISPATCH_TIME_NOW, seconds * 1ull * NSEC_PER_SEC ); \
            dispatch_after( __time, [XYGCD sharedInstance].backSerialQueue, dispatch_block_t ); \
        }

// 自己建写的文件用的串行队列
#define uxy_dispatch_async_background_writeFile( dispatch_block_t ) \
        dispatch_async( [XYGCD sharedInstance].writeFileQueue, dispatch_block_t )


// barrier
#define uxy_dispatch_barrier_async_foreground( seconds, dispatch_block_t ) \
        dispatch_barrier_async( [XYGCD sharedInstance].backConcurrentQueue, ^{   \
            uxy_dispatch_async_foreground( dispatch_block_t );   \
        });

#define uxy_dispatch_barrier_async_background_concurrent( seconds, dispatch_block_t ) \
        dispatch_barrier_async( [XYGCD sharedInstance].backConcurrentQueue, dispatch_block_t )

#pragma mark -

@interface XYGCD : NSObject uxy_as_singleton

// dispatch_get_main_queue()
@property (nonatomic, strong, readonly) dispatch_queue_t foreQueue;
// "com.XY.backSerialQueue", DISPATCH_QUEUE_SERIAL
@property (nonatomic, strong, readonly) dispatch_queue_t backSerialQueue;
// "com.XY.backConcurrentQueue", DISPATCH_QUEUE_SERIAL
@property (nonatomic, strong, readonly) dispatch_queue_t backConcurrentQueue;
// 写文件用 "com.XY.writeFileQueue", DISPATCH_QUEUE_SERIAL
@property (nonatomic, strong, readonly) dispatch_queue_t writeFileQueue;

@end
