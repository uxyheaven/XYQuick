//
//  XYAOP.m
//  JoinShow
//
//  Created by Heaven on 14-10-17.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import "XYAOP.h"
#import <objc/runtime.h>
#import <objc/message.h>

typedef enum {
    AOPAspectInspectorTypeBefore = 0,
    AOPAspectInspectorTypeInstead = 1,
    AOPAspectInspectorTypeAfter = 2
}AOPAspectInspectorType;

@interface XYAOP ()

@end


@implementation XYAOP


DEF_SINGLETON(XYAOP);

- (instancetype)init
{
    self = [super init];
    if (self) {
        ;
    }
    return self;
}

- (NSString *)registerClass:(Class)aClass withSelector:(SEL)aSelector type:(AOPAspectInspectorType)type usingBlock:(XYAOP_block)block {
    NSParameterAssert(aClass);
    NSParameterAssert(aSelector);
    NSParameterAssert(block);
    
    // Hook a new method
    if (![self respondsToSelector:[self extendedSelectorWithClass:aClass selector:aSelector]])
    {
        Method method = class_getInstanceMethod(aClass, aSelector);
        NSAssert(method, @"No instance method found for the given selector. Only instance methods can be intercepted.");
        
        IMP implementation;
        NSMethodSignature *methodSignature = [aClass instanceMethodSignatureForSelector:aSelector];
        implementation = class_getMethodImplementation(aClass, aSelector);
        
        
    }
}


- (NSString *)interceptClass:(Class)aClass beforeExecutingSelector:(SEL)selector usingBlock:(XYAOP_block)block
{
    return [self registerClass:aClass withSelector:selector type:AOPAspectInspectorTypeBefore usingBlock:block];
}

- (NSString *)interceptClass:(Class)aClass afterExecutingSelector:(SEL)selector usingBlock:(XYAOP_block)block
{
    return [self registerClass:aClass withSelector:selector type:AOPAspectInspectorTypeAfter usingBlock:block];
}

- (NSString *)interceptClass:(Class)aClass insteadExecutingSelector:(SEL)selector usingBlock:(XYAOP_block)block
{
    return [self registerClass:aClass withSelector:selector type:AOPAspectInspectorTypeInstead usingBlock:block];
}

#pragma mark - Helper methods
- (SEL)extendedSelectorWithClass:(Class)aClass selector:(SEL)selector
{
    NSString *string = [NSString stringWithFormat:@"__%@_%@", NSStringFromClass(aClass), NSStringFromSelector(selector)];
    return NSSelectorFromString(string);
}
#pragma mark - Interceptor registration
// 恢复被拦截的方法的imp
- (void)restoreOriginalMethodWithClass:(Class)aClass selector:(SEL)aSelector {
    Method method = class_getInstanceMethod(aClass, aSelector);
    IMP implementation = class_getMethodImplementation([self class], [self extendedSelectorWithClass:aClass selector:aSelector]);
    method_setImplementation(method, implementation);
}

// 把某方法的imp置空, 以便转发失败,
- (void)interceptMethodWithClass:(Class)aClass selector:(SEL)aSelector {
    Method method = class_getInstanceMethod(aClass, aSelector);
    IMP implementation = (IMP)_objc_msgForward;
    // Change the implementation
    method_setImplementation(method, implementation);
}
@end
