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

// 提交
#define uxy_dispatch_submit \
        });

// 主队列
#define uxy_dispatch_foreground   \
        dispatch_async( dispatch_get_main_queue(), ^{

#define uxy_dispatch_after_foreground( __seconds ) \
        dispatch_after( [XYGCD seconds:__seconds], dispatch_get_main_queue(), ^{

// 后台并行队列
#define uxy_dispatch_background_concurrent    \
        dispatch_async( [XYGCD sharedInstance].backConcurrentQueue, ^{

#define uxy_dispatch_after_background_concurrent( __seconds ) \
        dispatch_after( [XYGCD seconds:__seconds], [XYGCD sharedInstance].backConcurrentQueue, ^{

// barrier
#define uxy_dispatch_barrier_background_concurrent    \
        dispatch_barrier_async( [XYGCD sharedInstance].backConcurrentQueue, ^{

// 后台串行队列
#define uxy_dispatch_background_serial        \
        dispatch_async( [XYGCD sharedInstance].backSerialQueue, ^{

#define uxy_dispatch_after_background_serial( __seconds ) \
        dispatch_after( [XYGCD seconds:__seconds], [XYGCD sharedInstance].backSerialQueue, ^{

// 写的文件用的串行队列
#define uxy_dispatch_background_writeFile     \
        dispatch_async( [XYGCD sharedInstance].writeFileQueue, ^{

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

+ (dispatch_time_t)seconds:(CGFloat)f;

@end
