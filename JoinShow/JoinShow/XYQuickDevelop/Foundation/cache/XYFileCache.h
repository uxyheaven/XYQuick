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

@property (nonatomic, copy) NSString *cachePath;
@property (nonatomic, copy) NSString *cacheUser;

@property (nonatomic, assign) NSTimeInterval maxCacheAge; // 有效期,默认1周

AS_SINGLETON( XYFileCache );

- (NSString *)fileNameForKey:(NSString *)key;

- (id)objectForKey:(id)key objectClass:(Class)aClass;

#pragma mark - todo
//- (void)removeOverdueFiles;

@end
