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

#pragma mark - #define

#define uxy_handleTimer( __name, __timer, __duration ) \
        - (void)__uxy_handleTimer_##__name:(XYTimer *)__timer duration:(NSTimeInterval)__duration

@class XYTimer;
typedef void(^XYTimer_block)(XYTimer *timer, NSTimeInterval duration);

#pragma mark - XYTimer
/**
 * 说明
 * XYTimer 是每个对象可以拥有多个,建议不要用太多,在对象释放的时候会自动停止
 */
@interface XYTimer : NSObject

@property (nonatomic, strong) NSTimer *timer;

@end


#pragma mark - XYTimerContainer


#pragma mark - NSObject(XYTimer)
@interface NSObject (XYTimer)

- (NSTimer *)uxy_startTimer:(NSString *)name interval:(NSTimeInterval)interval repeat:(BOOL)repeat;
- (NSTimer *)uxy_startTimer:(NSString *)name interval:(NSTimeInterval)interval repeat:(BOOL)repeat block:(XYTimer_block)block;

- (void)pauseTimer:(NSString *)name;
- (void)resumeTimer:(NSString *)name;

- (void)uxy_stopTimer:(NSString *)name;
- (void)uxy_stopAllTimers;

@end

#pragma mark - 
// CADisplayLink
// Ticker

#pragma mark - #define

#define uxy_handleTick( __duration ) \
        - (void)__uxy_handleTick:(NSTimeInterval)__duration

#pragma mark - XYTicker
/**
 * 说明
 * XYTicker 采用用一个CADisplayLink计时, 不用的时候需要手动移除观察
 */
@interface XYTicker : NSObject uxy_as_singleton

@property (nonatomic, weak, readonly) CADisplayLink *timer;
@property (nonatomic, assign, readonly) NSTimeInterval timestamp;
@property (nonatomic, assign) NSTimeInterval interval;

- (void)addReceiver:(NSObject *)obj;
- (void)removeReceiver:(NSObject *)obj;

@end

#pragma mark - NSObject(XYTicker)
@interface NSObject(XYTicker)

- (void)uxy_observeTick;
- (void)uxy_unobserveTick;
- (void)uxy_handleTick:(NSTimeInterval)duration;

@end











