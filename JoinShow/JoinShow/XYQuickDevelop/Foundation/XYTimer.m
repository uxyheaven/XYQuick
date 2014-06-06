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


void (*XYTimer_action)(id, SEL, ...) = (void (*)(id, SEL, ...))objc_msgSend;

#pragma mark - XYTimer
@interface XYTimer ()

@property (nonatomic, weak) id target;                  //
@property (nonatomic, assign) SEL selector;             //
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) id sender;                // 来源
@property (nonatomic, assign) NSTimeInterval time;      // 累计时间

@property (nonatomic ,assign) NSTimeInterval start_at;  // 开始时间

@property (nonatomic, copy) XYTimer_block block;

-(void) handleTimer;

-(void) stop;

@end

@implementation XYTimer

-(void) stop{
    if (_timer.isValid){
        [_timer invalidate];
    }
}
-(void) handleTimer{
    NSTimeInterval ti = [[NSDate date] timeIntervalSince1970] - _start_at;
    
    if (_block) {
        _block(self, ti);
        return;
    }
    
    XYTimer_action(_target, _selector, self, ti);
}


-(void) dealloc{

}

@end

#pragma mark - NSObject(XYTimer)
@implementation NSObject(XYTimer)

@dynamic XYtimers;

-(NSMutableDictionary *) XYtimers{
    id object = objc_getAssociatedObject(self, NSObject_XYTimers);
    
    if (nil == object) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:8];
        objc_setAssociatedObject(self, NSObject_XYTimers, dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return dic;
    }
    
    return object;
}

-(NSTimer *) timer:(NSTimeInterval)interval{
   return [self timer:interval repeat:NO];
}

-(NSTimer *) timer:(NSTimeInterval)interval repeat:(BOOL)repeat{
   return [self timer:interval repeat:repeat name:@""];
}

-(NSTimer *) timer:(NSTimeInterval)interval repeat:(BOOL)repeat name:(NSString *)name{
    NSString *timerName = (name == nil) ? @"" : name;
    
    NSMutableDictionary *timers = self.XYtimers;
    XYTimer *timer2 = timers[timerName];
    
    if (timer2) {
        [self cancelTimer:timerName];
    }

    SEL aSel = NSSelectorFromString([NSString stringWithFormat:@"%@TimerHandle:time:", timerName]);
    
    if (![self respondsToSelector:@selector(aSel)]) {
       // return nil;
    }
    NSDate *date = [NSDate date];
    XYTimer *timer = [[XYTimer alloc] init];
    timer.name = timerName;
    timer.start_at = [date timeIntervalSince1970];
    timer.target = self;
    timer.selector = aSel;
    timer.time = 0;
    timer.timer = [[NSTimer alloc] initWithFireDate:date interval:interval target:timer selector:@selector(handleTimer) userInfo:nil repeats:repeat];
    [[NSRunLoop mainRunLoop] addTimer:timer.timer forMode:NSRunLoopCommonModes];
    
    [timers setObject:timer forKey:timerName];
    
    return timer.timer;
}

-(NSTimer *) timer:(NSTimeInterval)interval repeat:(BOOL)repeat name:(NSString *)name block:(XYTimer_block)block{
    NSString *timerName = (name == nil) ? @"" : name;
    
    NSMutableDictionary *timers = self.XYtimers;
    [self cancelTimer:timerName];
    
    NSDate *date = [NSDate date];
    XYTimer *timer = [[XYTimer alloc] init];
    timer.name = timerName;
    timer.start_at = [date timeIntervalSince1970];
    timer.time = 0;
    timer.block = block;
    timer.timer = [[NSTimer alloc] initWithFireDate:date interval:interval target:timer selector:@selector(handleTimer:) userInfo:nil repeats:repeat];
    [[NSRunLoop mainRunLoop] addTimer:timer.timer forMode:NSRunLoopCommonModes];
    
    [timers setObject:timer forKey:timerName];
    
    return timer.timer;
}

-(void) cancelTimer:(NSString *)name{
    NSString *timerName = (name == nil) ? @"" : name;

    NSMutableDictionary *timers = self.XYtimers;
    XYTimer *timer2 = timers[timerName];
    
    if (timer2) {
        [timer2 stop];
        [timers removeObjectForKey:timerName];
    }
}

-(void) cancelAllTimer{
    NSMutableDictionary *timers = self.XYtimers;
    [timers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [obj stop];
    }];
    
    [timers removeAllObjects];
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

