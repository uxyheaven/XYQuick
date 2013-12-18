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
    @public id <EntityModelDelegate> _delegate;
}
// 单例
XY_SINGLETON(EntityModel)

@property (nonatomic, retain) id data;                                          // 临时存放数据
@property (nonatomic, assign) Class dataClass;                                  // 数据类型
@property (nonatomic, assign) id <EntityModelDelegate> delegate;

@property (nonatomic, retain) RequestHelper *requestHelper;                     // 网络请求,需要自己初始化


#pragma mark - 子类参考demo,重载下面的方法
// 单例的宏需要在子类重写
// DEF_SINGLETON( subclass name )

#pragma mark - net
//-(void) loadFromServer/
#pragma mark - database
//-(void) loadFromDatabase
@end


#pragma mark - EntityModelDelegate
@protocol EntityModelDelegate <NSObject>

// net
-(void) entityModelLoadFromServerSucceed:(EntityModel *)em;
-(void) entityModelLoadFromServerFailed:(EntityModel *)em error:(NSError *)err;

// Database
-(void) entityModelLoadFromDatabaseSucceed:(EntityModel *)em;
-(void) entityModelLoadFromDatabaseFailed:(EntityModel *)em error:(NSError *)err;

@end
