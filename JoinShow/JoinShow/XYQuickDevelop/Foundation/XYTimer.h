//
//  XYTimer.h
//  JoinShow
//
//  Created by Heaven on 13-9-8.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

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
