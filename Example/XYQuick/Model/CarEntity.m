//
//  CarEntity.m
//  JoinShow
//
//  Created by Heaven on 14-9-12.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import "CarEntity.h"

@implementation CarEntity

#pragma mark - XYBaseDaoEntityProtocol
// 返回表名
+ (NSString *)getTableName{
    return @"car";
}

// 返回主键
+ (NSString *)getPrimaryKey{
    return @"name";
}

@end
