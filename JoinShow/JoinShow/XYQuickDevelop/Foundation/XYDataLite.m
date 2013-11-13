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
//DEF_SINGLETON(DataLite)

DEF_DataLite_object(StrTest, YES, nil, nil)

#pragma mark - todo 多类型判断

+(id) readObjectForKey:(NSString *)key{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}
+(id) readObjectForKey:(NSString *)key defaultObject:(id)defaultObject defaultObjectPath:(NSString *)aPath{
    id tempObject = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (tempObject) {
        return tempObject;
    }else if (defaultObject) {
        return defaultObject;
    }else if (aPath) {
        NSString *str = [XYCommon dataFilePath:aPath ofType:filePathOption_app];
        id anObject = nil;
        
        if ((anObject = [NSDictionary dictionaryWithContentsOfFile:str]))
        {
            return anObject;
        }else if ((anObject = [NSArray arrayWithContentsOfFile:aPath]))
        {
            return anObject;
        }else if ((anObject = [NSString stringWithContentsOfFile:aPath encoding:NSUTF8StringEncoding error:nil]))
        {
#pragma mark - to do NSString NSData 问题
            return anObject;
        }else if ((anObject = [NSData dataWithContentsOfFile:aPath]))
        {
            return anObject;
        }
        return nil;
    }else{
        return nil;
    }
}
/*
+(id) readObjectForKey:(NSString *)key defaultObject:(id)defaultObject{
    id tempObject = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (tempObject) {
        return tempObject;
    }else{
        return defaultObject;
    }
}
+(id) readObjectForKey:(NSString *)key defaultObjectPath:(NSString *)aPath{
    id tempObject = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (tempObject) {
        return tempObject;
    }else{
        if (aPath == nil) return nil;
        
        NSString *str = [XYCommon dataFilePath:aPath ofType:filePathOption_app];
        id defaultObject = nil;
        
        if ((defaultObject = [NSDictionary dictionaryWithContentsOfFile:str]))
        {
            
        }else if ((defaultObject = [NSArray arrayWithContentsOfFile:aPath]))
        {
            
        }else if ((defaultObject = [NSString stringWithContentsOfFile:aPath encoding:NSUTF8StringEncoding error:nil]))
        {
            
        }else if ((defaultObject = [NSData dataWithContentsOfFile:aPath]))
        {
            
        }
        
        return defaultObject;
    }
}
*/
+(void) writeObject:(id)anObject forKey:(NSString *)key synchronize:(BOOL)bSync{
    if (anObject == nil) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:anObject forKey:key];
    }
    if (bSync) {
        [[self class] synchronize];
    }
}
+(void) synchronize{
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
