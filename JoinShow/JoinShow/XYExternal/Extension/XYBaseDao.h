//
//  XYBaseDao.h
//  JoinShow
//
//  Created by Heaven on 14-9-10.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import <Foundation/Foundation.h>

// 范化的本地dao类
@interface XYBaseDao : NSObject

+ (void)daoWithEntityClass:(Class)aClass;

- (NSError *)saveEntity:(id)entity;
- (NSError *)saveEntityWithArray:(NSArray *)array;

- (id)loadEntityWithKey:(NSString *)key;
- (NSArray *)loadEntityWithWhere:(NSString *)where;

- (NSInteger)countWithWhere:(NSString *)where;

- (NSError *)deleteEntityWithKey:(NSString *)key;
- (NSError *)deleteEntityWithWhere:(NSString *)where;

@end
