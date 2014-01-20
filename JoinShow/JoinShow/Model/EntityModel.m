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
    }
    return self;
}
+(id) modelWithClass:(Class)aClass{
    EntityModel *aModel = [[[EntityModel alloc] init] autorelease];
    aModel.dataClass = aClass;
    aModel.dbHelper = [[aClass class] getUsingLKDBHelper];
    //      [dbHelper dropAllTable];
    [aModel.dbHelper createTableWithModelClass:[aClass class]];
    
    aModel.requestHelper = [[[RequestHelper alloc] initWithHostName:@"www.ruby-china.org" customHeaderFields:@{@"x-client-identifier" : @"iOS"}] autorelease];
    [aModel.requestHelper useCache];
    aModel.requestHelper.freezable = YES;
    aModel.requestHelper.forceReload = YES;
    
    return aModel;
}

- (void)dealloc
{
    NSLogDD
    self.data = nil;
    self.result = nil;
    self.delegate = nil;
    [self.requestHelper cancelAllOperations];
    self.requestHelper = nil;
    self.dbHelper = nil;
    [super dealloc];
}

#pragma mark - 子类重载下面的方法

@end
