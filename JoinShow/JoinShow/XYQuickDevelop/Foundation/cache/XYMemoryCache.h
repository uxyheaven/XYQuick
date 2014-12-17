//
//  XYMemoryCache.h
//  JoinShow
//
//  Created by Heaven on 14-1-17.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//


#import "XYPrecompile.h"
#import "XYCacheProtocol.h"

@interface XYMemoryCache : NSObject <XYCacheProtocol>

AS_SINGLETON( XYMemoryCache );

@property (nonatomic, assign) BOOL                clearWhenMemoryLow;
@property (nonatomic, assign) NSUInteger          maxCacheCount;
@property (nonatomic, assign) NSUInteger          cachedCount;
@property (atomic, strong   ) NSMutableArray      *cacheKeys;
@property (atomic, strong   ) NSMutableDictionary *cacheObjs;


// XYCacheProtocol 协议方法
- (BOOL)hasObjectForKey:(id)key;

- (id)objectForKey:(id)key;
- (void)setObject:(id)object forKey:(id)key;

- (void)removeObjectForKey:(id)key;
- (void)removeAllObjects;

//

@end
