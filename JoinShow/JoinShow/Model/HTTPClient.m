//
//  HTTPClient.m
//  KeyLinks2
//
//  Created by Heaven on 14-3-12.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import "HTTPClient.h"

@implementation HTTPClient __DEF_SINGLETON

- (instancetype)init
{
    self = [super initWithHostName:@"www.webxml.com.cn" customHeaderFields:@{@"x-client-identifier" : @"ipad"}];
    if (self) {
        self.freezable = YES;
        self.forceReload = NO;
    }
    return self;
}

@end

/////

@implementation HTTPClient2 __DEF_SINGLETON

- (instancetype)init
{
    self = [super initWithHostName:@"www.webxml.com.cn" customHeaderFields:@{@"x-client-identifier" : @"ipad"}];
    if (self) {
        self.freezable = YES;
        self.forceReload = NO;
    }
    return self;
}

@end

@implementation HTTPClient3 __DEF_SINGLETON

- (instancetype)init
{
    self = [super initWithHostName:nil customHeaderFields:@{@"x-client-identifier" : @"ipad"}];
    if (self) {
        [self setup];
    }
    return self;
}

@end
