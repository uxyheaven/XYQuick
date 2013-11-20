//
//  DownloadRequest.m
//  JoinShow
//
//  Created by Heaven on 13-11-20.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import "DownloadRequest.h"

@implementation DownloadRequest
+(id) defaultSettings{
    // 参考
    DownloadHelper *eg = [[[DownloadHelper alloc] initWithHostName:@"testbed1.mknetworkkit.com" customHeaderFields:@{@"x-client-identifier" : @"iOS"}] autorelease];
    return eg;
}
@end
