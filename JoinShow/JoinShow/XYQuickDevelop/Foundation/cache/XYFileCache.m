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
#import "NSObject+XY.h"

@implementation XYFileCache

DEF_SINGLETON( XYFileCache );

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.cacheUser = @"";

		self.cachePath = [NSString stringWithFormat:@"%@/%@/Cache/", [XYSandbox libCachePath], [XYSystemInfo appVersion]];
	}
	return self;
}

- (void)dealloc
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
    
	self.cachePath = nil;
	self.cacheUser = nil;
	
	[super dealloc];
}

- (NSString *)fileNameForKey:(NSString *)key
{
	NSString * pathName = nil;
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
    
	return [pathName stringByAppendingString:key];
}

- (BOOL)hasObjectForKey:(id)key
{
	return [[NSFileManager defaultManager] fileExistsAtPath:[self fileNameForKey:key]];
}

- (id)objectForKey:(id)key
{
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
		NSData * data = [object asNSData];
		if ( data )
		{
			[data writeToFile:[self fileNameForKey:key]
					  options:NSDataWritingAtomic
						error:NULL];
		}
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
	return [self objectForKey:key];
}

- (void)setObject:(id)obj forKeyedSubscript:(id)key
{
	[self setObject:obj forKey:key];
}

@end
