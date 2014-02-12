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

@property (atomic, retain) XYMemoryCache *		memoryCache;
@property (atomic, retain) XYFileCache *		fileCache;

@end

@implementation XYObjectCache

DEF_SINGLETON(XYObjectCache)

-(id) init
{
	self = [super init];
	if ( self )
	{
		_memoryCache = [[XYMemoryCache alloc] init];
		_memoryCache.clearWhenMemoryLow = YES;
        
		_fileCache = [[XYFileCache alloc] init];
		_fileCache.cachePath = [NSString stringWithFormat:@"%@/ObjectCache/", [XYSandbox libCachePath]];
		_fileCache.cacheUser = @"";
	}
	return self;
}

-(void) dealloc
{
	self.memoryCache = nil;
	self.fileCache = nil;
    
    [super dealloc];
}

-(void) registerObjectClass:(Class)aClass{
    _objectClass = aClass;
    _fileCache.cachePath = [NSString stringWithFormat:@"%@/%@/", [XYSandbox libCachePath], NSStringFromClass(_objectClass)];
}

-(BOOL) hasCachedForURL:(NSString *)string
{
	NSString * cacheKey = [string MD5];
	
	BOOL flag = [self.memoryCache hasObjectForKey:cacheKey];
	if ( NO == flag )
	{
		flag = [self.fileCache hasObjectForKey:cacheKey];
	}
	
	return flag;
}

-(BOOL) hasFileCachedForURL:(NSString *)url
{
	NSString * cacheKey = [url MD5];
	
	return [self.fileCache hasObjectForKey:cacheKey];
}

-(BOOL) hasMemoryCachedForURL:(NSString *)url
{
	NSString * cacheKey = [url MD5];
	
	return [self.memoryCache hasObjectForKey:cacheKey];
}

-(id) fileObjectForURL:(NSString *)url
{
  //  PERF_ENTER
	
	NSString *	cacheKey = [url MD5];
	id anObject = nil;
    
	NSString * fullPath = [self.fileCache fileNameForKey:cacheKey];

	if ( fullPath )
	{
        if ([self.objectClass isSubclassOfClass:[UIImage class]]) {
            anObject = [[[UIImage alloc] initWithContentsOfFile:fullPath] autorelease];
        } else if ([self.objectClass isSubclassOfClass:[NSData class]]){
            anObject = [[[NSData alloc] initWithContentsOfFile:fullPath] autorelease];
        } else if ([self.objectClass isSubclassOfClass:[NSString class]]){
            anObject = [[[NSString alloc] initWithContentsOfFile:fullPath encoding:NSUTF8StringEncoding error:nil] autorelease];
        } else if (1){
            anObject = [[[NSData alloc] initWithContentsOfFile:fullPath] autorelease];
        }
        
		id cachedObject = (id)[self.memoryCache objectForKey:cacheKey];
		if ( nil == cachedObject && anObject != cachedObject )
		{
			[self.memoryCache setObject:anObject forKey:cacheKey];
		}
	}

    
  //  PERF_LEAVE
	
	return anObject;
}

-(id) memoryObjectForURL:(NSString *)url
{
  //  PERF_ENTER
	
	NSString *	cacheKey = [url MD5];
	id anObject = nil;
	
	NSObject * object = [self.memoryCache objectForKey:cacheKey];
	if ( object && [object isKindOfClass:self.objectClass] )
	{
		anObject = (id)object;
	} else if (object && 1){
        anObject = (id)object;
    }
	
  //  PERF_LEAVE
    
	return anObject;
}

-(id) objectForURL:(NSString *)string
{
	id anObject = [self memoryObjectForURL:string];
	if ( nil == anObject )
	{
		anObject = [self fileObjectForURL:string];
	}
	return anObject;
}

-(void) saveToMemory:(id)anObject forURL:(NSString *)string
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

-(void) saveToData:(NSData *)data forURL:(NSString *)string
{
  //  PERF_ENTER
	
	NSString * cacheKey = [string MD5];
	[self.fileCache setObject:data forKey:cacheKey];
	
  //  PERF_LEAVE
}

-(void) deleteObjectForURL:(NSString *)string
{
  //  PERF_ENTER
	
	NSString * cacheKey = [string MD5];
	
	[self.memoryCache removeObjectForKey:cacheKey];
	[self.fileCache removeObjectForKey:cacheKey];
	
 //   PERF_LEAVE
}

-(void) deleteAllObjects
{
	[self.memoryCache removeAllObjects];
	[self.fileCache removeAllObjects];
}


@end
