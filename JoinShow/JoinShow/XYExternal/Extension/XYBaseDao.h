//
//  XYBaseDao.h
//  JoinShow
//
//  Created by Heaven on 14-9-10.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import <Foundation/Foundation.h>
#define XYBaseDao_error_code 123123
#define XYBaseDao_load_maxCount 1000

@protocol XYBaseDaoEntityProtocol <NSObject>

@required
// 返回表名
+ (NSString *)getTableName;

// 返回主键
+ (NSString *)getPrimaryKey;

// 返回联合主键
+ (NSArray *)getPrimaryKeyUnionArray;

@end


// 范化的本地dao类
@interface XYBaseDao : NSObject

@property (nonatomic, weak, readonly) Class entityClass;

+ (instancetype)daoWithEntityClass:(Class)aClass;
+ (instancetype)daoWithEntityClassName:(NSString *)name;

- (NSError *)saveEntity:(id)entity;
- (NSError *)saveEntityWithArray:(NSArray *)array;

- (id)loadEntityWithKey:(NSString *)key;
- (NSArray *)loadEntityWithWhere:(NSString *)where order:(NSString *)order;
- (NSArray *)loadEntityWithWhere:(NSString *)where order:(NSString *)order offset:(NSInteger)offset count:(NSInteger)count;


- (NSInteger)countWithWhere:(NSString *)where;

- (NSError *)deleteEntity:(id)entity;
- (NSError *)deleteEntityWithKey:(NSString *)key;
- (NSError *)deleteEntityWithWhere:(NSString *)where;

- (void)deleteAllEntity;

- (BOOL)isExistEntity:(id)entity;

@end
