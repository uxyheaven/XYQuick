//
//  XYBaseDataSource.m
//  JoinShow
//
//  Created by Heaven on 14/11/4.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import "XYBaseDataSource.h"
#import <objc/runtime.h>
#import <objc/message.h>

#import "XYFileCache.h"
#import "XYBaseDao.h"



#define kXYBaseModelSerialBackQueue "com.XY.dataSourceSerialBackQueue"
#define kXYBaseModelConcurrentBackQueue "com.XY.dataGeConcurrenttBackQueue"


#pragma mark - XYBaseDataSource
@interface XYBaseDataSource ()

@property (nonatomic, strong) dispatch_queue_t serialBackQueue;          // 串行队列
@property (nonatomic, strong) dispatch_queue_t concurrentBackQueue;      // 并行队列

@end


@implementation XYBaseDataSource

- (instancetype)init
{
    self = [super init];
    if (self) {
        _serialBackQueue     = [[self class] serialBackQueue];
        _concurrentBackQueue = [[self class] concurrentBackQueue];
    }
    return self;
}

// 串行队列
+ (dispatch_queue_t)serialBackQueue
{
    static dispatch_once_t once;
    static dispatch_queue_t queue;
    dispatch_once(&once, ^ {
        queue = dispatch_queue_create(kXYBaseModelSerialBackQueue, DISPATCH_QUEUE_SERIAL);
    });
    
    return queue;
}

// 并行队列
+ (dispatch_queue_t)concurrentBackQueue
{
    static dispatch_once_t once;
    static dispatch_queue_t queue;
    dispatch_once(&once, ^ {
        queue = dispatch_queue_create(kXYBaseModelConcurrentBackQueue, DISPATCH_QUEUE_CONCURRENT);
    });
    
    return queue;
}

- (void)startGetData
{
    /*
    _state = 1;
    dispatch_async(dispatch_Source_main_queue(), ^{
        if (_delegate && [_delegate respondsToSelector:@selector(dataSource:state:text:)])
        {
            [_delegate dataSource:self state:_state text:nil];
        }
    });
     */
}

- (void)forwardDataSourceData:(id)data
{
    if (_filter.length > 0)
    {
        NSString *selectorName = [NSString stringWithFormat:@"%@_dataSource:didGetData:", _filter];
        SEL selector           = NSSelectorFromString(selectorName);
        if (_delegate && [_delegate respondsToSelector:selector])
        {
            void (*action)(id, SEL, ...) = (void (*)(id, SEL, ...)) objc_msgSend;
            action(_delegate, selector, self, data);
        }
    }
    else
    {
        [self.delegate dataSource:self didGetData:data];
    }
}

- (void)forwardDataError:(NSError *)error
{
    if (_filter.length > 0)
    {
        NSString *selectorName = [NSString stringWithFormat:@"%@_dataSource:error:", _filter];
        SEL selector           = NSSelectorFromString(selectorName);
        if (_delegate && [_delegate respondsToSelector:selector])
        {
            void (*action)(id, SEL, ...) = (void (*)(id, SEL, ...)) objc_msgSend;
            action(_delegate, selector, self, error);
        }
    }
    else
    {
        [self.delegate dataSource:self error:error];
    }
}

- (void)callbackInMainQueueWithdata:(id)data error:(NSError *)error
{
    dispatch_async(dispatch_get_main_queue(),  ^{
        if (data != nil)
        {
            [self forwardDataSourceData:data];
        }
        else
        {
            [self forwardDataError:error];
        }
    });
}

@end


#pragma mark - XYFileDataSource
@interface XYFileDataSource ()

@property (nonatomic, strong) XYFileCache *fileCache;

@end

@implementation XYFileDataSource

- (instancetype)init
{
    self = [super init];
    if (self) {
        _fileCache = [[self class] fileCache];
    }
    return self;
}

+ (id)fileDataSourceWithDelegate:(id)delegate fileKey:(NSString *)key
{
    XYFileDataSource *dataSource = [[[self class] alloc] init];
    dataSource.delegate       = delegate;
    dataSource.fileKey        = key;
    
    return dataSource;
}

+ (XYFileCache *)fileCache
{
    static dispatch_once_t once;
    static XYFileCache *cache;
    dispatch_once(&once, ^ {
        cache = [[XYFileCache alloc] initWithNamespace:@"XYFileDataSource"];
    });
    
    return cache;
}

- (void)startGetData
{
    [super startGetData];
    NSAssert(_dataClass, @"dataClass 必须有值啊");
    
    dispatch_async(self.serialBackQueue, ^{
        id value =  [_fileCache objectForKey:_fileKey objectClass:_dataClass];
        
        [self callbackInMainQueueWithdata:value error:nil];
    });
}

@end


#pragma mark - XYDBDataSource

@interface XYDBDataSource ()

@property (nonatomic, strong) XYBaseDao *dao;

@end

@implementation XYDBDataSource


+ (id)dbDataSourceWithDelegate:(id)delegate dataClass:(Class)dataClass
{
    XYDBDataSource *dataSource = [[[self class] alloc] init];
    dataSource.delegate        = delegate;
    dataSource.dataClass       = dataClass;
    
    return dataSource;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _offset = 0;
        _count  = 20;
    }
    return self;
}

- (void)startGetData
{
    NSAssert(_dataClass, @"dataClass 必须有值啊");
    
    if (_dao == nil)
        _dao = [XYBaseDao daoWithEntityClass:_dataClass];
    
    dispatch_async(self.serialBackQueue, ^{
        NSArray *array = [_dao loadEntityWithWhere:_where order:_order offset:_offset count:_count];
        
        [self callbackInMainQueueWithdata:array error:nil];
    });
}


@end

#pragma mark- XYNetDataSource

@interface XYNetDataSource ()


@end

@implementation XYNetDataSource

@end


