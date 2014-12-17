//
//  XYBaseModel.m
//  JoinShow
//
//  Created by Heaven on 14-4-25.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import "XYBaseModel.h"
#import "XYFileCache.h"


@interface XYBaseModel ()

@property (nonatomic, strong) dispatch_queue_t dataGetSerialQueue;          // 串行队列
@property (nonatomic, strong) dispatch_queue_t dataGetConcurrentQueue;      // 并行队列

@property (nonatomic, strong) XYFileCache *fileCache;

@end

@implementation XYBaseModel


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _fileCache = [XYFileCache sharedInstance];
    }
    
    return self;
}

- (void)loadDataWith:(XYBaseDataSource *)dataGet
{
    if ([dataGet isKindOfClass:[XYBaseDataSource class]])
    {
        // 文件缓存
        dispatch_async(_dataGetSerialQueue, ^{
            id data = [_fileCache objectForKey:@"1"];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (data)
                {
                    [self dateGet:dataGet data:data];
                }
                else
                {
                    [self dateGet:dataGet getError:nil];
                }
                
            });
        });
    }
}

#pragma mark - Protocol
// 获取数据成功
- (void)dateGet:(id)dateGet data:(id)data
{
    
}
// 获取数据失败
- (void)dateGet:(id)dateGet getError:(NSError *)error
{
    
}
@end
