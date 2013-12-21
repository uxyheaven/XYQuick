//
//  EntityModel.m
//  JoinShow
//
//  Created by Heaven on 13-12-10.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import "EntityModel.h"
#import "XYQuickDevelop.h"

@interface EntityModel ()

@end

@implementation EntityModel

@synthesize delegate = _delegate;

- (id)init
{
    self = [super init];
    if (self) {
        self.requestHelper = [[[RequestHelper alloc] initWithHostName:@"www.ruby-china.org" customHeaderFields:@{@"x-client-identifier" : @"iOS"}] autorelease];
        [self.requestHelper useCache];
        self.requestHelper.freezable = YES;
        self.requestHelper.forceReload = YES;
    }
    return self;
}

- (void)dealloc
{
    NSLogDD
    self.data = nil;
    self.result = nil;
    self.delegate = nil;
    [self.requestHelper cancelAllOperations];
    self.requestHelper = nil;
    [super dealloc];
}

#pragma mark - 子类重载下面的方法
// 单例
DEF_SINGLETON(EntityModel)


@end
