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

#import "XYTimer.h"
#import "NSDictionary+XY.h"
#import "NSArray+XY.h"
#import "NSObject+XY.h"


void (*XYTimer_action)(id, SEL, id, NSTimeInterval) = (void (*)(id, SEL, id, NSTimeInterval))objc_msgSend;

#pragma mark - XYTimer
@interface XYTimer ()

@property (nonatomic, weak) id target;                  //
@property (nonatomic, assign) SEL selector;             //
@property (nonatomic, copy) NSString *name;
//@property (nonatomic, assign) id sender;                // 来源
@property (nonatomic, assign) NSTimeInterval duration;  // 持续时间

@property (nonatomic ,assign) NSTimeInterval start_at;  // 开始时间

@property (nonatomic, copy) XYTimer_block block;

- (void)handleTimer;

- (void)stop;

@end

@implementation XYTimer

- (void)stop
{
    if (_timer.isValid)
    {
       [_timer invalidate];
    }
    
}

- (void)handleTimer
{
    NSTimeInterval ti = [[NSDate date] timeIntervalSince1970] - _start_at;
    
    if (_block)
    {
        _block(self, ti);
        return;
    }
    
    XYTimer_action(_target, _selector, self, ti);
}

@end


#pragma mark - XYTimerContainer
@interface XYTimerContainer : NSObject

@property (nonatomic, strong) XYTimer *timer;

- (instancetype)initWithXYTimer:(XYTimer *)timer;

@end

@implementation XYTimerContainer

-(instancetype) initWithXYTimer:(XYTimer *)timer
{
    self = [super init];
    if (self)
    {
        _timer = timer;
    }
    return self;
}

- (void)dealloc
{
    [_timer stop];
}

@end
#pragma mark - NSObject(XYTimer)
@implementation NSObject(XYTimer)

uxy_staticConstString(NSObject_XYTimers)

- (NSMutableDictionary *)uxy_timers
{
    id object = [self uxy_getAssociatedObjectForKey:NSObject_XYTimers];
    
    if (nil == object)
    {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
        [self uxy_retainAssociatedObject:dic forKey:NSObject_XYTimers];
        return dic;
    }
    
    return object;
}

- (NSTimer *)uxy_timer:(NSTimeInterval)interval name:(NSString *)name
{
   return [self uxy_timer:interval repeat:NO name:name];
}


- (NSTimer *)uxy_timer:(NSTimeInterval)interval repeat:(BOOL)repeat name:(NSString *)name
{
    NSAssert(name.length > 1, @"name 不能为空");
    
    NSMutableDictionary *timers = self.uxy_timers;
    XYTimer *timer2 = timers[name];
    
    if (timer2)
    {
        [self uxy_cancelTimer:name];
    }

    SEL aSel = NSSelectorFromString([NSString stringWithFormat:@"__uxy_handleTimer_%@:duration:", name]);
    
    NSAssert([self respondsToSelector:aSel], @"selector 必须存在");
    
    NSDate *date   = [NSDate date];
    XYTimer *timer = [[XYTimer alloc] init];
    timer.name     = name;
    timer.start_at = [date timeIntervalSince1970];
    timer.target   = self;
    timer.selector = aSel;
    timer.duration = 0;
    timer.timer    = [[NSTimer alloc] initWithFireDate:date interval:interval target:timer selector:@selector(handleTimer) userInfo:nil repeats:repeat];
    [[NSRunLoop mainRunLoop] addTimer:timer.timer forMode:NSRunLoopCommonModes];
    
    XYTimerContainer *container = [[XYTimerContainer alloc] initWithXYTimer:timer];
    
    [timers setObject:container forKey:name];
    
    return timer.timer;
}

- (NSTimer *)uxy_timer:(NSTimeInterval)interval repeat:(BOOL)repeat name:(NSString *)name block:(XYTimer_block)block
{
    NSString *timerName = (name == nil) ? @"" : name;
    
    NSMutableDictionary *timers = self.uxy_timers;
    [self uxy_cancelTimer:timerName];
    
    NSDate *date   = [NSDate date];
    XYTimer *timer = [[XYTimer alloc] init];
    timer.name     = timerName;
    timer.start_at = [date timeIntervalSince1970];
    timer.duration = 0;
    timer.block    = block;
    timer.timer    = [[NSTimer alloc] initWithFireDate:date interval:interval target:timer selector:@selector(handleTimer) userInfo:nil repeats:repeat];
    [[NSRunLoop mainRunLoop] addTimer:timer.timer forMode:NSRunLoopCommonModes];
    
    XYTimerContainer *container = [[XYTimerContainer alloc] initWithXYTimer:timer];
    
    [timers setObject:container forKey:timerName];
    
    return timer.timer;
}

- (void)uxy_cancelTimer:(NSString *)name
{
    NSString *timerName = (name == nil) ? @"" : name;

    NSMutableDictionary *timers = self.uxy_timers;
    XYTimerContainer *timer2 = timers[timerName];
    
    if (timer2)
    {
        [timer2.timer stop];
        [timers removeObjectForKey:timerName];
    }
}

- (void)uxy_cancelAllTimer
{
    [self.uxy_timers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [(XYTimer *)obj stop];
    }];
    
    [self.uxy_timers removeAllObjects];
}

@end

#pragma mark - XYTicker

@interface XYTicker()
{
    
}

@property (nonatomic, strong) NSMutableArray *receivers;

@end

@implementation XYTicker uxy_def_singleton

- (instancetype)init
{
    self = [super init];
    if (self) {
        _interval  = 1.0 / 8.0;
        _receivers = [NSMutableArray uxy_nonRetainingArray];
    }
    return self;
}

- (void)addReceiver:(NSObject *)obj
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

- (void)removeReceiver:(NSObject *)obj
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
    NSTimeInterval tick    = [NSDate timeIntervalSinceReferenceDate];
    NSTimeInterval elapsed = tick - _timestamp;
    
	if ( elapsed >= _interval )
	{
        [_receivers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ( [obj respondsToSelector:@selector(__uxy_handleTick:)] )
            {
                [obj uxy_handleTick:elapsed];
            }
        }];
        
		_timestamp = tick;
	}
}

@end

@implementation NSObject(XYTicker)

- (void)uxy_observeTick
{
	[[XYTicker sharedInstance] addReceiver:self];
}

- (void)uxy_unobserveTick
{
	[[XYTicker sharedInstance] removeReceiver:self];
}

- (void)uxy_handleTick:(NSTimeInterval)elapsed
{
}

@end

