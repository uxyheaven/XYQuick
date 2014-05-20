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
@interface EntityBaseModel : NSObject{
    //@public id <EntityModelDelegate> _delegate;
}

//AS_SINGLETON(EntityModel)

@property (nonatomic, strong) id data;                                          // 数据
@property (nonatomic, assign) Class dataClass;                                  // 数据类型
@property (nonatomic, strong) id result;                                        // 临时数据
@property (nonatomic, strong, readonly) NSMutableArray *array;                            // array
@property (nonatomic, strong, readonly) NSMutableDictionary *dic;                         // dic

@property (nonatomic, assign) int tag;                                          // 标签

@property (nonatomic, strong) RequestHelper *requestHelper;                     // 网络请求,需要自己初始化
@property (nonatomic, strong) LKDBHelper    *dbHelper;                          // 数据库帮助类


#pragma mark -

+(id) modelWithClass:(Class)aClass;

#pragma mark - net
//-(void) loadFromServer/

#pragma mark - database
//-(void) loadFromDatabase

- (void)addObject:(id)anObject;
- (void)insertObject:(id)anObject atIndex:(NSUInteger)index;
- (void)removeLastObject;
- (void)removeObjectAtIndex:(NSUInteger)index;

@end

