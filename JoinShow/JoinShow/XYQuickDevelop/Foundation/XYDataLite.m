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

//DEF_DataLite_object(StrTest, YES, nil, nil)

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
+(void) registerDefaults:(NSDictionary *)dic{
    [[NSUserDefaults standardUserDefaults] registerDefaults:dic];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(void) synchronize{
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//-(id) __name{ \
//    NSString *key = [NSString stringWithFormat:@"%@_%@", [self class], NSStringify( __name )];
//    return [XYDataLite readObjectForKey:NSStringify( __name ) defaultObject:__defaultObject defaultObjectPath:__defaultPath]; \
//}
@end
