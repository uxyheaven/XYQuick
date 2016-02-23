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
//  This file Copy from Samurai.

#import "XYSandbox.h"

#import <sys/stat.h>
#import <sys/xattr.h>

#undef kFileHashDefaultChunkSizeForReadingData
#define kFileHashDefaultChunkSizeForReadingData     1024*8 // 8K

@interface XYSandbox()

@property (nonatomic, copy) NSString *appPath;
@property (nonatomic, copy) NSString *docPath;
@property (nonatomic, copy) NSString *libPrefPath;
@property (nonatomic, copy) NSString *libCachePath;
@property (nonatomic, copy) NSString *tmpPath;

@end

@implementation XYSandbox uxy_def_singleton(XYSandbox)

+ (NSString *)appPath
{
	return [[XYSandbox sharedInstance] appPath];
}

- (NSString *)appPath
{
	if ( nil == _appPath )
	{
		NSError * error = nil;
		NSArray * paths = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:NSHomeDirectory() error:&error];
        
		for ( NSString * path in paths )
		{
			if ( [path hasSuffix:@".app"] )
			{
				_appPath = [NSString stringWithFormat:@"%@/%@", NSHomeDirectory(), path];
				break;
			}
		}
	}
    
	return _appPath;
}

+ (NSString *)docPath
{
	return [[XYSandbox sharedInstance] docPath];
}

- (NSString *)docPath
{
	if ( nil == _docPath )
	{
		NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		_docPath = [paths objectAtIndex:0];
	}
	
	return _docPath;
}

+ (NSString *)libPrefPath
{
	return [[XYSandbox sharedInstance] libPrefPath];
}

- (NSString *)libPrefPath
{
	if ( nil == _libPrefPath )
	{
		NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
		NSString * path = [[paths objectAtIndex:0] stringByAppendingFormat:@"/Preference"];

		_libPrefPath = path;
	}
    
	return _libPrefPath;
}

+ (NSString *)libCachePath
{
	return [[XYSandbox sharedInstance] libCachePath];
}

- (NSString *)libCachePath
{
	if ( nil == _libCachePath )
	{
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
		NSString *path = [[paths objectAtIndex:0] stringByAppendingFormat:@"/Caches"];
		
		_libCachePath = path;
	}
	
	return _libCachePath;
}

+ (NSString *)tmpPath
{
	return [[XYSandbox sharedInstance] tmpPath];
}

- (NSString *)tmpPath
{
	if ( nil == _tmpPath )
	{
		NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
		NSString * path = [[paths objectAtIndex:0] stringByAppendingFormat:@"/tmp"];

		_tmpPath = path;
	}
    
	return _tmpPath;
}

+ (NSString *)resPath:(NSString *)file
{
    NSString *str =[file stringByDeletingPathExtension];
    NSString *str2 = [file pathExtension];
    
    return [[NSBundle mainBundle] pathForResource:str ofType:str2];
}


+ (BOOL)touchDirectory:(NSString *)path
{
    if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:path] )
    {
        return [[NSFileManager defaultManager] createDirectoryAtPath:path
                                         withIntermediateDirectories:YES
                                                          attributes:nil
                                                               error:NULL];
    }
    
    return YES;
}


+ (BOOL)touchFile:(NSString *)file
{
    if (file.length < 1)
        return NO;
    
    NSRange range = [file rangeOfString:@"/" options:NSBackwardsSearch];
    if (range.location == NSNotFound)
        return NO;
    
    NSString *path = [file substringToIndex:range.location];
    
    if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:path] )
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:path
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:NULL];
    }
    
    if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:file] )
    {
        return [[NSFileManager defaultManager] createFileAtPath:file
                                                       contents:[NSData data]
                                                     attributes:nil];
    }
    
    return YES;
}

+ (NSString *)fileMD5:(NSString *)path
{
    return [self __uxy_getDownLoadFileMD5WithPath:path];
}

+ (NSArray *)allFilesAtPath:(NSString *)direString type:(NSString*)fileType operation:(int)operatio
{
    NSMutableArray *pathArray = [NSMutableArray array];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *tempArray = [fileManager contentsOfDirectoryAtPath:direString error:nil];
    
    if (tempArray == nil)
        return nil;
    
    NSString* type = [NSString stringWithFormat:@".%@",fileType];
    for (NSString *fileName in tempArray)
    {
        BOOL isDir = YES;
        NSString *fullPath = [direString stringByAppendingPathComponent:fileName];
        
        if ([fileManager fileExistsAtPath:fullPath isDirectory:&isDir])
        {
            if (!isDir && [fileName hasSuffix:type])
            {
                    [pathArray addObject:fullPath];
            }
        }
    }
    
    return pathArray;
}

+ (uint64_t)sizeAtPath:(NSString *)filePath diskMode:(BOOL)diskMode
{
    uint64_t totalSize = 0;
    NSMutableArray *searchPaths = [NSMutableArray arrayWithObject:filePath];
    while ([searchPaths count] > 0)
    {
        @autoreleasepool
        {
            NSString *fullPath = [NSString stringWithString:[searchPaths objectAtIndex:0]];
            [searchPaths removeObjectAtIndex:0];
            
            struct stat fileStat;
            if (lstat([fullPath fileSystemRepresentation], &fileStat) == 0)
            {
                if (fileStat.st_mode & S_IFDIR)
                {
                    NSArray *childSubPaths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:fullPath error:nil];
                    for (NSString *childItem in childSubPaths)
                    {
                        NSString *childPath = [fullPath stringByAppendingPathComponent:childItem];
                        [searchPaths insertObject:childPath atIndex:0];
                    }
                }
                else
                {
                    if (diskMode)
                    {
                        totalSize += fileStat.st_blocks * 512;
                    }
                    else
                    {
                        totalSize += fileStat.st_size;
                    }
                }
            }
        }
    }
    
    return totalSize;
}

+ (BOOL)skipFileBackupForItemAtURL:(NSURL*)URL
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[URL path]])
        return NO;
    
    assert([[NSFileManager defaultManager] fileExistsAtPath:[URL path]]);
    
    NSError *error = nil;
    // iOS 5.1 and later 以后的方法
    BOOL success = [URL setResourceValue:[NSNumber numberWithBool:YES]
                                  forKey:NSURLIsExcludedFromBackupKey
                                   error:&error];
    if(!success)
    {
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}

#pragma mark -
+ (NSString*)__uxy_getDownLoadFileMD5WithPath:(NSString*)path
{
    return (__bridge_transfer NSString *)__uxy_FileMD5HashCreateWithPath((__bridge CFStringRef)path,kFileHashDefaultChunkSizeForReadingData);
}

CFStringRef __uxy_FileMD5HashCreateWithPath(CFStringRef filePath, size_t chunkSizeForReadingData)
{
    
    // Declare needed variables
    CFStringRef result = NULL;
    CFReadStreamRef readStream = NULL;
    
    // Get the file URL
    CFURLRef fileURL =
    CFURLCreateWithFileSystemPath(kCFAllocatorDefault,
                                  (CFStringRef)filePath,
                                  kCFURLPOSIXPathStyle,
                                  (Boolean)false);
    
    CC_MD5_CTX hashObject;
    bool hasMoreData = true;
    bool didSucceed;
    
    if (!fileURL)
        goto done;
    
    // Create and open the read stream
    readStream = CFReadStreamCreateWithFile(kCFAllocatorDefault,
                                            (CFURLRef)fileURL);
    if (!readStream)
        goto done;
    didSucceed = (bool)CFReadStreamOpen(readStream);
    
    if (!didSucceed)
        goto done;
    
    // Initialize the hash object
    CC_MD5_Init(&hashObject);
    
    // Make sure chunkSizeForReadingData is valid
    if (!chunkSizeForReadingData)
    {
        chunkSizeForReadingData = kFileHashDefaultChunkSizeForReadingData;
    }
    
    // Feed the data to the hash object
    while (hasMoreData)
    {
        uint8_t buffer[chunkSizeForReadingData];
        CFIndex readBytesCount = CFReadStreamRead(readStream,
                                                  (UInt8 *)buffer,
                                                  (CFIndex)sizeof(buffer));
        if (readBytesCount == -1)break;
        if (readBytesCount == 0)
        {
            hasMoreData =false;
            continue;
        }
        CC_MD5_Update(&hashObject,(const void *)buffer,(CC_LONG)readBytesCount);
    }
    
    // Check if the read operation succeeded
    didSucceed = !hasMoreData;
    
    // Compute the hash digest
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &hashObject);
    
    // Abort if the read operation failed
    if (!didSucceed)
        goto done;
    
    // Compute the string result
    char hash[2 *sizeof(digest) + 1];
    for (size_t i =0; i < sizeof(digest); ++i)
    {
        snprintf(hash + (2 * i),3, "%02x", (int)(digest[i]));
    }
    result = CFStringCreateWithCString(kCFAllocatorDefault,
                                       (const char *)hash,
                                       kCFStringEncodingUTF8);
    
done:
    
    if (readStream)
    {
        CFReadStreamClose(readStream);
        CFRelease(readStream);
    }
    if (fileURL)
    {
        CFRelease(fileURL);
    }
    return result;
}

@end


