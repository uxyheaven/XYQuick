//
//  DataLite.h
//  JoinShow
//
//  Created by Heaven on 13-9-10.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

// 轻量形数据持久化, 基于NSUserDefaults
// 如果最后用的是DEF_DATALITE_OBJECT, 记得在程序进入后台,退出时调用 XY_DataLite_synchronize

#import "XYCommonDefine.h"

// 同步数据到硬盘
#define XY_DataLite_synchronize [XYDataLite synchronize];

// 注意: __name 首字母需要大写
#define AS_DATALITE_OBJECT( __name ) \
- (void)set##__name:(id)anObject; \
-(id) __name;

#define AS_DATALITE_STRING( __name ) \
- (void)set##__name:(NSString *)anObject; \
-(NSString *) __name;


#define AS_DATALITE_INT( __name ) \
- (void)set##__name:(int)anObject; \
-(int) __name;

/**
 __synchronize 自动存
 * 注意:__defaultObject不要使用bool
 * 建议在 applicationDidFinishLaunching: 中调用[XYDataLite registerDefaults:dic]设置默认值
 */
#define DEF_DATALITE_OBJECT( __name , __defaultObject) \
- (void)set##__name:(id)anObject{ \
    [XYDataLite writeObject:anObject forKey:__TEXT( __func__##__name ) synchronize:YES]; \
} \
-(id) __name{ \
    NSString *key = [NSString stringWithFormat:@"%@_%@", [self class], __TEXT( __name )]; \
    return [XYDataLite readObjectForKey:key defaultObject:__defaultObject]; \
}

#define DEF_DATALITE_STRING( __name , __defaultObject) \
DEF_DATALITE_OBJECT( __name , __defaultObject)

#import "XYPrecompile.h"
#import "XYFoundation.h"

@interface XYDataLite : NSObject

// dont support bool
+ (id)readObjectForKey:(NSString *)key;

// defaultObject dont support bool,
+ (id)readObjectForKey:(NSString *)key defaultObject:(id)defaultObject;

+ (void)writeObject:(id)anObject forKey:(NSString *)key;
// if bSync == YES, run [[NSUserDefaults standardUserDefaults] synchronize]
+ (void)writeObject:(id)anObject forKey:(NSString *)key synchronize:(BOOL)bSync;


// 设置默认的值
+ (void)registerDefaults:(NSDictionary *)dic;

+ (void)synchronize;

@end
