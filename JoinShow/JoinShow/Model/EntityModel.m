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

DEF_SINGLETON(EntityModel)

- (id)init
{
    self = [super init];
    if (self) {
        self.dbHelper = [[self class] getUsingLKDBHelper];
        /*
        self.requestHelper = [[[RequestHelper alloc] initWithHostName:@"www.ruby-china.org" customHeaderFields:@{@"x-client-identifier" : @"iOS"}] autorelease];
        [self.requestHelper useCache];
        self.requestHelper.freezable = YES;
        self.requestHelper.forceReload = YES;
        */
        
        self.array = [NSMutableArray array];
        self.dic = [NSMutableDictionary dictionary];
    }
    return self;
}
+(id) modelWithClass:(Class)aClass{
    EntityModel *aModel = [[[self class] alloc] init];
    
    aModel.dataClass = aClass;
    aModel.dbHelper = [[aClass class] getUsingLKDBHelper];
    //      [dbHelper dropAllTable];
    [aModel.dbHelper createTableWithModelClass:[aClass class]];
    /*
    aModel.requestHelper = [[[RequestHelper alloc] initWithHostName:@"www.ruby-china.org" customHeaderFields:@{@"x-client-identifier" : @"iOS"}] autorelease];
    [aModel.requestHelper useCache];
    aModel.requestHelper.freezable = YES;
    aModel.requestHelper.forceReload = YES;
    */
    
    return aModel;
}

-(RequestHelper *) requestHelper{
    if (nil == _requestHelper) {
        if (_delegate && [_delegate respondsToSelector:@selector(entityModelSetupRequestHelper:)]) {
            self.requestHelper = [_delegate entityModelSetupRequestHelper:self];
        }
    }
    
    return _requestHelper;
}

-(LKDBHelper *) dbHelper{
    if (nil == _dbHelper) {
        if (_delegate && [_delegate respondsToSelector:@selector(entityModelSetupRequestHelper:)]) {
            self.dbHelper = [_delegate entityModelSetupDBHelper:self];
        }
    }
    
    return _dbHelper;
}

- (void)dealloc
{
    NSLogDD
    self.data = nil;
    self.array = nil;
    self.dic = nil;
    self.result = nil;
    self.delegate = nil;
    [self.requestHelper cancelAllOperations];
    self.requestHelper = nil;
    self.dbHelper = nil;
}

#pragma mark - 子类重载下面的方法

@end
