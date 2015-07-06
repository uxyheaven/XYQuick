//
//  XYSignal.m
//  JoinShow
//
//  Created by heaven on 15/2/28.
//  Copyright (c) 2015年 Heaven. All rights reserved.
//

#import "XYSignal.h"
#import <objc/runtime.h>

#define kUXYSignalHandler_key "NSObject.signalHandler.key"

#pragma mark- XYSignal
@implementation XYSignal
@end

#pragma mark- NSObject(__UXYSignalHandler)
@interface NSObject (__UXYSignalHandler) <XYSignalTarget>
@property (nonatomic, weak) id uxy_nextSignalHandler;
@end

@implementation NSObject (__UXYSignalHandler)

- (XYSignal *)uxy_sendSignalWithName:(NSString *)name userInfo:(id)userInfo
{
    return [self uxy_sendSignalWithName:name userInfo:userInfo sender:self];
}

- (XYSignal *)uxy_sendSignalWithName:(NSString *)name userInfo:(id)userInfo sender:(id)sender
{
    XYSignal *signal = [[XYSignal alloc] init];
    signal.sender = sender ?: self;
    signal.name   = name;
    signal.userInfo = userInfo;
    
    [self __uxy_handleSignal:signal];
    
    return signal;
}

#pragma mark- private
- (BOOL)__uxy_performSignal:(XYSignal *)signal
{
    // 1. 普通的
    NSString *string = [NSString stringWithFormat:@"__uxy_handleSignal_n_%@:", signal.name];
    SEL sel = NSSelectorFromString(string);
    if ([self respondsToSelector:sel])
    {
        signal.isReach = YES;
        NSMethodSignature *methodSignature = [[self class] instanceMethodSignatureForSelector:sel];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        [invocation setTarget:self];
        [invocation setSelector:sel];
        [invocation setArgument:&signal atIndex:2];
        [invocation invoke];
        
        return YES;
    }
    
    // 2.协议筛选的
    string = [NSString stringWithFormat:@"__uxy_handleSignal_p_%@:", signal.name];
    sel = NSSelectorFromString(string);
    if ([self respondsToSelector:sel])
    {
        signal.isReach = YES;
        NSMethodSignature *methodSignature = [[self class] instanceMethodSignatureForSelector:sel];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        [invocation setTarget:self];
        [invocation setSelector:sel];
        [invocation setArgument:&signal atIndex:2];
        [invocation invoke];
        
        return YES;
    }
    
    
    return NO;
}

- (id)__uxy_handleSignal:(XYSignal *)signal
{
    id result;
    signal.jump++;
    
    [self __uxy_performSignal:signal];
    
    if (signal.isDead == YES) return nil;
    if (signal.isReach == YES) return nil;
    
    id next = self.uxy_nextSignalHandler ?: self.uxy_defaultNextSignalHandler;
    
    result = [next __uxy_handleSignal:signal];
    
    return result;
}

- (id)uxy_defaultNextSignalHandler
{
    return nil;
}

@dynamic uxy_nextSignalHandler;
- (void)setUxy_nextSignalHandler:(id)nextSignalHandler
{
    objc_setAssociatedObject(self, kUXYSignalHandler_key, nextSignalHandler, OBJC_ASSOCIATION_ASSIGN);
}
- (id)uxy_nextSignalHandler
{
    return objc_getAssociatedObject(self, kUXYSignalHandler_key);
}
@end

#pragma mark - UIView

@implementation UIView (UXYSignalHandler)

- (id)uxy_defaultNextSignalHandler
{
    return self.nextResponder;
}

#pragma mark- private
@end

#pragma mark - UIViewController
@implementation UIViewController (UXYSignalHandler)

- (id)uxy_defaultNextSignalHandler
{
    id result;
    
    if ([self isKindOfClass:[UINavigationController class]])
    {
        //result = [(UINavigationController *)self topViewController];
    }
    else
    {
        result = [self parentViewController];
    }
    
    return result;
}

@end

#pragma mark -
/*
@implementation XYSignalBus
+ (instancetype)defaultBus
{
    static dispatch_once_t once;
    static id __singleton__;
    dispatch_once( &once, ^{ __singleton__ = [[self alloc] init]; } );
    return __singleton__;
}
@end
 */
