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
        _data = [[NSMutableArray alloc] initWithCapacity:64];
        //_fromIndex = 0;
        //_toIndex = 0;
        _loadLimitOfDatabase = 100;
        _loadLimitOfServer = 10;
    }
    return self;
}

- (void)dealloc
{
    NSLogDD
    [_data removeAllObjects];
    [_data release];
    _delegate = nil;
    [self.requestHelper cancelAllOperations];
    self.requestHelper = nil;
    [super dealloc];
}

#pragma mark - 子类重载下面的方法
// 单例
DEF_SINGLETON(EntityModel)

// net
// 刷新
-(void) refreshFromServerLimit:(int)limit{
    HttpRequest *hr = [self.requestHelper get:@"json_joybooks.php"];
    __block EntityModel *mySelf = self;
    [hr succeed:^(MKNetworkOperation *op) {
        NSString *str = [op responseString];
        if([op isCachedResponse]) {
            NSLogD(@"cache");
            /*
             [mySelf.data removeAllObjects];
             NSArray *array = [str toModels:mySelf.dataClass];
             [mySelf.data addObjectsFromArray:array];
             */
            Delegate(entityModelRefreshFromServerSucceed:, mySelf);
        }
        else {
            [mySelf.data removeAllObjects];
            NSArray *array = [str toModels:mySelf.dataClass];
            [mySelf.data addObjectsFromArray:array];
            [mySelf.data saveAllToDB];
            Delegate(entityModelRefreshFromServerSucceed:, mySelf);
        }
    } failed:^(MKNetworkOperation *op, NSError *err) {
        NSLogD(@"%@", err);
        Delegate(entityModelRefreshFromServerFailed:error:, mySelf, err);
    }];
    [self.requestHelper submit:hr];
}
// 加载
-(void) loadFromServerFrom:(int)from
                        to:(int)to{
    
}

// Database
// 刷新
-(void) refreshFromDatabaseLimit:(int)limit{
    
}
// 加载
-(void) loadFromDatabaseFrom:(int)from
                          to:(int)to{
    
}
@end
