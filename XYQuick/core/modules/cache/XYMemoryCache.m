//
//  __  __          ____           _          _
//  \ \/ / /\_/\   /___ \  _   _  (_)   ___  | | __
//   \  /  \_ _/  //  / / | | | | | |  / __| | |/ /
//   /  \   / \  / \_/ /  | |_| | | | | (__  |   <
//  /_/\_\  \_/  \___,_\   \__,_| |_|  \___| |_|\_\
//
//  Copyright (C) Heaven.
//
//	https://github.com/uxyheaven/XYQuick
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.
//

#import "XYMemoryCache.h"

#undef	XYMemoryCache_DEFAULT_MAX_COUNT
#define XYMemoryCache_DEFAULT_MAX_COUNT	(48)

@implementation XYMemoryCache uxy_def_singleton(XYMemoryCache)


- (id)init
{
	self = [super init];
	if ( self )
	{
		_clearWhenMemoryLow = YES;
		_maxCacheCount = XYMemoryCache_DEFAULT_MAX_COUNT;
		_cachedCount = 0;
		
		_cacheKeys = [[NSMutableArray alloc] init];
		_cacheObjs = [[NSMutableDictionary alloc] init];
        
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMemoryCacheNotification:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        // todo
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMemoryCacheNotification:) name:UIApplicationWillTerminateNotification object:nil];
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMemoryCacheNotification:) name:UIApplicationDidEnterBackgroundNotification object:nil];
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	}
    
	return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setClearWhenMemoryLow:(BOOL)clearWhenMemoryLow
{
    if (_clearWhenMemoryLow != clearWhenMemoryLow)
        return;
    
    if (clearWhenMemoryLow == YES)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMemoryCacheNotification:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    
    _clearWhenMemoryLow = clearWhenMemoryLow;
}

- (void)setMaxCacheCount:(NSUInteger)maxCacheCount
{    
    while ( _cachedCount > maxCacheCount )
    {
        NSString * tempKey = [_cacheKeys objectAtIndex:0];
        
        [_cacheObjs removeObjectForKey:tempKey];
        [_cacheKeys removeObjectAtIndex:0];
        
        _cachedCount -= 1;
    }
    
    _maxCacheCount = maxCacheCount;
}

#pragma mark - XYCacheProtocol

- (BOOL)hasObjectForKey:(id)key
{
	return [_cacheObjs objectForKey:key] ? YES : NO;
}

- (id)objectForKey:(id)key
{
	return [_cacheObjs objectForKey:key];
}

- (void)setObject:(id)object forKey:(id)key
{
	if ( nil == key )
		return;
	
	if ( nil == object )
		return;
	
	_cachedCount += 1;
    
	while ( _cachedCount >= _maxCacheCount )
	{
		NSString * tempKey = [_cacheKeys objectAtIndex:0];
        
		[_cacheObjs removeObjectForKey:tempKey];
		[_cacheKeys removeObjectAtIndex:0];
        
		_cachedCount -= 1;
	}
    
	[_cacheKeys addObject:key];
	[_cacheObjs setObject:object forKey:key];
}

- (void)removeObjectForKey:(NSString *)key
{
	if ( [_cacheObjs objectForKey:key] )
	{
		[_cacheKeys removeObjectIdenticalTo:key];
		[_cacheObjs removeObjectForKey:key];
        
		_cachedCount -= 1;
	}
}

- (void)removeAllObjects
{
	[_cacheKeys removeAllObjects];
	[_cacheObjs removeAllObjects];
	
	_cachedCount = 0;
}

#pragma mark -

- (void)handleMemoryCacheNotification:(NSNotification *)notification
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	if ([notification.name isEqualToString:UIApplicationDidReceiveMemoryWarningNotification])
	{
		if ( _clearWhenMemoryLow )
		{
			[self removeAllObjects];
		}
	}
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}

@end

