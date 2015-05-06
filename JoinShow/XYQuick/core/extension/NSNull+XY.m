//
//  NSNull+XY.m
//  JoinShow
//
//  Created by Heaven on 14-4-24.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import "NSNull+XY.h"

#define NSNullObjects @[@"",@0,@{},@[]]

@implementation NSNull (XY_InternalNullExtention)

- (NSMethodSignature*)methodSignatureForSelector:(SEL)selector
{
    NSMethodSignature *signature = [super methodSignatureForSelector:selector];
    
    if (signature != nil)
        return signature;
    
    for (NSObject *object in NSNullObjects)
    {
        signature = [object methodSignatureForSelector:selector];
        if (signature)
        {
            break;
        }
    }
    
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    SEL aSelector = [anInvocation selector];
    
    for (NSObject *object in NSNullObjects)
    {
        if ([object respondsToSelector:aSelector])
        {
            [anInvocation invokeWithTarget:object];
            return;
        }
    }
    
    [self doesNotRecognizeSelector:aSelector];
}

@end
