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

#import "XYDownloader.h"
#import "XYDownloaderOperation.h"

static NSString *const kProgressCallbackKey = @"progress";
static NSString *const kCompletedCallbackKey = @"completed";

@interface XYDownloader ()

@property (strong, nonatomic) NSOperationQueue *downloadQueue;
@property (weak, nonatomic) NSOperation *lastAddedOperation;
@property (assign, nonatomic) Class operationClass;
@property (strong, nonatomic) NSMutableDictionary *URLCallbacks;
@property (strong, nonatomic) NSMutableDictionary *HTTPHeaders;
// 所有的下载操作的网络请求的响应, 都在一个队列中进行序列化
@property (nonatomic, strong) dispatch_queue_t barrierQueue;

@end

@implementation XYDownloader

static dispatch_once_t __singletonToken;
static id __singleton__;
+ (instancetype)sharedInstance
{
    dispatch_once( &__singletonToken, ^{ __singleton__ = [[self alloc] init]; } );
    return __singleton__;
}

- (id)init
{
    if ((self = [super init]))
    {
        _operationClass  = [XYDownloaderOperation class];
        _executionOrder  = XYDownloaderFIFOExecutionOrder;
        _downloadQueue   = [[NSOperationQueue alloc] init];
        _URLCallbacks    = [@{} mutableCopy];
        _barrierQueue    = dispatch_queue_create("com.hackemist.XYDownloaderBarrierQueue", DISPATCH_QUEUE_CONCURRENT);
        _downloadTimeout = 15.0;
        _downloadQueue.maxConcurrentOperationCount = 3;
    }
    return self;
}

- (void)dealloc
{
    [self.downloadQueue cancelAllOperations];
}

- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field
{
    if (value)
    {
        self.HTTPHeaders[field] = value;
    }
    else
    {
        [self.HTTPHeaders removeObjectForKey:field];
    }
}

- (NSString *)valueForHTTPHeaderField:(NSString *)field
{
    return self.HTTPHeaders[field];
}

- (void)setMaxConcurrentDownloads:(NSInteger)maxConcurrentDownloads
{
    _downloadQueue.maxConcurrentOperationCount = maxConcurrentDownloads;
}

- (NSUInteger)currentDownloadCount
{
    return _downloadQueue.operationCount;
}

- (NSInteger)maxConcurrentDownloads
{
    return _downloadQueue.maxConcurrentOperationCount;
}

- (void)setOperationClass:(Class)operationClass
{
    _operationClass = operationClass ?: [XYDownloaderOperation class];
}

- (id <XYOperation>)downloadImageWithURL:(NSURL *)url options:(XYDownloaderOptions)options progress:(XYDownloaderProgressBlock)progressBlock completed:(XYDownloaderCompletedBlock)completedBlock
{
    __block XYDownloaderOperation *operation;
    __weak __typeof(self)wself = self;

    [self addProgressCallback:progressBlock andCompletedBlock:completedBlock forURL:url createCallback:^{
        NSTimeInterval timeoutInterval = wself.downloadTimeout ?: 15.0;

        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:timeoutInterval];
        request.HTTPShouldHandleCookies = (options & XYDownloaderHandleCookies);
        request.HTTPShouldUsePipelining = YES;
        request.allHTTPHeaderFields = wself.headersFilter ? wself.headersFilter(url, [wself.HTTPHeaders copy]) : wself.HTTPHeaders;

        operation = [[wself.operationClass alloc] initWithRequest:request
                                                          options:options
                                                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                             XYDownloader *sself = wself;
                                                             if (!sself) return;
                                                             
                                                             __block NSArray *callbacksForURL;
                                                             dispatch_sync(sself.barrierQueue, ^{
                                                                 callbacksForURL = [sself.URLCallbacks[url] copy];
                                                             });
                                                             for (NSDictionary *callbacks in callbacksForURL)
                                                             {
                                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                                     XYDownloaderProgressBlock callback = callbacks[kProgressCallbackKey];
                                                                     if (callback) callback(receivedSize, expectedSize);
                                                                 });
                                                             }
                                                         }
                                                        completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                                            XYDownloader *sself = wself;
                                                            if (!sself) return;
                                                            
                                                            __block NSArray *callbacksForURL;
                                                            dispatch_barrier_sync(sself.barrierQueue, ^{
                                                                callbacksForURL = [sself.URLCallbacks[url] copy];
                                                                if (finished) {
                                                                    [sself.URLCallbacks removeObjectForKey:url];
                                                                }
                                                            });
                                                            for (NSDictionary *callbacks in callbacksForURL)
                                                            {
                                                                XYDownloaderCompletedBlock callback = callbacks[kCompletedCallbackKey];
                                                                if (callback) callback(image, data, error, finished);
                                                            }
                                                        }
                                                        cancelled:^{
                                                            XYDownloader *sself = wself;
                                                            if (!sself) return;
                                                            
                                                            dispatch_barrier_async(sself.barrierQueue, ^{
                                                                [sself.URLCallbacks removeObjectForKey:url];
                                                            });
                                                        }];
        
        if (wself.username && wself.password)
        {
            operation.credential = [NSURLCredential credentialWithUser:wself.username password:wself.password persistence:NSURLCredentialPersistenceForSession];
        }
        
        if (options & XYDownloaderHighPriority)
        {
            operation.queuePriority = NSOperationQueuePriorityHigh;
        }
        else if (options & XYDownloaderLowPriority)
        {
            operation.queuePriority = NSOperationQueuePriorityLow;
        }

        [wself.downloadQueue addOperation:operation];
        if (wself.executionOrder == XYDownloaderLIFOExecutionOrder)
        {
            // 先进后出
            [wself.lastAddedOperation addDependency:operation];
            wself.lastAddedOperation = operation;
        }
    }];

    return operation;
}

- (void)addProgressCallback:(XYDownloaderProgressBlock)progressBlock andCompletedBlock:(XYDownloaderCompletedBlock)completedBlock forURL:(NSURL *)url createCallback:(XYNoParamsBlock)createCallback
{
    if (url == nil)
    {
        if (completedBlock != nil)
        {
            completedBlock(nil, nil, nil, NO);
        }
        return;
    }

    dispatch_barrier_sync(self.barrierQueue, ^{
        BOOL first = NO;
        if (!self.URLCallbacks[url])
        {
            self.URLCallbacks[url] = [@{} mutableCopy];
            first = YES;
        }

        // Handle single download of simultaneous download request for the same URL
        NSMutableArray *callbacksForURL = self.URLCallbacks[url];
        NSMutableDictionary *callbacks = [@{} mutableCopy];
        if (progressBlock)
            callbacks[kProgressCallbackKey] = [progressBlock copy];
        if (completedBlock)
            callbacks[kCompletedCallbackKey] = [completedBlock copy];
        [callbacksForURL addObject:callbacks];
        self.URLCallbacks[url] = callbacksForURL;

        if (first)
            createCallback();
    });
}

- (void)setSuspended:(BOOL)suspended
{
    self.downloadQueue.suspended = suspended;
}

@end
