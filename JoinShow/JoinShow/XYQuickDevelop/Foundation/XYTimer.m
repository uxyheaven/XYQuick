//
//  XYTimer.m
//  JoinShow
//
//  Created by Heaven on 13-9-8.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import "XYTimer.h"
#import "NSDictionary+XY.h"

@implementation XYTimer
DEF_SINGLETON(XYTimer)

- (id)init
{
    self = [super init];
    if (self) {
        _delegates = [NSMutableDictionary nonRetainDictionary];
        _timers = [[NSMutableDictionary alloc] initWithCapacity:4];
        _accumulatorTimes = [[NSMutableDictionary alloc] initWithCapacity:4];
    }
    return self;
}

- (void)dealloc
{
}
- (void)setDelegate:(id)iDelegate
{
    _delegate = iDelegate;
    
    [self setTimer:XYTimer_default delegate:iDelegate];
}
-(void) setTimer:(NSString *)key delegate:(id)iDelegate{
    if (iDelegate) {
        [_delegates setObject:iDelegate forKey:key];
    }else{
        [_delegates removeObjectForKey:key];
    }
}
-(void) startTimerWithInterval:(NSTimeInterval)ti{
    [self startTimer:XYTimer_default interval:ti];
}
-(void) stopTimer{
    [self stopTimer:XYTimer_default];
}
-(void) pauseTimer{
    [self pauseTimer:XYTimer_default];
}
-(void) resumeTimer{
    [self resumeTimer:XYTimer_default];
}
-(void) runDefaultTimer:(NSTimer *)timer{
    NSString *key = timer.userInfo;
    
    float f = [[_accumulatorTimes objectForKey:key] floatValue];
    f += timer.timeInterval;
    [_accumulatorTimes setObject:@(f) forKey:key];
    
   // NSLogD(@"%@:%f", key, f);
    id delegate = [_delegates objectForKey:key];
    
    if (delegate && [delegate respondsToSelector:@selector(onTimer:time:)]) {
        [delegate onTimer:key time:f];
    }
    
}

// 特定的定时器
-(void) startTimer:(NSString *)key interval:(NSTimeInterval)ti{
    NSTimer *timer = [_timers objectForKey:key];
    if (timer) {
        float f = [[_accumulatorTimes objectForKey:key] floatValue];
        [self stopTimer];
        [_accumulatorTimes setObject:@(f) forKey:key];
    }else{
        [_accumulatorTimes setObject:@(0) forKey:key];
    }
    
    NSDate *date = [NSDate date];
    timer = [[NSTimer alloc] initWithFireDate:date interval:ti target:self selector:@selector(runDefaultTimer:) userInfo:key repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    [_timers setObject:timer forKey:key];
}
-(void) stopTimer:(NSString *)key{
    NSTimer *timer = [_timers objectForKey:key];
    if (timer) {
        [timer invalidate];
        [_timers removeObjectForKey:key];
        timer = nil;
        [_accumulatorTimes removeObjectForKey:key];
        [_delegates removeObjectForKey:key];
    }
}
-(void) pauseTimer:(NSString *)key{
    NSTimer *timer = [_timers objectForKey:key];
    if (timer) {
        [timer setFireDate:[NSDate distantFuture]];
    }
}
-(void) resumeTimer:(NSString *)key{
    NSTimer *timer = [_timers objectForKey:key];
    if (timer) {
        [timer setFireDate:[NSDate date]];
    }
}
-(void) stopAllTimer{
    [_timers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSTimer *timer = (NSTimer *)obj;
        [timer invalidate];
    }];
    [_timers removeAllObjects];
    [_accumulatorTimes removeAllObjects];
    [_delegates removeAllObjects];
}
@end
