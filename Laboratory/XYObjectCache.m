//
//  XYObjectCache.m
//  JoinShow
//
//  Created by Heaven on 14-1-21.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import "XYObjectCache.h"
#import "XYQuick_Cache.h"
#import "XYSandbox.h"
#import "XYThread.h"
#import "NSString+XY.h"

@interface XYObjectCache()
{

}

@end

@implementation XYObjectCache uxy_def_singleton

- (id)init
{
	self = [super init];
	if ( self )
	{
		_memoryCache = [XYMemoryCache sharedInstance];
		_memoryCache.clearWhenMemoryLow = YES;
        
		_fileCache = [XYFileCache sharedInstance];
	}
	return self;
}

- (void)registerObjectClass:(Class)aClass
{
    _objectClass = aClass;
}

- (BOOL)hasCachedForKey:(NSString *)string
{
	NSString * cacheKey = [string uxy_MD5String];
	
	BOOL flag = [self.memoryCache hasObjectForKey:cacheKey];
	if ( NO == flag )
	{
		flag = [self.fileCache hasObjectForKey:cacheKey];
	}
	
	return flag;
}

- (BOOL)hasFileCachedForKey:(NSString *)key
{
	NSString * cacheKey = [key uxy_MD5String];
	
	return [self.fileCache hasObjectForKey:cacheKey];
}

- (BOOL)hasMemoryCachedForKey:(NSString *)key
{
	NSString * cacheKey = [key uxy_MD5String];
	
	return [self.memoryCache hasObjectForKey:cacheKey];
}

- (id)fileObjectForKey:(NSString *)key
{
  //  PERF_ENTER
	
	NSString *cacheKey = [key uxy_MD5String];
	id anObject = nil;
    
	NSString *fullPath = [self.fileCache fileNameForKey:cacheKey];

	if ( fullPath )
	{
        anObject = [self.fileCache objectForKey:fullPath objectClass:_objectClass];
        
		id cachedObject = (id)[self.memoryCache objectForKey:cacheKey];
		if ( nil == cachedObject && anObject != cachedObject )
		{
			[self.memoryCache setObject:anObject forKey:cacheKey];
		}
	}

    
  //  PERF_LEAVE
	
	return anObject;
}

- (id)memoryObjectForKey:(NSString *)key
{
  //  PERF_ENTER
	
	NSString *cacheKey = [key uxy_MD5String];
	id anObject = nil;
	
	NSObject *object = [self.memoryCache objectForKey:cacheKey];
	if ( object && [object isKindOfClass:self.objectClass] )
	{
		anObject = (id)object;
	}
    else if (object && 1)
    {
        anObject = (id)object;
    }
	
  //  PERF_LEAVE
    
	return anObject;
}

- (id)objectForKey:(NSString *)string
{
	id anObject = [self memoryObjectForKey:string];
	if ( nil == anObject )
	{
		anObject = [self fileObjectForKey:string];
	}
	return anObject;
}

- (void)saveObject:(id)anObject forKey:(NSString *)key{
    [self saveObject:anObject forKey:key async:YES];
}

- (void)saveObject:(id)anObject forKey:(NSString *)key async:(BOOL)async{
    if (async)
    {
        // 异步
        [self saveToMemory:anObject forKey:key];
        uxy_dispatch_background_concurrent
        [self saveToData:anObject forKey:key];
        uxy_dispatch_submit
        
    }
    else
    {
        // 同步
        [self saveToData:anObject forKey:key];
        [self saveToMemory:anObject forKey:key];
    }
}

- (void)saveToMemory:(id)anObject forKey:(NSString *)string
{
  //  PERF_ENTER
	NSString *cacheKey = [string uxy_MD5String];
	id cachedObject = (id)[self.memoryCache objectForKey:cacheKey];
	if ( nil == cachedObject && anObject != cachedObject )
	{
		[self.memoryCache setObject:anObject forKey:cacheKey];
	}
  //  PERF_LEAVE
}

- (void)saveToData:(NSData *)data forKey:(NSString *)string
{
  //  PERF_ENTER
	NSString *cacheKey = [string uxy_MD5String];
	[self.fileCache setObject:data forKey:cacheKey];
  //  PERF_LEAVE
}

- (void)deleteObjectForKey:(NSString *)string
{
  //  PERF_ENTER
	NSString *cacheKey = [string uxy_MD5String];
	
	[self.memoryCache removeObjectForKey:cacheKey];
	[self.fileCache removeObjectForKey:cacheKey];
 //   PERF_LEAVE
}

- (void)deleteAllObjects
{
	[self.memoryCache removeAllObjects];
	[self.fileCache removeAllObjects];
}


@end
