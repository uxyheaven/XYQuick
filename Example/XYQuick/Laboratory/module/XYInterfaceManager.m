//
//  XYInterfaceManager.m
//  XYQuick
//
//  Created by heaven on 2016/12/22.
//  Copyright © 2016年 xingyao095. All rights reserved.
//

#import "XYInterfaceManager.h"

@interface XYInterfaceManager ()

+ (instancetype)sharedInstance;

@end

@implementation XYInterfaceManager

static id __singleton__objc__token;
static dispatch_once_t __singleton__token__token;
+ (instancetype)sharedInstance
{
    dispatch_once(&__singleton__token__token, ^{ __singleton__objc__token = [[self alloc] init]; });
    return __singleton__objc__token;
}


@end
