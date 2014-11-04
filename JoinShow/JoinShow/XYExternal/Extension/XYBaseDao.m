//
//  XYBaseDao.m
//  JoinShow
//
//  Created by Heaven on 14-9-10.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import "XYBaseDao.h"
#import "LKDBHelper.h"

@interface XYBaseDao ()
@property (nonatomic, weak) LKDBHelper *globalHelper;
@end

@implementation XYBaseDao

+ (instancetype)daoWithEntityClass:(Class)aClass
{
    if (aClass == nil)
        return nil;
    
    XYBaseDao *dao = [[[self class] alloc] initWithEntityClass:aClass];

    return dao;
}

+ (instancetype)daoWithEntityClassName:(NSString *)name
{
    return [self daoWithEntityClass:NSClassFromString(name)];
}

- (instancetype)initWithEntityClass:(Class)aClass
{
    self = [super init];
    if (self)
    {
        _entityClass  = aClass;
        _globalHelper = [aClass getUsingLKDBHelper];
        // 创建表
        [_globalHelper createTableWithModelClass:[_entityClass class]];
    }
    return self;
}

- (NSError *)saveEntity:(id)entity
{
    if (entity == nil)
        return [NSError errorWithDomain:[NSString stringWithFormat:@"[save error] :%@", entity] code:XYBaseDao_error_code userInfo:nil];
    
    LKDBHelper *globalHelper = [LKDBHelper getUsingLKDBHelper];
    
    if (![globalHelper insertToDB:entity])
    {
        return [NSError errorWithDomain:[NSString stringWithFormat:@"[save error] :%@", entity] code:XYBaseDao_error_code userInfo:nil];
    }
    
    return nil;
}

- (NSError *)saveEntityWithArray:(NSArray *)array
{
    if (array == nil || array.count == 0)
        return [NSError errorWithDomain:[NSString stringWithFormat:@"[save error] :%@", array] code:XYBaseDao_error_code userInfo:nil];
    
    NSMutableString *str = [NSMutableString stringWithFormat:@"[save error] :"];
    NSInteger length = str.length;
    
    __weak __typeof(XYBaseDao *) weakSelf = self;
    
    // 事务 transaction
    [_globalHelper executeDB:^(FMDatabase *db) {
        [db beginTransaction];
        for (NSObject *entity in array)
        {
            if (![weakSelf.globalHelper insertToDB:entity])
            {
                [str stringByAppendingFormat:@"%@ ", entity];
            }
        }
        [db commit];
    }];
    
    if (str.length > length)
    {
        return [NSError errorWithDomain:str code:XYBaseDao_error_code userInfo:nil];
    }
         
    return nil;
}

- (id)loadEntityWithKey:(NSString *)key
{
    if (key.length == 0)
        return nil;
    
    id object = [[_entityClass alloc] init];
    
    NSString *where = nil;
    
    if ([key isKindOfClass:[NSString class]])
    {
        where = [NSString stringWithFormat:@"%@ = '%@'", [_entityClass getPrimaryKey], key];
    }
    else if ([key isKindOfClass:[NSNumber class]])
    {
        where = [NSString stringWithFormat:@"%@ = %@", [_entityClass getPrimaryKey], key];
    }
    else if (1)
    {
#pragma mark- todo  多主键种类判断
        where = @"";
    }
    
    object = [_entityClass searchSingleWithWhere:where orderBy:nil];

    return object;
}

- (NSArray *)loadEntityWithWhere:(NSString *)where order:(NSString *)order;
{
    return [self loadEntityWithWhere:where order:order offset:0 count:XYBaseDao_load_maxCount];
}

- (NSArray *)loadEntityWithWhere:(NSString *)where order:(NSString *)order offset:(NSInteger)offset count:(NSInteger)count
{
    NSArray *array = [_entityClass searchWithWhere:where orderBy:order offset:offset count:count];
    
    return array;
}

- (NSInteger)countWithWhere:(NSString *)where
{
    return [_entityClass rowCountWithWhere:where];
}

- (NSError *)deleteEntity:(id)entity
{
    if (![entity deleteToDB])
    {
        return  [NSError errorWithDomain:[NSString stringWithFormat:@"[delete error] : %@ %@", _entityClass, entity] code:XYBaseDao_error_code userInfo:nil];
    }
    
    return nil;
}

- (NSError *)deleteEntityWithKey:(NSString *)key
{
    id object = [[_entityClass alloc] init];
    [object setValue:key forKey:[_entityClass getPrimaryKey]];
    
    if (![object deleteToDB])
    {
        return  [NSError errorWithDomain:[NSString stringWithFormat:@"[delete error] : %@ %@", _entityClass, key] code:XYBaseDao_error_code userInfo:nil];
    }
    
    return nil;
}

- (NSError *)deleteEntityWithWhere:(NSString *)where
{
    if (![_entityClass deleteWithWhere:where])
    {
        return  [NSError errorWithDomain:[NSString stringWithFormat:@"[delete error] : %@ %@", _entityClass, where] code:XYBaseDao_error_code userInfo:nil];
    }
    
    return nil;
}

- (void)deleteAllEntity
{
    [LKDBHelper clearTableData:[_entityClass class]];
}

- (BOOL)isExistEntity:(id)entity
{
    return [entity isExistsFromDB];
}

@end
