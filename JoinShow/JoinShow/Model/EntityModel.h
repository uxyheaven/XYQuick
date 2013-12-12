//
//  EntityModel.h
//  JoinShow
//
//  Created by Heaven on 13-12-10.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYQuickDevelop.h"

@class RequestHelper;
@protocol EntityModelDelegate;
@interface EntityModel : NSObject{
    @public id <EntityModelDelegate> delegate;
}
// 单例
XY_SINGLETON(EntityModel)

@property (nonatomic, retain) NSMutableArray *data;                           // 数据
@property (nonatomic, assign) Class dataClass;                                // 数据类型
@property (nonatomic, assign) id <EntityModelDelegate> delegate;

@property (nonatomic, retain) RequestHelper *requestHelper;                   // 网络请求,需要自己初始化

//@property (nonatomic, assign, readonly) int fromIndex;                        // 开始的index
//@property (nonatomic, assign, readonly) int toIndex;                          // 结束的index

//@property (nonatomic, assign) int limit;                                    // 初始加载数量

@property (nonatomic, assign) int loadLimitOfDatabase;                  // 每次从数据库读取的数量
@property (nonatomic, assign) int loadLimitOfServer;                    // 每次从网络读取的数量


#pragma mark - 子类参考demo,重载下面的方法
// 单例的宏需要在子类重写
// DEF_SINGLETON( subclass name )

#pragma mark - net
// 刷新
-(void) refreshFromServerLimit:(int)limit;
// 加载
-(void) loadFromServerFrom:(int)from
                        to:(int)to;

#pragma mark - database
// 刷新
-(void) refreshFromDatabaseLimit:(int)limit;
// 加载
-(void) loadFromDatabaseFrom:(int)from
                          to:(int)to;
@end


#pragma mark - EntityModelDelegate
@protocol EntityModelDelegate <NSObject>

// net
// 刷新
-(void) entityModelRefreshFromServerSucceed:(EntityModel *)em;
-(void) entityModelRefreshFromServerFailed:(EntityModel *)em error:(NSError *)err;
// 加载
-(void) entityModelLoadFromServerSucceed:(EntityModel *)em;
-(void) entityModelLoadFromServerFailed:(EntityModel *)em error:(NSError *)err;

// Database
// 刷新
-(void) entityModelRefreshFromDatabaseSucceed:(EntityModel *)em;
-(void) entityModelRefreshFromDatabaseFailed:(EntityModel *)em error:(NSError *)err;
// 加载
-(void) entityModelLoadFromDatabaseSucceed:(EntityModel *)em;
-(void) entityModelLoadFromDatabaseFailed:(EntityModel *)em error:(NSError *)err;

@end
