//
//  DataLite.h
//  JoinShow
//
//  Created by Heaven on 13-9-10.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

// 轻量形数据持久化, 基于NSUserDefaults
// 如果最后用的是DEF_DataLite_object, 记得在程序进入后台,退出时调用 XY_DataLite_synchronize

#import "XYCommonDefine.h"

// 同步数据到硬盘
#define XY_DataLite_synchronize [XYDataLite synchronize];

// 注意: __name 首字母需要大写
#define XY_DataLite_string( __name ) \
-(void) set##__name:(NSString *)anObject; \
-(id) __name;

#define XY_DataLite_object( __name ) \
-(void) set##__name:(id)anObject; \
-(id) __name;

/**
 __synchronize 自动存
 * 注意:__defaultObject不要使用bool
 * 用__defaultPath时不要用NSNumber, NSString NSData 识别问题
 * 2个只能用一个
 * 建议在 applicationDidFinishLaunching: 中调用[XYDataLite registerDefaults:dic]设置默认值
 */
#define DEF_DataLite_object( __name , __synchronize, __defaultObject, __defaultPath) \
-(void) set##__name:(id)anObject{ \
[XYDataLite writeObject:anObject forKey:NSStringify( __func__##__name ) synchronize:__synchronize]; \
} \
-(id) __name{ \
NSString *key = [NSString stringWithFormat:@"%@_%@", [self class], NSStringify( __name )]; \
return [XYDataLite readObjectForKey:key defaultObject:__defaultObject defaultObjectPath:__defaultPath]; \
}

#import "XYPrecompile.h"
#import "XYFoundation.h"

@interface XYDataLite : NSObject
//AS_SINGLETON(DataLite)
//XY_DataLite_string(StrTest)

// dont support bool
+(id) readObjectForKey:(NSString *)key;
// defaultObject dont support bool, defaultObjectPath dont support NSNumber
+(id) readObjectForKey:(NSString *)key defaultObject:(id)defaultObject defaultObjectPath:(NSString *)aPath;

// dont support bool
//+(id) readObjectForKey:(NSString *)key defaultObject:(id)defaultObject;
//+(id) readObjectForKey:(NSString *)key defaultObjectPath:(NSString *)aPath;


// if bSync == YES, run [[NSUserDefaults standardUserDefaults] synchronize]
+(void) writeObject:(id)anObject forKey:(NSString *)key synchronize:(BOOL)bSync;


// 设置默认的值
+(void) registerDefaults:(NSDictionary *)dic;

+(void) synchronize;
@end
