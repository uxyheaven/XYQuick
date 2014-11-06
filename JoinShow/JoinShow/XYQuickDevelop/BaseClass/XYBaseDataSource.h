//
//  XYBaseDataSource.h
//  JoinShow
//
//  Created by Heaven on 14/11/4.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import <Foundation/Foundation.h>


#define ON_DATA_SUCCEED_1_( __DataSource, __data ) \
    - (void)dataSource:(id)__DataSource didGetData:(id)__data;
#define ON_DATA_FAILED_1_( __DataSource, __error )    \
    - (void)dataSource:(id)__DataSourcet error:(NSError *)__error;

#define ON_DATA_SUCCEED_2_( __filter, __DataSource, __data ) \
    - (void)## __filter##_DataSource:(id)__DataSource didGetData:(id)__data;
#define ON_DATA_FAILED_2_( __filter, __DataSource, __error )    \
    - (void)##__filter##_DataSource:(id)__DataSourcet error:(NSError *)__error;



@protocol XYDataSourceDelegate <NSObject>

// 获取数据成功
- (void)dataSource:(id)dataSource didGetData:(id)data;
// 获取数据失败
- (void)dataSource:(id)dataSource error:(NSError *)error;

@optional

// 状态切换
//- (void)dataSource:(id)dataSource state:(NSInteger)state text:(NSString *)text;

@end

@interface XYBaseDataSource : NSObject

@property (nonatomic, assign, readonly) int state;
@property (nonatomic, weak) id <XYDataSourceDelegate> delegate;
@property (nonatomic, copy) NSString *filter;       // 过滤

// 开始获取数据
- (void)startGetData;

@end

#pragma mark - XYFileDataSource
@interface XYFileDataSource : XYBaseDataSource

@property (nonatomic, copy) NSString *fileKey;      // 必须设置key

@property (nonatomic, weak) Class dataClass;    // 如果设置dataClass, 就用这个类去解析

+ (id)fileDataSourceWithDelegate:(id)delegate fileKey:(NSString *)key;

@end

#pragma mark - XYDBDataSource
@interface XYDBDataSource : XYBaseDataSource

@property (nonatomic, weak) Class dataClass;            // 数据类型, 必须设置

@property (nonatomic, copy) NSString *where;            // 查询条件
@property (nonatomic, copy) NSString *order;            // 排序
@property (nonatomic, assign) NSInteger offset;            // 偏移, 默认0
@property (nonatomic, assign) NSInteger count;            // 数量, 默认 20

+ (id)dbDataSourceWithDelegate:(id)delegate dataClass:(Class)dataClass;

@end

#pragma mark - XYNetDataSource
@interface XYNetDataSource : XYBaseDataSource

@property (nonatomic, copy) NSString *path;             // 路径
@property (nonatomic, copy) NSString *host;             // host
@property (nonatomic, strong) NSDictionary *params;     // 参数
@property (nonatomic, copy) NSString *httpMethod;       // 默认get

@property (nonatomic, assign) BOOL usedCache;           // 使用缓存

@end


