//
//  XYTimer.h
//  JoinShow
//
//  Created by Heaven on 13-9-8.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#pragma mark - #define

#define XYTimer_default @"ddd"
#import "XYPrecompile.h"

@protocol XYTimerDelegate <NSObject>

@optional
-(void) onTimer:(NSString *)timer time:(NSTimeInterval)ti;

@end


@interface XYTimer : NSObject{
  //  int classIsa;
}
AS_SINGLETON(XYTimer)

@property (nonatomic, readonly, strong) NSMutableDictionary *delegates;
@property (nonatomic, readonly, strong) NSMutableDictionary *timers;
@property (nonatomic, readonly, strong) NSMutableDictionary *accumulatorTimes;

// 默认的定时器
@property (nonatomic, weak) id<XYTimerDelegate> delegate;
-(void) startTimerWithInterval:(NSTimeInterval)ti;
-(void) stopTimer;
-(void) pauseTimer;
-(void) resumeTimer;

// 特定的定时器
-(void) startTimer:(NSString *)key interval:(NSTimeInterval)ti;
-(void) stopTimer:(NSString *)key;
-(void) pauseTimer:(NSString *)key;
-(void) resumeTimer:(NSString *)key;
-(void) setTimer:(NSString *)key delegate:(id)anObject;

-(void) stopAllTimer;

@end

#pragma mark - 
// CADisplayLink
// Ticker


#pragma mark - #define

#undef	ON_TICK
#define ON_TICK( __time ) \
-(void) handleTick:(NSTimeInterval)__time

#pragma mark - XYTicker
/**
 * 说明
 * XYTicker 采用用一个CADisplayLink计时, 不用的时候需要手动移除观察
 */
@interface XYTicker : NSObject

@property (nonatomic, weak, readonly) CADisplayLink *timer;
@property (nonatomic, assign, readonly)	NSTimeInterval		timestamp;
@property (nonatomic, assign) NSTimeInterval		interval;

AS_SINGLETON( XYTicker )

-(void) addReceiver:(NSObject *)obj;
-(void) removeReceiver:(NSObject *)obj;

@end

@interface NSObject(XYTicker)

-(void) observeTick;
-(void) unobserveTick;
-(void) handleTick:(NSTimeInterval)elapsed;

@end











