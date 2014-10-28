//
//  XYAOP.h
//  JoinShow
//
//  Created by Heaven on 14-10-17.
//  Copyright (c) 2014年 Heaven. All rights reserved.
// thanks AOP-for-Objective-C

#import <Foundation/Foundation.h>
#import "XYCommonDefine.h"

typedef void(^XYAOP_block)(NSInvocation *invocation);

@interface XYAOP : NSObject

+ (NSString *)interceptClass:(Class)aClass beforeExecutingSelector:(SEL)selector usingBlock:(XYAOP_block)block;
+ (NSString *)interceptClass:(Class)aClass afterExecutingSelector:(SEL)selector usingBlock:(XYAOP_block)block;
+ (NSString *)interceptClass:(Class)aClass insteadExecutingSelector:(SEL)selector usingBlock:(XYAOP_block)block;

+ (void)removeInterceptorWithIdentifier:(NSString *)identifier;

@end
