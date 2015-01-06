//
//  NSSet+XY.m
//  JoinShow
//
//  Created by Heaven on 14-8-1.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import "NSSet+XY.h"
#import "XYCommonDefine.h"
#import <objc/runtime.h>

static const void *__XYRetainNoOp(CFAllocatorRef allocator, const void *value) { return value; }
static void __XYReleaseNoOp(CFAllocatorRef allocator, const void *value) { }

@implementation NSSet (XY)

+ (NSMutableSet *)nonRetainSet{
    CFSetCallBacks callbacks = kCFTypeSetCallBacks;
    callbacks.retain         = __XYRetainNoOp;
    callbacks.release        = __XYReleaseNoOp;
    
    return  (__bridge_transfer NSMutableSet*)CFSetCreateMutable(nil, 0, &callbacks);
}


@end

@implementation NSMutableSet (XY)

- (NSSet *)immutable
{
    object_setClass(self, [NSSet class]);
    return self;
}

@end
