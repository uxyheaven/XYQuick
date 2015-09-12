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

@interface XYSandbox()

@property (nonatomic, copy) NSString *appPath;
@property (nonatomic, copy) NSString *docPath;
@property (nonatomic, copy) NSString *libPrefPath;
@property (nonatomic, copy) NSString *libCachePath;
@property (nonatomic, copy) NSString *tmpPath;

@end

@implementation XYSandbox uxy_def_singleton

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
		
		[self touch:path];
        
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
		NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
		NSString * path = [[paths objectAtIndex:0] stringByAppendingFormat:@"/Caches"];
        
		[self touch:path];
		
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
		
		[self touch:path];
        
		_tmpPath = path;
	}
    
	return _tmpPath;
}

+ (NSString *)resPath:(NSString *)file{
    return [[XYSandbox sharedInstance] resPath:file];
}

- (NSString *)resPath:(NSString *)file{
    NSString *str =[file stringByDeletingPathExtension];
    NSString *str2 = [file pathExtension];
    
    return [[NSBundle mainBundle] pathForResource:str ofType:str2];
}

+ (BOOL)touch:(NSString *)path
{
	return [[XYSandbox sharedInstance] touch:path];
}

- (BOOL)touch:(NSString *)path
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
	return [[XYSandbox sharedInstance] touchFile:file];
}

- (BOOL)touchFile:(NSString *)file
{
	if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:file] )
	{
		return [[NSFileManager defaultManager] createFileAtPath:file
													   contents:[NSData data]
													 attributes:nil];
	}
	
	return YES;
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
    
    // iOS <= 5.0.1
    //if (&NSURLIsExcludedFromBackupKey == nil) {
    
    const char *filePath = [[URL path] fileSystemRepresentation];
    const char *attrName = "com.apple.MobileBackup";
    u_int8_t attrValue   = 1;
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    
    return (result == 0);
    
    // 官方给的代码但是实际上真的是很废，一点用都没有，只用前面那段的就行了，别用下面的
    //    // iOS >= 5.1
    //    NSError *error = nil;
    //    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
    //                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    //    if(!success){
    //        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    //    }
    //    return success;
}

@end







