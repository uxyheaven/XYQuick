//
//  XYNetWorkEngine.m
//  JoinShow
//
//  Created by Heaven on 13-9-7.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import "NetworkEngine.h"
#if (1 ==  __USED_MKNetworkKit__)

@interface NetworkEngine()

@property (nonatomic, retain) NSMutableArray *downloadArray;

@end

@implementation NetworkEngine

-(id) initWithDefaultSettings {
    if (self = [super initWithHostName:@"testbed1.mknetworkkit.com" customHeaderFields:@{@"x-client-identifier" : @"iOS"}]) {
        self.downloadArray = [NSMutableArray arrayWithCapacity:4];
    }
    return self;
}
+(id) defaultSettings{
    NetworkEngine *eg = [[[NetworkEngine alloc] initWithDefaultSettings] autorelease];
    return eg;
}
- (void)dealloc
{
    NSLogDD
    self.downloadArray = nil;
    [super dealloc];
}
-(MKNetworkOperation *) addGetRequestWithPath:(NSString *)path
                                       params:(NSMutableDictionary *)params
                                      succeed:(void (^)(MKNetworkOperation *operation))blockS
                                       failed:(void (^)(MKNetworkOperation *errorOp, NSError* err))blockF{
    
    MKNetworkOperation *op = [self operationWithPath:path params:params httpMethod:@"GET" ssl:NO];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        if (blockS) blockS(operation);
    }errorHandler:^(MKNetworkOperation *errorOp, NSError *err) {
        if (blockF) blockF(errorOp, err);
    }];
    // 先读缓存,然后发请求,blockS响应2次
    [self enqueueOperation:op forceReload:YES];
    
    return op;
}

-(MKNetworkOperation *) addPostRequestWithPath:(NSString *)path
                        params:(NSMutableDictionary *)params
                       succeed:(void (^)(MKNetworkOperation *operation))blockS
                        failed:(void (^)(MKNetworkOperation *errorOp, NSError* err))blockF{
    
    MKNetworkOperation *op = [self operationWithPath:path params:params httpMethod:@"POST"];
    // 冻结请求,  after connection is restored!
    // get 请求不能冻结
    [op setFreezable:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        if (blockS) blockS(operation);
    }errorHandler:^(MKNetworkOperation *errorOp, NSError *err) {
        if (blockF) blockF(errorOp, err);
    }];
    [self enqueueOperation:op];
    
    return op;
}
-(MKNetworkOperation *) addPostRequestWithPath:(NSString *)path
                                        params:(NSMutableDictionary *)params
                                         files:(NSMutableDictionary *)files
                                       succeed:(void (^)(MKNetworkOperation *operation))blockS
                                        failed:(void (^)(MKNetworkOperation *errorOp, NSError* err))blockF{
    MKNetworkOperation *op = [self operationWithPath:path params:params httpMethod:@"POST"];
    // 冻结请求,  after connection is restored!
    // get 请求不能冻结
    //  [op setFreezable:YES];
    if (files) {
        [files enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [op addFile:obj forKey:key];
        }];
    }
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        if (blockS) blockS(operation);
    }errorHandler:^(MKNetworkOperation *errorOp, NSError *err) {
        if (blockF) blockF(errorOp, err);
    }];
    [self enqueueOperation:op];
    
    return op;
}
-(void) cancelRequestWithStr:(NSString*)string{
    [NetworkEngine cancelOperationsContainingURLString:string];
}

#pragma mark - download
-(MKNetworkOperation *) downLoadForm:(NSString *)remoteURL toFile:(NSString *)filePath params:(NSMutableDictionary *)params rewriteFile:(BOOL)isRewrite;
{
    if (self.downloadArray == nil) {
        self.downloadArray = [NSMutableArray arrayWithCapacity:4];
    }
    // 获得临时文件的路径
    NSString  *tempDoucment = NSTemporaryDirectory();
    NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@"/"];
    NSRange lastCharRange = [filePath rangeOfCharacterFromSet:charSet options:NSBackwardsSearch];
    NSString *tempFilePath = [NSString stringWithFormat:@"%@%@.temp",
                              tempDoucment,
                              [filePath substringFromIndex:lastCharRange.location + 1]];
    
    // 获得临时文件的路径
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableDictionary *newHeadersDict = [[[NSMutableDictionary alloc] init] autorelease];
    // 如果是重新下载，就要删除之前下载过的文件
    if (isRewrite && [fileManager fileExistsAtPath:tempFilePath]) {
        NSError *error = nil;
        [fileManager removeItemAtPath:tempFilePath error:&error];
        if (error) {
            NSLogD(@"%@ file remove failed!\nError:%@", tempFilePath, error);
        }
    }else if(isRewrite && [fileManager fileExistsAtPath:filePath]){
        NSError *error = nil;
        [fileManager removeItemAtPath:filePath error:&error];
        if (error) {
            NSLogD(@"%@ file remove failed!\nError:%@", filePath, error);
        }
    }
    
    if ([fileManager fileExistsAtPath:filePath]) {
        return nil;
    }else {
        
        NSString *userAgentString = [NSString stringWithFormat:@"%@/%@",
                                     [[[NSBundle mainBundle] infoDictionary]
                                      objectForKey:(NSString *)kCFBundleNameKey],
                                     [[[NSBundle mainBundle] infoDictionary]
                                      objectForKey:(NSString *)kCFBundleVersionKey]];
        [newHeadersDict setObject:userAgentString forKey:@"User-Agent"];
        
        // 判断之前是否下载过 如果有下载重新构造Header
        if ([fileManager fileExistsAtPath:tempFilePath]) {
            NSError *error = nil;
            unsigned long long fileSize = [[fileManager attributesOfItemAtPath:tempFilePath
                                                                         error:&error]
                                           fileSize];
            if (error) {
                NSLogD(@"get %@ fileSize failed!\nError:%@", tempFilePath, error);
            }
            NSString *headerRange = [NSString stringWithFormat:@"bytes=%llu-", fileSize];
            [newHeadersDict setObject:headerRange forKey:@"Range"];
            
        }
        
        MKNetworkOperation *op = [self operationWithURLString:remoteURL params:params];
        [op addDownloadStream:[NSOutputStream outputStreamToFileAtPath:tempFilePath append:YES]];
        [op addHeaders:newHeadersDict];
        op.toFile = filePath;
        op.tempFile = tempFilePath;
        
        return op;
    }
}
-(void) addDownload:(MKNetworkOperation *)op
   breakpointResume:(BOOL)paramResume
           progress:(void(^)(double progress))blockP
            succeed:(void (^)(MKNetworkOperation *operation))blockS
             failed:(void (^)(MKNetworkOperation *errorOp, NSError* err))blockF
{
    // 如果已经存在下载文件 operation返回nil,否则把operation放入下载队列当中
    BOOL existDownload = NO;
    for (MKNetworkOperation *tempOP in self.downloadArray) {
        if ([tempOP.url isEqualToString:op.url]) {
            existDownload = YES;
            break;
        }
    }
    
    if (existDownload) {
        // [[self delegate] downloadManagerDownloadExist:self withURL:paramURL];
        // 下载任务已经存在
        NSLogD(@"download exist");
    } else if (op == nil) {
       // [[self delegate] downloadManagerDownloadDone:self withURL:paramURL];
        // 下载文件已经存在
        NSLogD(@"download done");
    } else {
        [self enqueueOperation:op];
        [self.downloadArray addObject:op];
        
        [op onDownloadProgressChanged:^(double progress) {
            if (blockP) blockP(progress);
        }];
        
        [op addCompletionHandler:^(MKNetworkOperation *operation) {
            NSFileManager *fileManager = [[NSFileManager alloc] init];
            NSError *error = nil;
            
            NSString *filePath = op.toFile;
            NSString *tempFilePath = op.tempFile;
            
            // 下载完成以后 先删除之前的文件 然后mv新的文件
            if ([fileManager fileExistsAtPath:filePath]) {
                [fileManager removeItemAtPath:filePath error:&error];
                if (error) {
                    NSLogD(@"remove %@ file failed!\nError:%@", filePath, error);
                    exit(-1);
                }
            }
            
            [fileManager moveItemAtPath:tempFilePath toPath:filePath error:&error];
            if (error) {
                NSLogD(@"move %@ file to %@ file is failed!\nError:%@", tempFilePath, filePath, error);
                exit(-1);
            }
            
            if (blockS) blockS(operation);
            [self.downloadArray removeObject:op];
            
        }errorHandler:^(MKNetworkOperation *errorOp, NSError *err) {
            if (blockF) blockF(errorOp, err);
        }];
    }
}


- (void)cancelDownloadWithString:(NSString *)string
{
    MKNetworkOperation *op = [self getADownloadWithString:string];
    if (op) {
        [op cancel];
        [self.downloadArray removeObject:op];
    }
}

- (void)cancelAllDownloads
{
    for (MKNetworkOperation *tempOP in self.downloadArray) {
        [tempOP cancel];
    }
    [self.downloadArray removeAllObjects];
}

- (NSArray *)allDownloads
{
    return self.downloadArray;
}
-(MKNetworkOperation *) getADownloadWithString:(NSString *)string{
    MKNetworkOperation *op = nil;
    for (MKNetworkOperation *tempOP in self.downloadArray) {
        if ([tempOP.url isEqualToString:string]) {
            op = tempOP;
            break;
        }
    }
    return op;
}
#pragma mark -
#pragma mark KVO for network Queue
/*
+ (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                         change:(NSDictionary *)change context:(void *)context
{
    if (object == _sharedNetworkQueue && [keyPath isEqualToString:@"operationCount"]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kMKNetworkEngineOperationCountChanged
                                                            object:[NSNumber numberWithInteger:(NSInteger)[_sharedNetworkQueue operationCount]]];
#if TARGET_OS_IPHONE
        [UIApplication sharedApplication].networkActivityIndicatorVisible =
        ([_sharedNetworkQueue.operations count] > 0);
#endif
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object
                               change:change context:context];
    }
}
*/
#pragma mark- Image
+(void) setWebImageEngine:(MKNetworkEngine *)engine{
    if (engine == nil) {
        [UIImageView setDefaultEngine:[[[MKNetworkEngine alloc] init] autorelease]];
    }else{
        [UIImageView setDefaultEngine:engine];
    }
}

+(NSString *) generateAccessTokenWithObject:(id)anObject{
    NSDictionary *dic = anObject;
    NSString *link = [dic objectForKey:@"link"];
    NSString *uuid = [XYCommon UUID];
    NSString *str1 = [NSString stringWithFormat:@"%@+%@", link, uuid];
   // const char *str2 = [str1 cStringUsingEncoding:NSUTF8StringEncoding];
    return str1;
}
@end

#pragma mark -  MKNetworkOperation (XY)

#undef	MKNetworkOperation_XY_toFile
#define MKNetworkOperation_XY_toFile	"MKOP.toFile"
#undef	MKNetworkOperation_XY_tempFile
#define MKNetworkOperation_XY_tempFile	"MKOP.tempFile"
@implementation MKNetworkOperation (XY)

@dynamic toFile;
@dynamic tempFile;

-(NSString *) toFile{
    return objc_getAssociatedObject(self, MKNetworkOperation_XY_toFile);
}
-(void) setToFile:(NSString *)toFile{
    objc_setAssociatedObject(self, MKNetworkOperation_XY_toFile, toFile, OBJC_ASSOCIATION_COPY);
}
-(NSString *) tempFile{
    return objc_getAssociatedObject(self, MKNetworkOperation_XY_tempFile);
}
-(void) setTempFile:(NSString *)tempFile{
    objc_setAssociatedObject(self, MKNetworkOperation_XY_tempFile, tempFile, OBJC_ASSOCIATION_COPY);
}
@end

#endif
