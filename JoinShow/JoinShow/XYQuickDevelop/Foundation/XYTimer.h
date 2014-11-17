//
//  XYTimer.h
//  JoinShow
//
//  Created by Heaven on 13-9-8.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import "XYPrecompile.h"

#pragma mark - #define

#define TIMER_NAME( __name )					__TEXT( __name )

#undef	ON_TIMER
#define ON_TIMER( __name, __timer, __duration ) \
        - (void)__name##TimerHandle:(XYTimer *)__timer duration:(NSTimeInterval)__duration

#undef	NSObject_XYTimers
#define NSObject_XYTimers	"NSObject.XYTimer.XYTimers"

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

@property (nonatomic, readonly, strong) NSMutableDictionary *XYtimers;

- (NSTimer *)timer:(NSTimeInterval)interval name:(NSString *)name;
- (NSTimer *)timer:(NSTimeInterval)interval repeat:(BOOL)repeat name:(NSString *)name;

- (NSTimer *)timer:(NSTimeInterval)interval repeat:(BOOL)repeat name:(NSString *)name block:(XYTimer_block)block;

//- (void)pauseTimer;
//- (void)resumeTimer;

- (void)cancelTimer:(NSString *)name;
- (void)cancelAllTimer;

@end

#pragma mark - 
// CADisplayLink
// Ticker


#pragma mark - #define

#undef	ON_TICK
#define ON_TICK( __time ) \
- (void)handleTick:(NSTimeInterval)__time

#pragma mark - XYTicker
/**
 * 说明
 * XYTicker 采用用一个CADisplayLink计时, 不用的时候需要手动移除观察
 */
@interface XYTicker : NSObject

@property (nonatomic, weak, readonly  ) CADisplayLink  *timer;
@property (nonatomic, assign, readonly) NSTimeInterval timestamp;
@property (nonatomic, assign          ) NSTimeInterval interval;

AS_SINGLETON( XYTicker )

- (void)addReceiver:(NSObject *)obj;
- (void)removeReceiver:(NSObject *)obj;

@end

#pragma mark - NSObject(XYTicker)
@interface NSObject(XYTicker)

- (void)observeTick;
- (void)unobserveTick;
- (void)handleTick:(NSTimeInterval)elapsed;

@end











