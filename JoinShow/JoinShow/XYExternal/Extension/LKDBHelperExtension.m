//
//  LKDBHelperExtension.m
//  JoinShow
//
//  Created by Heaven on 13-10-31.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import "LKDBHelperExtension.h"
#if (1 == __USED_LKDBHelper__)
#import "NSObject+LKModel.h"

@implementation NSObject(XY_LKDBHelper)

- (void)loadFromDB
{
    id value = [self valueForKey:[self.class getPrimaryKey]];
    NSString *strValue = nil;
    NSString *str = nil;
    if (value == nil)
        return ;
    
    if ([value isKindOfClass:[NSString class]])
    {
        strValue = value;
        str = [NSString stringWithFormat:@"%@ = '%@'", [self.class getPrimaryKey], strValue];
    }
    else if ([value isKindOfClass:[NSNumber class]])
    {
        strValue = [value stringValue];
        str = [NSString stringWithFormat:@"%@ = %@", [self.class getPrimaryKey], strValue];
    }
    else if (1)
    {
#pragma mark- todo  多主键种类判断
        strValue = @"";
    }
    
    NSMutableArray *arraySync = [self.class searchWithWhere:str orderBy:nil offset:0 count:1];
    if (arraySync.count > 0)
    {
        NSObject *temp = [arraySync objectAtIndex:0];
        for (NSString *attribute in self.attributeList)
        {
            [self setValue:[temp valueForKey:attribute] forKey:attribute];
        }
    }
    else
    {
      return;
    }
}
+ (NSString *)primaryKeyAndDESC
{
    return [[self getPrimaryKey] stringByAppendingString:@" DESC"];
}

@end


@implementation NSArray(XY_LKDBHelper)

- (void)saveAllToDB
{
  //  [self.class insertToDB:self];
    if (self.count > 0)
    {
      //  NSObject *anObject       = [self objectAtIndex:0];
        LKDBHelper *globalHelper = [LKDBHelper getUsingLKDBHelper];
        
        // 创建表
       // [globalHelper createTableWithModelClass:[anObject class]];
        
        // 异步 插入
        [globalHelper executeDB:^(FMDatabase *db) {
            [db beginTransaction];
            for (NSObject *anObject2 in self)
            {
                [globalHelper insertToDB:anObject2];
            }
#pragma mark - todo
            BOOL insertSucceed = YES;
            //insert fail
            if (insertSucceed == NO)
                [db rollback];
            else
                [db commit];
        }];
    }
}

+(id) loadFromDBWithClass:(Class)modelClass
{
    NSString *str = [modelClass primaryKeyAndDESC];
    NSMutableArray *arraySync = [modelClass searchWithWhere:nil orderBy:str offset:0 count:100];
    
    return arraySync;
}

@end
#endif