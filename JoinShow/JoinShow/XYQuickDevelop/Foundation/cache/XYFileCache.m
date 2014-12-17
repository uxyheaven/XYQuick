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
#import "XYThread.h"

@interface XYFileCache ()
{
    NSFileManager *_fileManager;
}

@end

@implementation XYFileCache

DEF_SINGLETON( XYFileCache );

- (id)init
{
    return [self initWithNamespace:@"default"];
}

- (id)initWithNamespace:(NSString *)ns
{
    NSAssert(ns.length > 0, @"Namespace 必须得有");
    
    self = [super init];
    if ( self )
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        _diskCachePath = [paths[0] stringByAppendingPathComponent:ns];
        
        _maxCacheAge = XYFileCache_fileExpires;
        
        _fileManager = [NSFileManager defaultManager];
        
#if TARGET_OS_IPHONE
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(cleanDisk)
                                                     name:UIApplicationWillTerminateNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(backgroundCleanDisk)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
#endif
        
    }
    return self;
}
- (void)dealloc
{

}
#pragma mark- 
- (NSString *)fileNameForKey:(NSString *)key
{
	NSString *pathName = _diskCachePath;
    
	if ( NO == [_fileManager fileExistsAtPath:pathName] )
	{
		[_fileManager createDirectoryAtPath:pathName
								  withIntermediateDirectories:YES
												   attributes:nil
														error:NULL];
	}
    
    pathName = [pathName stringByAppendingPathComponent:key];
    
    NSAssert(pathName.length > 0, @"路径得有");
    
	return pathName;
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

// 清除当前 XYFileCache 所有的文件
- (void)clearDisk
{
    [self clearDiskOnCompletion:nil];
}
- (void)clearDiskOnCompletion:(void (^)(void))completion
{
    BACKGROUND_IOFILE_BEGIN
    {
        [_fileManager removeItemAtPath:_diskCachePath error:NULL];
        [_fileManager createDirectoryAtPath:_diskCachePath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:NULL];
        if (completion)
        {
            FOREGROUND_BEGIN
            {
                completion();
            }
            FOREGROUND_COMMIT
        }
    }
    BACKGROUND_IOFILE_COMMIT
}
// 清除当前 XYFileCache 所有过期的文件
- (void)cleanDisk
{
     [self cleanDiskWithCompletionBlock:nil];
}
- (void)cleanDiskWithCompletionBlock:(void (^)(void))completion
{
    BACKGROUND_IOFILE_BEGIN
    {
        NSURL *diskCacheURL = [NSURL fileURLWithPath:_diskCachePath isDirectory:YES];
        NSArray *resourceKeys = @[NSURLIsDirectoryKey, NSURLContentModificationDateKey, NSURLTotalFileAllocatedSizeKey];
        
        // This enumerator prefetches useful properties for our cache files.
        NSDirectoryEnumerator *fileEnumerator = [_fileManager enumeratorAtURL:diskCacheURL
                                                   includingPropertiesForKeys:resourceKeys
                                                                      options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                 errorHandler:NULL];
        
        NSDate *expirationDate = [NSDate dateWithTimeIntervalSinceNow:-_maxCacheAge];
        NSMutableDictionary *cacheFiles = [NSMutableDictionary dictionary];
        NSUInteger currentCacheSize = 0;
        
        // Enumerate all of the files in the cache directory.  This loop has two purposes:
        //
        //  1. Removing files that are older than the expiration date.
        //  2. Storing file attributes for the size-based cleanup pass.
        NSMutableArray *urlsToDelete = [[NSMutableArray alloc] init];
        for (NSURL *fileURL in fileEnumerator)
        {
            NSDictionary *resourceValues = [fileURL resourceValuesForKeys:resourceKeys error:NULL];
            
            // Skip directories.
            if ([resourceValues[NSURLIsDirectoryKey] boolValue])
            {
                continue;
            }
            
            // Remove files that are older than the expiration date;
            NSDate *modificationDate = resourceValues[NSURLContentModificationDateKey];
            if ([[modificationDate laterDate:expirationDate] isEqualToDate:expirationDate])
            {
                [urlsToDelete addObject:fileURL];
                continue;
            }
            
            // Store a reference to this file and account for its total size.
            NSNumber *totalAllocatedSize = resourceValues[NSURLTotalFileAllocatedSizeKey];
            currentCacheSize += [totalAllocatedSize unsignedIntegerValue];
            [cacheFiles setObject:resourceValues forKey:fileURL];
        }
        
        for (NSURL *fileURL in urlsToDelete)
        {
            [_fileManager removeItemAtURL:fileURL error:nil];
        }
        
        // If our remaining disk cache exceeds a configured maximum size, perform a second
        // size-based cleanup pass.  We delete the oldest files first.
        if (self.maxCacheSize > 0 && currentCacheSize > self.maxCacheSize) {
            // Target half of our maximum cache size for this cleanup pass.
            const NSUInteger desiredCacheSize = self.maxCacheSize / 2;
            
            // Sort the remaining cache files by their last modification time (oldest first).
            NSArray *sortedFiles = [cacheFiles keysSortedByValueWithOptions:NSSortConcurrent
                                                            usingComparator:^NSComparisonResult(id obj1, id obj2) {
                                                                return [obj1[NSURLContentModificationDateKey] compare:obj2[NSURLContentModificationDateKey]];
                                                            }];
            
            // Delete files until we fall below our desired cache size.
            for (NSURL *fileURL in sortedFiles) {
                if ([_fileManager removeItemAtURL:fileURL error:nil]) {
                    NSDictionary *resourceValues = cacheFiles[fileURL];
                    NSNumber *totalAllocatedSize = resourceValues[NSURLTotalFileAllocatedSizeKey];
                    currentCacheSize -= [totalAllocatedSize unsignedIntegerValue];
                    
                    if (currentCacheSize < desiredCacheSize) {
                        break;
                    }
                }
            }
        }
        
        if (completion)
        {
            FOREGROUND_BEGIN
                completion();
            FOREGROUND_COMMIT
        }
    }
    BACKGROUND_IOFILE_COMMIT
}

- (NSUInteger)getSize
{
    __block NSUInteger size = 0;
    dispatch_sync([XYGCD backIOFileQueue], ^{
        NSDirectoryEnumerator *fileEnumerator = [_fileManager enumeratorAtPath:_diskCachePath];
        for (NSString *fileName in fileEnumerator)
        {
            NSString *filePath  = [_diskCachePath stringByAppendingPathComponent:fileName];
            NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
            size += [attrs fileSize];
        }
    });
    return size;
}

- (NSUInteger)getDiskCount
{
    __block NSUInteger count = 0;
    dispatch_sync([XYGCD backIOFileQueue], ^{
        NSDirectoryEnumerator *fileEnumerator = [_fileManager enumeratorAtPath:_diskCachePath];
        count = [[fileEnumerator allObjects] count];
    });
    return count;
}
#pragma mark-
- (void)backgroundCleanDisk
{
    UIApplication *application = [UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        // Clean up any unfinished task business by marking where you
        // stopped or ending the task outright.
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    
    // Start the long-running task and return immediately.
    [self cleanDiskWithCompletionBlock:^{
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
}

#pragma mark - XYCacheProtocol
- (BOOL)hasObjectForKey:(id)key
{
	return [_fileManager fileExistsAtPath:[self fileNameForKey:key]];
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
	[_fileManager removeItemAtPath:[self fileNameForKey:key] error:nil];
}

- (void)removeAllObjects
{
    [self clearDisk];
}

@end
