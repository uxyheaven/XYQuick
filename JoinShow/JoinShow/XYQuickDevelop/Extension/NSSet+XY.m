//
//  NSSet+XY.m
//  JoinShow
//
//  Created by Heaven on 14-8-1.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import "NSSet+XY.h"
#import "XYCommonDefine.h"

@implementation NSSet (XY)

+(NSMutableSet *) nonRetainSet{
    CFSetCallBacks callbacks = kCFTypeSetCallBacks;
    callbacks.retain         = __XYRetainNoOp;
    callbacks.release        = __XYReleaseNoOp;
    
    return  (__bridge_transfer NSMutableSet*)CFSetCreateMutable(nil, 0, &callbacks);
}

@end
