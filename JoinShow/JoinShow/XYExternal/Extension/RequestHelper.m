//
//  XYNetWorkEngine.m
//  JoinShow
//
//  Created by Heaven on 13-9-7.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import "RequestHelper.h"
#import "YYJSONHelper.h"
#if (1 ==  __USED_MKNetworkKit__)

@interface RequestHelper()

@end

@implementation RequestHelper

+(id) defaultSettings{
    // 参考
    RequestHelper *eg = [[[RequestHelper alloc] initWithHostName:@"www.webxml.com.cn" customHeaderFields:@{@"x-client-identifier" : @"iOS"}] autorelease];
    
    eg.freezable = YES;
    eg.forceReload = YES;
    return eg;
}

// [super initWithHostName:@"www.apple.com" customHeaderFields:@{@"x-client-identifier" : @"iOS"}]
- (id)init
{
    if (self = [super init]) {
        _freezable = YES;
        _forceReload = YES;
    }
    return self;
}

- (void)dealloc
{
    NSLogDD
    [super dealloc];
}


-(HttpRequest *) get:(NSString *)path{
    return [self get:path params:nil];
}
-(HttpRequest *) get:(NSString *)path
              params:(id)anObject{
    return [self request:path params:anObject method:requestHelper_get];
}

-(HttpRequest *) post:(NSString *)path
               params:(id)anObject{
    return [self request:path params:anObject method:requestHelper_post];
}

-(HttpRequest *) request:(NSString *)path
                  params:(id)anObject
                  method:(HTTPMethod)httpMethod{
    
    NSString *strHttpMethod = nil;
    
    if (httpMethod == requestHelper_get) {
        strHttpMethod = @"GET";
    }else if (httpMethod == requestHelper_post){
        strHttpMethod = @"POST";
    }else if (httpMethod == requestHelper_put){
        strHttpMethod = @"PUT";
    }else if (httpMethod == requestHelper_del){
        strHttpMethod = @"DELETE";
    }
    if (strHttpMethod == nil) {
        return nil;
    }
    
    NSDictionary *dic = nil;
    if (anObject) {
        if ([anObject isKindOfClass:[NSDictionary class]]) {
            dic = anObject;
        }else{
            dic = [anObject YYJSONDictionary];
        }
    }

    MKNetworkOperation *tempOp = [self operationWithPath:path params:dic httpMethod:strHttpMethod];
    return tempOp;
}

-(void) cancelRequestWithString:(NSString*)string{
    [RequestHelper cancelOperationsContainingURLString:string];
}


#pragma mark- Image
+(void) webImageSetup{
    [UIImageView setDefaultEngine:[[[MKNetworkEngine alloc] init] autorelease]];
}

+(NSString *) generateAccessTokenWithObject:(id)anObject{
    NSDictionary *dic = anObject;
    NSString *link = [dic objectForKey:@"link"];
    NSString *uuid = [XYCommon UUID];
    NSString *str1 = [NSString stringWithFormat:@"%@+%@", link, uuid];
    // const char *str2 = [str1 cStringUsingEncoding:NSUTF8StringEncoding];
    return str1;
}

-(id) submit:(MKNetworkOperation *)op{
    NSString *str = op.toFile;
    if (str == nil) {
        // 非下载请求
        if ([op.HTTPMethod isEqualToString:@"GET"]) {
            [self enqueueOperation:op forceReload:self.forceReload];
        }else{
            [self enqueueOperation:op forceReload:NO];
        }
    }
    return self;
}
@end



#pragma mark - download
@interface DownloadHelper()
@property (nonatomic, retain) NSMutableArray *downloadArray;

@end
@implementation DownloadHelper
+(id) defaultSettings{
    // 参考
    DownloadHelper *eg = [[[DownloadHelper alloc] initWithHostName:@"testbed1.mknetworkkit.com" customHeaderFields:@{@"x-client-identifier" : @"iOS"}] autorelease];
    return eg;
}
- (void)dealloc
{
    NSLogDD
    self.downloadArray = nil;
    [super dealloc];
}
-(MKNetworkOperation *) downLoad:(NSString *)remoteURL
                              to:(NSString*)filePath
                          params:(id)anObject
                     rewriteFile:(BOOL)isRewrite
                breakpointResume:(BOOL)paramResume
                        progress:(void(^)(double progress))blockP
                         succeed:(void (^)(MKNetworkOperation *operation))blockS
                          failed:(void (^)(MKNetworkOperation *errorOp, NSError* err))blockF{
    
    // 获得临时文件的路径
    NSString *tempDoucment = NSTemporaryDirectory();
    NSString *tempFilePath = [tempDoucment stringByAppendingPathComponent:@"tempdownload"];
    if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:tempFilePath isDirectory:NULL] )
    {
        BOOL ret = [[NSFileManager defaultManager] createDirectoryAtPath:tempFilePath
                                             withIntermediateDirectories:YES
                                                              attributes:nil
                                                                   error:nil];
        if ( NO == ret ) {
            NSLogD(@"%s, create %@ failed", __PRETTY_FUNCTION__, tempFilePath);
            return nil;
        }
    }
    
    NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@"/"];
    NSRange lastCharRange = [filePath rangeOfCharacterFromSet:charSet options:NSBackwardsSearch];
    tempFilePath = [NSString stringWithFormat:@"%@/%@.temp", tempFilePath, [filePath substringFromIndex:lastCharRange.location + 1]];
    
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
        NSDictionary *dic = [anObject YYJSONDictionary];
        MKNetworkOperation *op = [self operationWithURLString:remoteURL params:dic];
        [op addDownloadStream:[NSOutputStream outputStreamToFileAtPath:tempFilePath append:YES]];
        [op addHeaders:newHeadersDict];
        
        
        op.toFile = filePath;
        
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
          //  [self enqueueOperation:op];
         //   [self.downloadArray addObject:op];
            
            [op onDownloadProgressChanged:^(double progress) {
                if (blockP) blockP(progress);
            }];
            
            [op addCompletionHandler:^(MKNetworkOperation *operation) {
                NSFileManager *fileManager = [NSFileManager defaultManager];
                NSError *error = nil;
                
                NSString *filePath = op.toFile;
                
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
        
        return op;
    }
    
    return nil;
}


-(void) cancelDownloadWithString:(NSString *)string
{
    MKNetworkOperation *op = [self getADownloadWithString:string];
    if (op) {
        [op cancel];
        [self.downloadArray removeObject:op];
    }
}

-(void) cancelAllDownloads
{
    for (MKNetworkOperation *tempOP in self.downloadArray) {
        [tempOP cancel];
    }
    [self.downloadArray removeAllObjects];
}
-(void) clearAllTempDownload{
    NSString *tempDoucment = NSTemporaryDirectory();
    NSString *tempFilePath = [tempDoucment stringByAppendingPathComponent:@"tempdownload"];
    [[NSFileManager defaultManager] removeItemAtPath:tempFilePath error:nil];
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
-(id) submit:(MKNetworkOperation *)op{
    NSString *str = op.toFile;
    if (str) {
        // 下载请求
        [self enqueueOperation:op];
        if (self.downloadArray == nil) {
            self.downloadArray = [NSMutableArray arrayWithCapacity:8];
        }
        [self.downloadArray addObject:op];
    }
    return self;
}
#pragma mark -
#pragma mark KVO for network Queue

@end

#pragma mark -  MKNetworkOperation (XY)

#undef	MKNetworkOperation_XY_toFile
#define MKNetworkOperation_XY_toFile	"MKOP.toFile"
#undef	MKNetworkOperation_XY_tempFile
#define MKNetworkOperation_XY_tempFile	"MKOP.tempFile"
@implementation MKNetworkOperation (XY)

@dynamic toFile;

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

// if forceReload == YES, 先读缓存,然后发请求,blockS响应2次, 只支持GET
-(id) submitInQueue:(MKNetworkEngine *)requests{
    NSString *str = self.toFile;
    if (str && [requests isKindOfClass:[DownloadHelper class]]) {
        // 下载请求
        [requests enqueueOperation:self];
        [((DownloadHelper *)requests).downloadArray addObject:self];
    }else if (str == nil)
    {
        // 非下载请求
        [requests enqueueOperation:self forceReload:NO];
    }
    
    return self;
}

-(id) uploadFiles:(NSDictionary *)name_path{
    if (name_path) {
        [name_path enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [self addFile:obj forKey:key];
        }];
    }
    
    return self;
}
-(id) succeed:(void (^)(HttpRequest *op))blockS
       failed:(void (^)(HttpRequest *op, NSError* err))blockF{
    [self addCompletionHandler:blockS errorHandler:blockF];
    return self;
}
@end

/*
 MKNetworkEngine是一个假单例的类，负责管理你的app的网络队列。因此，简单的请求时，你应该直接使用MKNetworkEngine的方法。在更为复杂的定制中，你应该集成并子类化它。每一个MKNetworkEngine的子类都有他自己的Reachability对象来通知服务器的连通情况。你应该考虑为你的每一个特别的REST服务器请求子类化MKNetworkEngine。因为是假单例模式，每一个单独的子类的请求，都会通过仅有的队列发送。
 
 
 重写 MKNetworkEngin的一些方法时,需要调用 -(void) registerOperationSubclass:(Class) aClass;
 
 改变提交的数据类型需要设置postDataEncoding
 */

#endif
