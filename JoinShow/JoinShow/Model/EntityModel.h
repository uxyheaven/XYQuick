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
@class LKDBHelper;

@protocol EntityModelDelegate;
@interface EntityModel : NSObject{
    //@public id <EntityModelDelegate> _delegate;
}

XY_SINGLETON(EntityModel)

@property (nonatomic, strong) id data;                                          // 数据
@property (nonatomic, assign) Class dataClass;                                  // 数据类型
@property (nonatomic, strong) id result;                                        // 临时数据
@property (nonatomic, strong) NSMutableArray *array;                            // array
@property (nonatomic, strong) NSMutableDictionary *dic;                         // dic

@property (nonatomic, assign) int tag;                                          // 标签
@property (nonatomic, assign) id <EntityModelDelegate> delegate;

@property (nonatomic, strong) RequestHelper *requestHelper;                     // 网络请求,需要自己初始化
@property (nonatomic, strong) LKDBHelper    *dbHelper;                          // 数据库帮助类


#pragma mark -

+(id) modelWithClass:(Class)aClass;

#pragma mark - net
//-(void) loadFromServer/
#pragma mark - database
//-(void) loadFromDatabase
@end


#pragma mark - EntityModelDelegate
@protocol EntityModelDelegate <NSObject>

// 可选实现
@optional
// 用 tag 来区别哪的数据
-(void) entityModelLoadSucceed:(EntityModel *)em tag:(int)tag;
-(void) entityModelLoadFailed:(EntityModel *)em error:(NSError *)err sender:(int)tag;


// 设置网络请求helper
-(RequestHelper *) entityModelSetupRequestHelper:(id)model;

// 设置数据库helper
-(LKDBHelper *) entityModelSetupDBHelper:(id)model;

@end
