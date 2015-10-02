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
//  This file Copy from SDWebImage.

#import <Foundation/Foundation.h>

@protocol XYOperation <NSObject>
- (void)cancel;
@end

typedef void(^XYNoParamsBlock)();

typedef NS_OPTIONS(NSUInteger, XYDownloaderOptions) {
    /// 将下载放到低级先级队列中
    XYDownloaderLowPriority = 1 << 0,
    XYDownloaderProgressiveDownload = 1 << 1,
    /// 默认情况下请求不使用NSURLCache，如果设置该选项，则以默认的缓存策略来使用NSURLCache
    XYDownloaderUseNSURLCache = 1 << 2,
    /// 如果从NSURLCache缓存中读取数据，则使用nil作为参数来调用完成block
    XYDownloaderIgnoreCachedResponse = 1 << 3,
    /// 在iOS 4+系统上，允许程序进入后台后继续下载图片。该操作通过向系统申请额外的时间来完成后台下载。如果后台任务终止，则操作会被取消
    XYDownloaderContinueInBackground = 1 << 4,
    /// 通过设置NSMutableURLRequest.HTTPShouldHandleCookies = YES来处理存储在NSHTTPCookieStore中的cookie
    XYDownloaderHandleCookies = 1 << 5,
    /// 允许不受信任的SSL证书。主要用于测试目的。
    XYDownloaderAllowInvalidSSLCertificates = 1 << 6,
    /// 将下载放到高优先级队列中
    XYDownloaderHighPriority = 1 << 7,
};

typedef NS_ENUM(NSInteger, XYDownloaderExecutionOrder) {
    /// 默认值, 先进先出
    XYDownloaderFIFOExecutionOrder,
    /// 后进先出
    XYDownloaderLIFOExecutionOrder
};

extern NSString *const XYDownloadStartNotification;
extern NSString *const XYDownloadStopNotification;

/// 下载进度
typedef void(^XYDownloaderProgressBlock)(NSInteger receivedSize, NSInteger expectedSize);
/// 下载完成
typedef void(^XYDownloaderCompletedBlock)(UIImage *image, NSData *data, NSError *error, BOOL finished);
/// header过滤器
typedef NSDictionary *(^XYDownloaderHeadersFilterBlock)(NSURL *url, NSDictionary *headers);

/**
 * 异步下载者
 */
@interface XYDownloader : NSObject

+ (XYDownloader *)sharedInstance;

/// 最大并发下载数
@property (assign, nonatomic) NSInteger maxConcurrentDownloads;
/// 当前的下载数量
@property (readonly, nonatomic) NSUInteger currentDownloadCount;

/// 下载超时时间. Default: 15.0
@property (assign, nonatomic) NSTimeInterval downloadTimeout;

/// 改变下载顺序. Default value is `XYDownloaderFIFOExecutionOrder`.
@property (assign, nonatomic) XYDownloaderExecutionOrder executionOrder;

/// username
@property (strong, nonatomic) NSString *username;

/// password
@property (strong, nonatomic) NSString *password;

/// header过滤器
@property (nonatomic, copy) XYDownloaderHeadersFilterBlock headersFilter;

/// 为每一个下载请求的头设置值. 如果value = nil, 则是remove
- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;
/// 返回header的value
- (NSString *)valueForHTTPHeaderField:(NSString *)field;

/// 设置自定义的下载操作类
- (void)setOperationClass:(Class)operationClass;

/**
 * 创建一个下载请求
 *
 * The delegate will be informed when the image is finish downloaded or an error has happen.
 *
 * @see XYDownloaderDelegate
 *
 * @param url            The URL to the image to download
 * @param options        The options to be used for this download
 * @param progressBlock  A block called repeatedly while the image is downloading
 * @param completedBlock A block called once the download is completed.
 *                       If the download succeeded, the image parameter is set, in case of error,
 *                       error parameter is set with the error. The last parameter is always YES
 *                       if XYDownloaderProgressiveDownload isn't use. With the
 *                       XYDownloaderProgressiveDownload option, this block is called
 *                       repeatedly with the partial image object and the finished argument set to NO
 *                       before to be called a last time with the full image and finished argument
 *                       set to YES. In case of error, the finished argument is always YES.
 *
 * @return A cancellable XYOperation
 */
- (id <XYOperation>)downloadImageWithURL:(NSURL *)url
                                         options:(XYDownloaderOptions)options
                                        progress:(XYDownloaderProgressBlock)progressBlock
                                       completed:(XYDownloaderCompletedBlock)completedBlock;

/// 暂停
- (void)setSuspended:(BOOL)suspended;

@end
