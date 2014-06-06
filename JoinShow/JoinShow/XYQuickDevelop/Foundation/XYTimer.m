//
//  XYTimer.m
//  JoinShow
//
//  Created by Heaven on 13-9-8.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import "XYTimer.h"
#import "NSDictionary+XY.h"
#import "NSArray+XY.h"

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

void (*XYTimer_action)(id, SEL, ...) = (void (*)(id, SEL, ...))objc_msgSend;

#pragma mark - XYTimer
@interface XYTimer2 ()

@property (nonatomic, weak) id target;                  //
@property (nonatomic, assign) SEL selector;             //
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) id sender;                // 来源
@property (nonatomic, assign) NSTimeInterval time;      // 累计时间

@property (nonatomic ,assign) NSTimeInterval start_at;  // 开始时间

@property (nonatomic, copy) XYTimer_block block;

-(void) handleTimer:(NSTimer *)timer;

@end

@implementation XYTimer

-(void) handleTimer:(NSTimer *)timer{
    NSTimeInterval ti = [NSDate date] - _start_at;
    
    if (_block) {
        _block(self , ti);
        return;
    }
    
    XYTimer_action(_target, _selector, self, ti);
}


-(void) dealloc{
    if (_timer.isValid){
        [_timer invalidate];
    }
}

@end

#pragma mark - NSObject(XYTimer)
@implementation NSObject(XYTimer)

@dynamic XYtimers;

-(NSMutableDictionary *) XYtimers{
    id object = objc_getAssociatedObject(self, NSObject_notifications);
    
    if (nil == object) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:8];
        objc_setAssociatedObject(self, NSObject_XYTimers, dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return dic;
    }
    
    return object;
}

-(NSTimer *) timer:(NSTimeInterval *)interval{
   return [self timer:interval repeat:NO];
}

-(NSTimer *) timer:(NSTimeInterval *)interval repeat:(BOOL)repeat{
   return [self timer:interval repeat:repeat name:@""];
}

-(NSTimer *) timer:(NSTimeInterval *)interval repeat:(BOOL)repeat name:(NSString *)name{
    
}

-(void) cancelTimer:(NSString *)name{
    
}

-(void) cancelAllTimer{
    
}

@end

#pragma mark - XYTicker

@interface XYTicker(){
    
}

@property (nonatomic, strong) NSMutableArray *receivers;

@end

@implementation XYTicker

DEF_SINGLETON( XYTicker )

- (instancetype)init
{
    self = [super init];
    if (self) {
        _interval = 1.0 / 8.0;
        _receivers = [NSMutableArray nonRetainingArray];
    }
    return self;
}

-(void) addReceiver:(NSObject *)obj
{
	if ( NO == [_receivers containsObject:obj] )
	{
		[_receivers addObject:obj];
		
		if ( nil == _timer )
		{
			_timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(performTick)];
			[_timer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
			
			_timestamp = [NSDate timeIntervalSinceReferenceDate];
		}
	}
}

-(void) removeReceiver:(NSObject *)obj
{
	[_receivers removeObject:obj];
	
	if ( 0 == _receivers.count )
	{
		[_timer invalidate];
		_timer = nil;
	}
}

- (void)performTick
{
	NSTimeInterval tick = [NSDate timeIntervalSinceReferenceDate];
	NSTimeInterval elapsed = tick - _timestamp;
    
	if ( elapsed >= _interval )
	{
		NSArray * array = [NSArray arrayWithArray:_receivers];
        
		for ( NSObject * obj in array )
		{
			if ( [obj respondsToSelector:@selector(handleTick:)] )
			{
				[obj handleTick:elapsed];
			}
		}
        
		_timestamp = tick;
	}
}

@end

@implementation NSObject(XYTicker)

-(void) observeTick
{
	[[XYTicker sharedInstance] addReceiver:self];
}

-(void) unobserveTick
{
	[[XYTicker sharedInstance] removeReceiver:self];
}

-(void) handleTick:(NSTimeInterval)elapsed
{
}

@end

