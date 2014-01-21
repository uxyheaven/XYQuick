//
//  XYObjectCache.h
//  JoinShow
//
//  Created by Heaven on 14-1-21.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import "XYPrecompile.h"


@interface XYObjectCache : NSObject

XY_SINGLETON(XYObjectCache)

@property (nonatomic, assign, readonly) Class objectClass;
@property (nonatomic, assign) NSTimeInterval fileTimeLimit; // 默认1周

-(void) registerObjectClass:(Class)aClass;

-(BOOL) hasCachedForURL:(NSString *)url;
-(BOOL) hasFileCachedForURL:(NSString *)url;
-(BOOL) hasMemoryCachedForURL:(NSString *)url;

-(id) objectForURL:(NSString *)url;
-(id) fileObjectForURL:(NSString *)url;
-(id) memoryObjectForURL:(NSString *)url;

-(void) saveToMemory:(id)anObject forURL:(NSString *)url;
-(void) saveToData:(NSData *)data forURL:(NSString *)url;
-(void) deleteObjectForURL:(NSString *)url;
-(void) deleteAllObjects;

@end


@protocol XYObjectCacheDelegate <NSObject>

@end
