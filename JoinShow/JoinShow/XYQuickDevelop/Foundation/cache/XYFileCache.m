//
//  XYFileCache.m
//  JoinShow
//
//  Created by Heaven on 14-1-17.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import "XYFileCache.h"
#import "XYCommon.h"
#import "XYSystemInfo.h"
#import "XYSandbox.h"
#import "XYAutoCoding.h"

@implementation XYFileCache

DEF_SINGLETON( XYFileCache );

- (id)init
{
	self = [super init];
	if ( self )
	{
       self.cacheUser   = @"";
       self.cachePath   = [NSString stringWithFormat:@"%@/%@/Cache/", [XYSandbox libCachePath], [XYSystemInfo appVersion]];
       self.maxCacheAge = XYFileCache_fileExpires;
	}
	return self;
}

- (void)dealloc
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (NSString *)fileNameForKey:(NSString *)key
{
	NSString *pathName = nil;
	if ( self.cacheUser && [self.cacheUser length] )
	{
		pathName = [self.cachePath stringByAppendingFormat:@"%@/", self.cacheUser];
	}
	else
	{
		pathName = self.cachePath;
	}
	
	if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:pathName] )
	{
		[[NSFileManager defaultManager] createDirectoryAtPath:pathName
								  withIntermediateDirectories:YES
												   attributes:nil
														error:NULL];
	}
    
    pathName = [pathName stringByAppendingString:key];
    
    NSTimeInterval time = [[[[NSFileManager defaultManager] attributesOfItemAtPath:pathName error:nil] fileModificationDate] timeIntervalSinceNow];
    
    if (time + self.maxCacheAge < 0)
    {
        //pathName = nil;
        [[NSFileManager defaultManager] removeItemAtPath:pathName error:nil];
    }
    
    NSAssert(pathName.length > 0, @"路径得有");
    
	return pathName;
}

- (void)removeOverdueFiles{

}

- (id)objectForKey:(id)key objectClass:(Class)aClass
{
    if (aClass != nil)
    {
        // 用的是AutoCoding里的方法
        return [aClass objectWithContentsOfFile:[self fileNameForKey:key]];
    }
    else
    {
        return [self objectForKey:key];
    }
}

#pragma mark - XYCacheProtocol
- (BOOL)hasObjectForKey:(id)key
{
	return [[NSFileManager defaultManager] fileExistsAtPath:[self fileNameForKey:key]];
}

- (id)objectForKey:(id)key
{
    // 建议用 objectForKey:objectClass: 可以直接返回对象
	return [NSData dataWithContentsOfFile:[self fileNameForKey:key]];
}

- (void)setObject:(id)object forKey:(id)key
{
	if ( nil == object )
	{
		[self removeObjectForKey:key];
	}
    else
    {
        // 用的是AutoCoding里的方法
        [object writeToFile:[self fileNameForKey:key] atomically:YES];
    }
}

- (void)removeObjectForKey:(NSString *)key
{
	[[NSFileManager defaultManager] removeItemAtPath:[self fileNameForKey:key] error:nil];
}

- (void)removeAllObjects
{
	[[NSFileManager defaultManager] removeItemAtPath:_cachePath error:NULL];
	[[NSFileManager defaultManager] createDirectoryAtPath:_cachePath
							  withIntermediateDirectories:YES
											   attributes:nil
													error:NULL];
}

- (id)objectForKeyedSubscript:(id)key
{
	return nil;
}

- (void)setObject:(id)obj forKeyedSubscript:(id)key
{
    ;
}

@end
