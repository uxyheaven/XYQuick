//
//  XYEvent.m
//  JoinShow
//
//  Created by XingYao on 15/7/1.
//  Copyright (c) 2015年 Heaven. All rights reserved.
//

#import "XYEvent.h"
#import "XYQuick.h"

#pragma mark -XYEventVO
@interface XYActionVO : NSObject

@property (nonatomic, copy) NSString *event;
@property (nonatomic, strong) id target;        // 先用strong测试, 记得修改
@property (nonatomic, assign) SEL action;
@property (nonatomic, copy) void(^block)(void);

@property (nonatomic, weak) XYActionVO *nextResponder;

- (void)invoke;

@end

@implementation XYActionVO

- (void)invoke
{
    [_target performSelectorInBackground:_action withObject:nil];
}

- (BOOL)isEqual:(id)object
{
    XYActionVO *vo = object;
    
    return [_event isEqualToString:vo.event] && (_target == vo.target) && (_action == vo.action);
}
@end

#pragma mark-

@interface XYActionOperation : NSOperation
@property (nonatomic, copy, readonly) NSString *mark;
@property (nonatomic, assign) NSTimeInterval second;
@property (nonatomic, strong) XYActionVO *vo;
@end

@implementation XYActionOperation
- (instancetype)initWithEventVO:(XYActionVO *)vo time:(NSTimeInterval)second
{
    self = [super init];
    if (self) {
        _vo = vo;
        _second = second;
    }
    return self;
}
- (void)main
{
    @autoreleasepool
    {
        sleep(_second);
        [_vo invoke];
        NSLog(@"%@, %f", _vo.event, _second);
    }
}
- (void)dealloc
{
    NSLog(@"%@, dealloc", _vo.event);
}

@end

#pragma mark -XYEventCenter
@interface XYEventCenter ()

@property (nonatomic, strong) NSOperationQueue *actionQueue;
@property (nonatomic, strong) NSMutableDictionary *eventInfos;

@end

@implementation XYEventCenter

+ (instancetype)defaultCenter
{
    static dispatch_once_t once;
    static id __singleton__;
    dispatch_once( &once, ^{ __singleton__ = [[self alloc] init]; } );
    return __singleton__;
}

- (void)addTarget:(id)target action:(SEL)action forEvent:(NSString *)event
{
#ifdef DEBUG
    NSAssert((target != nil), @"error");
    NSAssert([target respondsToSelector:action], @"error");
    NSAssert((event.length != 0), @"error");
#else
    if (target == nil) return;
    if (![target respondsToSelector:action]) return;
    if (event.length == 0) return;
#endif
    
    NSMutableArray *mArray = self.eventInfos[event] ?: [@[] mutableCopy];
    self.eventInfos[event] = mArray;
    
    BOOL contain = NO;
    for (XYActionVO *tmpVO in mArray)
    {
         if (tmpVO.target == target && tmpVO.action == action)
         {
             contain = YES;
             break;
         }
    }
    if (contain) return;
    
    XYActionVO *vo = [[XYActionVO alloc] init];
    vo.target = target;
    vo.action = action;
    vo.event = event;
    
   // ((XYActionVO *)[mArray lastObject]).nextResponder = vo;
    [mArray addObject:vo];
}

- (void)removeTarget:(id)target action:(SEL)action forEvent:(NSString *)event
{
#ifdef DEBUG
    NSAssert((target != nil), @"error");
    NSAssert([target respondsToSelector:action], @"error");
    NSAssert((event.length != 0), @"error");
#else
    if (target == nil) return;
    if (![target respondsToSelector:action]) return;
    if (event.length == 0) return;
#endif
    
    NSMutableArray *mArray = self.eventInfos[event];
    if (mArray.count < 1) return;
    
    [mArray enumerateObjectsUsingBlock:^(XYActionVO *vo, NSUInteger idx, BOOL *stop) {
        if (vo.target == target && vo.action == action)
        {
            [mArray removeObject:vo];
        }
    }];
}

- (void)removeAllEventsAtTarget:(id)target
{
    [self.eventInfos enumerateKeysAndObjectsUsingBlock:^(id key, NSMutableArray *mArray, BOOL *stop) {
        [mArray enumerateObjectsUsingBlock:^(XYActionVO *vo, NSUInteger idx, BOOL *stop) {
            if (vo.target == target)
            {
                [mArray removeObject:vo];
            }
        }];
    }];
}

- (void)sendAction:(SEL)action to:(id)target forEvent:(NSString *)event
{
#ifdef DEBUG
    NSAssert((target != nil), @"error");
    NSAssert([target respondsToSelector:action], @"error");
    NSAssert((event.length != 0), @"error");
#else
    if (target == nil) return;
    if (![target respondsToSelector:action]) return;
    if (event.length == 0) return;
#endif
    NSMutableArray *mArray = self.eventInfos[event];
    [mArray enumerateObjectsUsingBlock:^(XYActionVO *vo, NSUInteger idx, BOOL *stop) {
        if (vo.target == target && vo.action == action)
        {
            XYActionOperation *op = [[XYActionOperation alloc] initWithEventVO:vo time:1];
            [self.actionQueue addOperation:op];
        }
    }];
}

- (void)sendActionsForEvent:(NSString *)event
{
#ifdef DEBUG
    NSAssert((event.length != 0), @"error");
#else
    if (event.length == 0) return;
#endif
    NSMutableArray *mArray = self.eventInfos[event];
    [mArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        XYActionVO *vo = obj;
        XYActionOperation *op = [[XYActionOperation alloc] initWithEventVO:vo time:1];
        [self.actionQueue addOperation:op];
    }];
}

#pragma mark - private

#pragma mark - getter setter
- (NSOperationQueue *)actionQueue
{
    if (_actionQueue == nil)
    {
        _actionQueue = [[NSOperationQueue alloc] init];
        _actionQueue.maxConcurrentOperationCount = 3;
    };
    return _actionQueue;
}
- (NSMutableDictionary *)eventInfos
{
    if (_eventInfos == nil)
    {
        _eventInfos = [@{} mutableCopy];
    }
    return _eventInfos;
}
@end

#pragma mark -
#if (1 == __XY_DEBUG_UNITTESTING__)
// ----------------------------------
// Unit test
// ----------------------------------
#import "XYUnitTest.h"

UXY_TEST_CASE( Core, XYEventCenter )
{
    //	TODO( "test case" )
}

UXY_DESCRIBE( test1 )
{
    XYEventCenter *center = [XYEventCenter defaultCenter];
    [center addTarget:self action:@selector(doSomething) forEvent:@"a"];
   // [center sendActionsForEvent:@"a"];
}

UXY_DESCRIBE( test2 )
{
    XYEventCenter *center = [XYEventCenter defaultCenter];
    [center addTarget:self action:@selector(doSomething) forEvent:@"a"];
    [center removeTarget:self action:@selector(doSomething) forEvent:@"a"];
}

UXY_DESCRIBE( test3 )
{
    // UXY_EXPECTED( [@"123" isEqualToString:@"123456"] );
    XYEventCenter *center = [XYEventCenter defaultCenter];
    [center addTarget:self action:@selector(doSomething) forEvent:@"a"];
    [center addTarget:self action:@selector(doSomething) forEvent:@"a"];
    [center removeAllEventsAtTarget:self];
}

- (void)doSomething
{
    NSLog(@"%s", __func__);
}

UXY_TEST_CASE_END

#endif

