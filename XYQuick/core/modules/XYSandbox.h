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

#import "XYQuick_Predefine.h"
#pragma mark -

@interface XYSandbox : NSObject uxy_as_singleton

@property (nonatomic, readonly, copy) NSString *appPath;
@property (nonatomic, readonly, copy) NSString *docPath;
@property (nonatomic, readonly, copy) NSString *libPrefPath;
@property (nonatomic, readonly, copy) NSString *libCachePath;
@property (nonatomic, readonly, copy) NSString *tmpPath;

/// 程序目录，不能存任何东西
+ (NSString *)appPath;
/// 文档目录，需要ITUNES同步备份的数据存这里
+ (NSString *)docPath;
/// 配置目录，配置文件存这里
+ (NSString *)libPrefPath;
/// 缓存目录，系统在磁盘空间不足的情况下会删除里面的文件，iTunes会删除
+ (NSString *)libCachePath;
/// 缓存目录，APP退出后，系统可能会删除这里的内容
+ (NSString *)tmpPath;

/// 返回目标的资源目录
+ (NSString *)resPath:(NSString *)file;

/// 如果目标文件夹不存在, 创建一个空文件夹
+ (BOOL)touchDirectory:(NSString *)path;
/// 如果目标文件不存在, 创建一个空文件
+ (BOOL)touchFile:(NSString *)file;

/// 返回文件的MD5
+ (NSString *)fileMD5:(NSString *)path;

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

/// 设置目录里的文件不备份
+ (BOOL)skipFileBackupForItemAtURL:(NSURL *)URL;

@end




