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

@implementation XYSignal

+ (id)signalWithName:(NSString *)name
{
    return nil;
}

- (BOOL)send
{
    NSString *string = [NSString stringWithFormat:@"__uxy_handleSignal_%@:", _name];
    SEL sel = NSSelectorFromString(string);
    if ([self respondsToSelector:sel])
    {
        NSMethodSignature *methodSignature = [[self class] instanceMethodSignatureForSelector:sel];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        [invocation setTarget:self];
        [invocation setSelector:sel];
        int arg1 =  2;
        [invocation setArgument:&arg1 atIndex:2];//参数从2开始，index 为0表示target，1为_cmd
        id resultString = nil;
        [invocation invoke];
        [invocation getReturnValue:&resultString];
    }


    return YES;
}
@end

#pragma mark- UXYSignalHandler
@interface NSObject (UXYSignalHandler) <XYSignalTarget>
@property (nonatomic, weak) id uxy_nextSignalHandler;
@end

@implementation NSObject (UXYSignalHandler)

@dynamic uxy_nextSignalHandler;

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
    
    
    return YES;
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

- (void)setUxy_nextSignalHandler:(id)nextSignalHandler
{
    objc_setAssociatedObject(self, kUXYSignalHandler_key, nextSignalHandler, OBJC_ASSOCIATION_ASSIGN);
}

- (id)uxy_nextSignalHandler
{
    return objc_getAssociatedObject(self, kUXYSignalHandler_key);
}

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

- (id)uxy_defaultNextSignalHandler
{
    return nil;
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
    id defaultNext;
    
    if ([self isKindOfClass:[UINavigationController class]])
    {
        //defaultNext = [(UINavigationController *)self topViewController];
    }
    else
    {
        defaultNext = [self parentViewController];
    }
    
    return defaultNext;
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
