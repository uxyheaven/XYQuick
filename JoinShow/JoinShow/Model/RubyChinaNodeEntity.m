//
//  RubyChinaNodeEntity.m
//  JoinShow
//
//  Created by Heaven on 13-10-31.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import "RubyChinaNodeEntity.h"
#import "YYJSONHelper.h"

@implementation RubyChinaNodeEntity
- (void)dealloc
{
    self.name = nil;
    self.summary = nil;
    self.section_name = nil;
}

+ (void)initialize
{
    if (self == [RubyChinaNodeEntity class]){
        [self bindYYJSONKey:@"id" toProperty:@"nodeID"];
    }
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
