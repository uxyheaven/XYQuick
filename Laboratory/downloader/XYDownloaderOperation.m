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

#import "XYDownloaderOperation.h"

NSString *const XYDownloadStartNotification = @"XYDownloadStartNotification";
NSString *const XYDownloadReceiveResponseNotification = @"XYDownloadReceiveResponseNotification";
NSString *const XYDownloadStopNotification = @"XYDownloadStopNotification";
NSString *const XYDownloadFinishNotification = @"XYDownloadFinishNotification";

@interface XYDownloaderOperation () <NSURLConnectionDataDelegate>

@property (nonatomic, copy) XYDownloaderProgressBlock progressBlock;
@property (nonatomic, copy) XYDownloaderCompletedBlock completedBlock;
@property (nonatomic, copy) XYNoParamsBlock cancelBlock;

@property (nonatomic, assign, getter = isExecuting) BOOL executing;
@property (nonatomic, assign, getter = isFinished) BOOL finished;
@property (nonatomic, strong) NSURLConnection *connection;
@property (atomic, strong) NSThread *thread;
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, strong) NSOutputStream *outputStream;

@property (nonatomic, strong) NSMutableURLRequest *request;


#if TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
@property (assign, nonatomic) UIBackgroundTaskIdentifier backgroundTaskId;
#endif

@end

@implementation XYDownloaderOperation

@synthesize executing = _executing;
@synthesize finished = _finished;

- (id)initWithRequest:(NSURLRequest *)request
              options:(XYDownloaderOptions)options
             progress:(XYDownloaderProgressBlock)progressBlock
            completed:(XYDownloaderCompletedBlock)completedBlock
            cancelled:(XYNoParamsBlock)cancelBlock
{
    if ((self = [super init]))
    {
        _request = request;
        _shouldUseCredentialStorage = YES;
        _options = options;
        _progressBlock = [progressBlock copy];
        _completedBlock = [completedBlock copy];
        _cancelBlock = [cancelBlock copy];
        _executing = NO;
        _finished = NO;
        _expectedSize = 0;
    }
    return self;
}

- (void)start
{
    @synchronized (self) {
        if (self.isCancelled)
        {
            self.finished = YES;
            [self reset];
            return;
        }

        if ([self shouldContinueWhenAppEntersBackground])
        {
            __weak __typeof__ (self) wself = self;
            self.backgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
                __strong __typeof (wself) sself = wself;
                if (sself)
                {
                    [sself cancel];

                    [[UIApplication sharedApplication] endBackgroundTask:sself.backgroundTaskId];
                    sself.backgroundTaskId = UIBackgroundTaskInvalid;
                }
            }];
        }
        self.executing = YES;
        
        self.request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.remoteURL]
                                               cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                           timeoutInterval:15];
        
        self.connection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self startImmediately:NO];
        self.thread = [NSThread currentThread];
    }

    [self.connection start];

    if (self.connection)
    {
        if (self.progressBlock)
        {
            self.progressBlock(0, NSURLResponseUnknownLength);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:XYDownloadStartNotification object:self];
        });

        CFRunLoopRun();
        
        if (!self.isFinished)
        {
            [self.connection cancel];
            [self connection:self.connection didFailWithError:[NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorTimedOut userInfo:@{NSURLErrorFailingURLErrorKey : self.request.URL}]];
        }
    }
    else
    {
        if (self.completedBlock)
        {
            self.completedBlock(nil, nil, [NSError errorWithDomain:NSURLErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey : @"Connection can't be initialized"}], YES);
        }
    }

    if (self.backgroundTaskId != UIBackgroundTaskInvalid)
    {
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskId];
        self.backgroundTaskId = UIBackgroundTaskInvalid;
    }

}

- (void)cancel
{
    @synchronized (self) {
        if (self.thread)
        {
            [self performSelector:@selector(cancelInternalAndStop) onThread:self.thread withObject:nil waitUntilDone:NO];
        }
        else
        {
            [self cancelInternal];
        }
    }
}

- (void)cancelInternalAndStop
{
    if (self.isFinished)
        return;
    
    [self cancelInternal];
    CFRunLoopStop(CFRunLoopGetCurrent());
}

- (void)cancelInternal
{
    if (self.isFinished) return;
    [super cancel];
    if (self.cancelBlock) self.cancelBlock();

    if (self.connection)
    {
        [self.connection cancel];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:XYDownloadStopNotification object:self];
        });

        // As we cancelled the connection, its callback won't be called and thus won't
        // maintain the isFinished and isExecuting flags.
        if (self.isExecuting) self.executing = NO;
        if (!self.isFinished) self.finished = YES;
    }

    [self reset];
}

- (void)done
{
    self.finished = YES;
    self.executing = NO;
    [self reset];
}

- (void)reset
{
    self.cancelBlock = nil;
    self.completedBlock = nil;
    self.progressBlock = nil;
    self.connection = nil;
    self.thread = nil;
}

- (void)setFinished:(BOOL)finished
{
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)setExecuting:(BOOL)executing
{
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (BOOL)isConcurrent
{
    return YES;
}

- (XYDownloaderOperation *)download:(NSString *)remoteURL
                                 to:(NSString*)localPath
                             params:(NSDictionary *)params
{
    self.remoteURL = remoteURL;
    self.localPath = localPath;
    self.params = [params copy];
}

#pragma mark NSURLConnection (delegate)
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    //'304 Not Modified' is an exceptional one
    if (![response respondsToSelector:@selector(statusCode)] || ([((NSHTTPURLResponse *)response) statusCode] < 400 && [((NSHTTPURLResponse *)response) statusCode] != 304))
    {
        NSInteger expected = response.expectedContentLength > 0 ? (NSInteger)response.expectedContentLength : 0;
        self.expectedSize = expected;
        if (self.progressBlock)
        {
            self.progressBlock(0, expected);
        }

        self.response = response;
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:XYDownloadReceiveResponseNotification object:self];
        });
    }
    else
    {
        NSUInteger code = [((NSHTTPURLResponse *)response) statusCode];
        
        // 如果是304 意味着没有改变,我们只需要从cache中读取
        if (code == 304)
        {
            [self cancelInternal];
        }
        else
        {
            [self.connection cancel];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:XYDownloadStopNotification object:self];
        });

        if (self.completedBlock)
        {
            self.completedBlock(nil, nil, [NSError errorWithDomain:NSURLErrorDomain code:[((NSHTTPURLResponse *)response) statusCode] userInfo:nil], YES);
        }
        CFRunLoopStop(CFRunLoopGetCurrent());
        [self done];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{

    if ((self.options & XYDownloaderProgressiveDownload) && self.expectedSize > 0 && self.completedBlock)
    {
        // Get the total bytes downloaded
        const NSInteger totalSize = data.length;
    }

    if (self.progressBlock)
    {
        self.progressBlock(data.length, self.expectedSize);
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)aConnection
{
    XYDownloaderCompletedBlock completionBlock = self.completedBlock;
    @synchronized(self) {
        CFRunLoopStop(CFRunLoopGetCurrent());
        self.thread = nil;
        self.connection = nil;
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:XYDownloadStopNotification object:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:XYDownloadFinishNotification object:self];
        });
    }
    
    if (completionBlock)
    {
        completionBlock(nil, nil, nil, YES);
    }
    self.completionBlock = nil;
    [self done];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    @synchronized(self) {
        CFRunLoopStop(CFRunLoopGetCurrent());
        self.thread = nil;
        self.connection = nil;
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:XYDownloadStopNotification object:self];
        });
    }

    if (self.completedBlock)
    {
        self.completedBlock(nil, nil, error, YES);
    }
    self.completionBlock = nil;
    [self done];
}


- (BOOL)shouldContinueWhenAppEntersBackground
{
    return self.options & XYDownloaderContinueInBackground;
}

- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection __unused *)connection
{
    return self.shouldUseCredentialStorage;
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
    {
        if (!(self.options & XYDownloaderAllowInvalidSSLCertificates) &&
            [challenge.sender respondsToSelector:@selector(performDefaultHandlingForAuthenticationChallenge:)])
        {
            [challenge.sender performDefaultHandlingForAuthenticationChallenge:challenge];
        }
        else
        {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
        }
    }
    else
    {
        if ([challenge previousFailureCount] == 0)
        {
            if (self.credential)
            {
                [[challenge sender] useCredential:self.credential forAuthenticationChallenge:challenge];
            }
            else
            {
                [[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
            }
        }
        else
        {
            [[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
        }
    }
}

#pragma mark - getter / setter
- (void)setFilePath:(NSString *)filePath
{
    if (filePath.length < 1)
        return;
    
    NSRange range = [filePath rangeOfString:@"/" options:NSBackwardsSearch];
    if (range.location == NSNotFound)
        return;
    
    NSString *path = [filePath substringToIndex:range.location];
    
    if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:path] )
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:path
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:NULL];
    }

}
@end
