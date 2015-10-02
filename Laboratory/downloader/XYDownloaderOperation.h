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
#import "XYDownloader.h"

extern NSString *const XYDownloadStartNotification;
extern NSString *const XYDownloadReceiveResponseNotification;
extern NSString *const XYDownloadStopNotification;
extern NSString *const XYDownloadFinishNotification;

@interface XYDownloaderOperation : NSOperation <XYOperation>

/// NSURLRequest
@property (strong, nonatomic, readonly) NSURLRequest *request;

/// URL连接是否应该咨询认证的证书存储连接 `NSURLConnectionDelegate` method `-connectionShouldUseCredentialStorage:`
@property (nonatomic, assign) BOOL shouldUseCredentialStorage;

/// NSURLCredential 身份认证,`-connection:didReceiveAuthenticationChallenge:`. 这将覆盖任何共享凭证存在的用户名或密码请求
@property (nonatomic, strong) NSURLCredential *credential;

/// XYDownloaderOptions 接收器
@property (assign, nonatomic, readonly) XYDownloaderOptions options;

/// 预期的数据大小
@property (assign, nonatomic) NSInteger expectedSize;

/// NSURLResponse
@property (strong, nonatomic) NSURLResponse *response;

/**
 *  Initializes a `XYDownloaderOperation` object
 *
 *  @see XYDownloaderOperation
 *
 *  @param request        the URL request
 *  @param options        downloader options
 *  @param progressBlock  the block executed when a new chunk of data arrives. 
 *                        @note the progress block is executed on a background queue
 *  @param completedBlock the block executed when the download is done. 
 *                        @note the completed block is executed on the main queue for success. If errors are found, there is a chance the block will be executed on a background queue
 *  @param cancelBlock    the block executed if the download (operation) is cancelled
 *
 *  @return the initialized instance
 */
- (id)initWithRequest:(NSURLRequest *)request
              options:(XYDownloaderOptions)options
             progress:(XYDownloaderProgressBlock)progressBlock
            completed:(XYDownloaderCompletedBlock)completedBlock
            cancelled:(XYNoParamsBlock)cancelBlock;

@end
