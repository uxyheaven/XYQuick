//
//  DataLite.m
//  JoinShow
//
//  Created by Heaven on 13-9-10.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#pragma mark -to kvo

#import "XYDataLite.h"

@implementation XYDataLite

#pragma mark - todo 多类型判断

+ (id)readObjectForKey:(NSString *)key
{
    return [self readObjectForKey:key defaultObject:nil];
}
+ (id)readObjectForKey:(NSString *)key defaultObject:(id)defaultObject
{
    id tempObject = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    if (tempObject)
    {
        return tempObject;
    }else if (defaultObject)
    {
        return defaultObject;
    }
    else
    {
        return nil;
    }
}

+ (void)writeObject:(id)anObject forKey:(NSString *)key synchronize:(BOOL)bSync
{
    if (anObject == nil)
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:anObject forKey:key];
    }
    
    if (bSync)
    {
        [self synchronize];
    }
}
+ (void)writeObject:(id)anObject forKey:(NSString *)key
{
    [self writeObject:anObject forKey:key synchronize:YES];
}
+ (void)registerDefaults:(NSDictionary *)dic
{
    [[NSUserDefaults standardUserDefaults] registerDefaults:dic];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (void)synchronize
{
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
