//
//  XYBaseListData.m
//  JoinShow
//
//  Created by Heaven on 14-8-21.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#define kXYBaseListData_assert 1
#define kXYBaseListData_MaxFetchCount 3

#import "XYBaseListData.h"
#import "XYDebug.h"

@interface XYBaseListData ()

@property (nonatomic, assign) NSInteger sequence;       // 当前操作的序列号
@property (nonatomic, assign) NSInteger locationOffset;       // 拉取偏移量：如果data中缓存的第1个数据实际对应于服务器保存的第i个数据，那么拉取偏移量就是i
@property (nonatomic, assign) NSInteger destCountOfData;
@property (nonatomic, assign) NSInteger loadedCount;
@property (nonatomic, assign) NSInteger fetchCount;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) NSMutableArray *loadedData;
@property (nonatomic, strong) NSMutableDictionary *dataTable;

@end


@implementation XYBaseListData

#pragma mark - Private Function
-(id) initWithDelegate:(id<XYBaseListDataDelegate>)delegate{

    if(self = [super init])
    {
        _data = [NSMutableArray arrayWithCapacity:128];
        _loadedData = [NSMutableArray arrayWithCapacity:128];
        _dataTable = [NSMutableDictionary dictionaryWithCapacity:128];
        _delegate = delegate;
    }
    
    return self;
}

// 重置状态
- (void)resetState
{
    _fetchCount = 0;
    _loadedCount = 0;
    _destCountOfData = 0;
    [_loadedData removeAllObjects];
    
    _isAvailable = YES;
    _currentOperation = XYBaseListDataOperationNone;
}


- (void)resetCache
{
    [(NSMutableArray *)_data removeAllObjects];
    [_loadedData removeAllObjects];
    [_dataTable removeAllObjects];
    _locationOffset = 0;
    _isAllDataLoaded = NO;
    [self resetState];
}

- (void)appendData:(NSArray *)array
{
    NSInteger i;
    NSString* dataKey;
    for(i = 0 ; i < array.count; ++i)
    {
        dataKey = [self keyForObject:array[i]];
        [_dataTable setObject:[NSNumber numberWithInteger:_data.count] forKey:dataKey];
        [(NSMutableArray *)_data addObject:array[i]];
    }
}

-(BOOL) checkAndFetchMoreData
{
    if((_loadedCount < _destCountOfData) && (_fetchCount < kXYBaseListData_MaxFetchCount)) {
        _fetchCount++;
        NSLogD(@"loadDataWithRange {loc=%i  len=%i}", (_data.count + _locationOffset), (_destCountOfData - _loadedCount));
        [self loadDataOperationWithRange:NSMakeRange((_data.count + _locationOffset), (_destCountOfData - _loadedCount))];
        
        return YES;
    }
    
    return NO;
}

- (void)handleLoadedData:(NSArray *)newData
{
    
}

- (void)handleRemovedData:(NSArray *)removedData{
    [(NSMutableArray *)_data removeObjectsInArray:removedData];
    [self resetState];
    [self.delegate listData:self didFinishOperation:XYBaseListDataOperationRemove data:removedData];
}

- (void)finishOperationWithArray:(NSArray *)array{
    if((array == nil) || ([array isKindOfClass:[NSArray class]] == NO))
    {
        [self resetState];
        [self.delegate listData:self didFinishOperation:_currentOperation data:nil];
        
        return;
    }

        switch(_currentOperation)
        {
            case XYBaseListDataOperationReload:
            case XYBaseListDataOperationLoadMore:
                [self handleLoadedData:array];
                break;
                
            case XYBaseListDataOperationRemove:
                [self handleRemovedData:array];
                break;
                
            default:
                break;
        }
}
#pragma mark - Public Function

- (NSArray *)data
{
    return _data;
}


- (BOOL)reloadDataWithCount:(NSInteger)count {
    if(_isAvailable) {
        [self resetCache];
        
        if(self.delegate != nil)
        {
            _isAvailable = NO;
            _currentOperation = XYBaseListDataOperationReload;
            
            _loadedCount = 0;
            _destCountOfData = count;
            [self loadDataOperationWithRange:NSMakeRange(0, count)];
            
            return YES;
        }
    }
    return NO;
}


- (BOOL)loadMoreDataWithCount:(NSInteger)count
{
    if(_isAvailable)
    {
        if(_data.count <= 0)
        {
            return [self reloadDataWithCount:count];
        }
        
        if(self.delegate != nil)
        {
            _isAvailable = NO;
            _currentOperation = XYBaseListDataOperationReload;
            
            _loadedCount = 0;
            _destCountOfData = count;
            NSLogD(@"loadDataWithRange {loc=%i  len=%i}", (_data.count + _locationOffset), count);
            [self loadDataOperationWithRange:NSMakeRange((_data.count + _locationOffset), count)];
            
            return YES;
        }
    }
    return NO;
}


- (BOOL)removeData:(NSArray *)data
{
    if(_isAvailable)
    {
        if(self.delegate != nil)
        {
            _isAvailable = NO;
            _currentOperation = XYBaseListDataOperationRemove;
            [self removeDataOperation:data];
            
            return YES;
        }
    }
    return NO;
}


- (void)stopCurrentOperation
{
    _sequence++;
    [self resetState];
}

#pragma mark - Protected Function
// 单个数据的key, 要保证能够唯一的区分数据
-(NSString *) keyForObject:(id)anObject{
    NSAssert(kXYBaseListData_assert, @"请实现这个方法");
    return nil;
}

// 定义数据的排序规则
-(NSComparisonResult) compareObject:(id)firstObject withObject:(id)secendObject{
    NSAssert(kXYBaseListData_assert, @"请实现这个方法");
    return NSOrderedSame;
}
// 加载数据的实际操作
- (void)loadDataOperationWithRange:(NSRange)range{
    NSAssert(kXYBaseListData_assert, @"请实现这个方法");
    // 先从 range 取到 array
    [self finishOperationWithArray:nil];
}
// 删除数据的实际操作
- (void)removeDataOperation:(NSArray *)data{
    NSAssert(kXYBaseListData_assert, @"请实现这个方法");
    //
    [self finishOperationWithArray:nil];
}

@end
