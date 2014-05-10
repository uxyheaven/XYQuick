//
//  XYSandBox.m
//  JoinShow
//
//  Created by Heaven on 14-1-17.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import "XYSandbox.h"
#import <sys/stat.h>

@interface XYSandbox()
{
	NSString *	_appPath;
	NSString *	_docPath;
	NSString *	_libPrefPath;
	NSString *	_libCachePath;
	NSString *	_tmpPath;
}
@end

@implementation XYSandbox

DEF_SINGLETON( XYSandbox )

@dynamic appPath;
@dynamic docPath;
@dynamic libPrefPath;
@dynamic libCachePath;
@dynamic tmpPath;

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

+(NSString *) resPath:(NSString *)file{
    return [[XYSandbox sharedInstance] resPath:file];
}

-(NSString *) resPath:(NSString *)file{
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

/***************************************************************/
+(void) createDirectoryAtPath:(NSString *)aPath{
    if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:aPath isDirectory:NULL] )
    {
        BOOL ret = [[NSFileManager defaultManager] createDirectoryAtPath:aPath
                                             withIntermediateDirectories:YES
                                                              attributes:nil
                                                                   error:nil];
        if ( NO == ret ) {
            NSLogD(@"%s, create %@ failed", __PRETTY_FUNCTION__, aPath);
            return;
        }
    }
}

+(NSArray *) allFilesAtPath:(NSString *)direString type:(NSString*)fileType operation:(int)operatio{
    NSMutableArray *pathArray = [NSMutableArray array];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *tempArray = [fileManager contentsOfDirectoryAtPath:direString error:nil];
    
    if (tempArray == nil) {
        return nil;
    }
    
    NSString* type = [NSString stringWithFormat:@".%@",fileType];
    for (NSString *fileName in tempArray) {
        BOOL isDir = YES;
        NSString *fullPath = [direString stringByAppendingPathComponent:fileName];
        
        if ([fileManager fileExistsAtPath:fullPath isDirectory:&isDir]){
            if (!isDir && [fileName hasSuffix:type]) {
                    [pathArray addObject:fullPath];
            }
        }
    }
    
    return pathArray;
}

+(uint64_t) sizeAtPath:(NSString *)filePath diskMode:(BOOL)diskMode{
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
                }else
                {
                    if (diskMode)
                        totalSize += fileStat.st_blocks * 512;
                    else
                        totalSize += fileStat.st_size;
                }
            }
        }
    }
    
    return totalSize;
}

@end







