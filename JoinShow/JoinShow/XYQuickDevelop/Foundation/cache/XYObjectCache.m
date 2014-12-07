//
//  XYObjectCache.m
//  JoinShow
//
//  Created by Heaven on 14-1-21.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import "XYObjectCache.h"
#import "XYCache.h"
#import "XYSandbox.h"
#import "XYExtension.h"

@interface XYObjectCache()
{

}

@end

@implementation XYObjectCache

DEF_SINGLETON(XYObjectCache)

-(id) init
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

- (void)dealloc
{
}

- (void)registerObjectClass:(Class)aClass{
    _objectClass = aClass;
}

- (BOOL)hasCachedForKey:(NSString *)string
{
	NSString * cacheKey = [string MD5];
	
	BOOL flag = [self.memoryCache hasObjectForKey:cacheKey];
	if ( NO == flag )
	{
		flag = [self.fileCache hasObjectForKey:cacheKey];
	}
	
	return flag;
}

- (BOOL)hasFileCachedForKey:(NSString *)key
{
	NSString * cacheKey = [key MD5];
	
	return [self.fileCache hasObjectForKey:cacheKey];
}

- (BOOL)hasMemoryCachedForKey:(NSString *)key
{
	NSString * cacheKey = [key MD5];
	
	return [self.memoryCache hasObjectForKey:cacheKey];
}

- (id)fileObjectForKey:(NSString *)key
{
  //  PERF_ENTER
	
	NSString *	cacheKey = [key MD5];
	id anObject = nil;
    
	NSString * fullPath = [self.fileCache fileNameForKey:cacheKey];

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
	
	NSString *	cacheKey = [key MD5];
	id anObject = nil;
	
	NSObject * object = [self.memoryCache objectForKey:cacheKey];
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
    if (async) {
        // 异步
        FOREGROUND_BEGIN
        [self saveToMemory:anObject forKey:key];
        BACKGROUND_BEGIN
        [self saveToData:anObject forKey:key];
        BACKGROUND_COMMIT
        FOREGROUND_COMMIT
    } else {
        // 同步
        [self saveToData:anObject forKey:key];
        [self saveToMemory:anObject forKey:key];
    }
}

- (void)saveToMemory:(id)anObject forKey:(NSString *)string
{
  //  PERF_ENTER
	
	NSString * cacheKey = [string MD5];
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
	
	NSString * cacheKey = [string MD5];
	[self.fileCache setObject:data forKey:cacheKey];
	
  //  PERF_LEAVE
}

- (void)deleteObjectForKey:(NSString *)string
{
  //  PERF_ENTER
	
	NSString * cacheKey = [string MD5];
	
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
