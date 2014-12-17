//
//  XYFileCache.h
//  JoinShow
//
//  Created by Heaven on 14-1-17.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import "XYPrecompile.h"
#import "XYCacheProtocol.h"

#define XYFileCache_fileExpires  7 * 24 * 60 * 60

@interface XYFileCache : NSObject <XYCacheProtocol>

@property (nonatomic, copy, readonly) NSString *diskCachePath;
@property (assign, nonatomic) NSUInteger maxCacheSize;    // The maximum size of the cache, in bytes
@property (nonatomic, assign) NSTimeInterval maxCacheAge; // 有效期,默认1周

AS_SINGLETON( XYFileCache );

// 用新路径建立一个cache
- (id)initWithNamespace:(NSString *)ns;

// 返回key对应的文件名
- (NSString *)fileNameForKey:(NSString *)key;
// 返回类文件
- (id)objectForKey:(id)key objectClass:(Class)aClass;

// 清除当前 diskCachePath 所有的文件
- (void)clearDisk;
- (void)clearDiskOnCompletion:(void(^)(void))completion;

// 清除当前 diskCachePath 所有过期的文件
- (void)cleanDisk;
- (void)cleanDiskWithCompletionBlock:(void(^)(void))completionBlock;

// 返回cache size
- (NSUInteger)getSize;
// 返回cache 数量
- (NSUInteger)getDiskCount;

// XYCacheProtocol 协议方法
- (BOOL)hasObjectForKey:(id)key;
- (id)objectForKey:(id)key;
- (void)setObject:(id)object forKey:(id)key;

//

@end
