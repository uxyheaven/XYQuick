//
//  RubyChinaNodeEntity.m
//  JoinShow
//
//  Created by Heaven on 13-10-31.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import "RubyChinaNodeEntity.h"

@implementation RubyChinaNodeEntity
- (void)dealloc
{
    self.name = nil;
    self.summary = nil;
    self.section_name = nil;
    [super dealloc];
}

+ (void)initialize
{
    [super initialize];
    [self bindYYJSONKey:@"id" toProperty:@"nodeID"];
}

// DB
//主键
+(NSString *)getPrimaryKey
{
    return @"nodeID";
}
//表名
+(NSString *)getTableName
{
    return @"RubyChinaNode";
}
//表版本
+(int)getTableVersion
{
    return 1;
}
@end
