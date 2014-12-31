//
//  XYSandBox.h
//  JoinShow
//
//  Created by Heaven on 14-1-17.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import "XYPrecompile.h"

@interface XYSandbox : NSObject

@property (nonatomic, readonly, copy) NSString *	appPath;
@property (nonatomic, readonly, copy) NSString *	docPath;
@property (nonatomic, readonly, copy) NSString *	libPrefPath;
@property (nonatomic, readonly, copy) NSString *	libCachePath;
@property (nonatomic, readonly, copy) NSString *	tmpPath;

AS_SINGLETON( XYSandbox )

+ (NSString *)appPath;		// 程序目录，不能存任何东西
+ (NSString *)docPath;		// 文档目录，需要ITUNES同步备份的数据存这里
+ (NSString *)libPrefPath;	// 配置目录，配置文件存这里
+ (NSString *)libCachePath;	// 缓存目录，系统在磁盘空间不足的情况下会删除里面的文件，ITUNES会删除
+ (NSString *)tmpPath;		// 缓存目录，APP退出后，系统可能会删除这里的内容

+ (NSString *)resPath:(NSString *)file;      // 资源目录

+ (BOOL)touch:(NSString *)path;
+ (BOOL)touchFile:(NSString *)file;

/**
 * 创建目录
 * api parameters 说明
 * aPath 目录路径
 */
+ (void)createDirectoryAtPath:(NSString *)aPath;

/**
 * 返回目下所有给定后缀的文件的方法
 * api parameters 说明
 *
 * direString 目录绝对路径
 * fileType 文件后缀名
 * operation (预留,暂时没用)
 */
+ (NSArray *)allFilesAtPath:(NSString *)direString type:(NSString*)fileType operation:(int)operation;


/**
 * 返回目录文件的size,单位字节
 * api parameters 说明
 *
 * filePath 目录路径
 * diskMode 是否是磁盘占用的size
 */
+ (uint64_t)sizeAtPath:(NSString *)filePath diskMode:(BOOL)diskMode;

// 设置目录里的文件不备份
+ (BOOL)skipFileBackupForItemAtURL:(NSURL *)URL;

@end




