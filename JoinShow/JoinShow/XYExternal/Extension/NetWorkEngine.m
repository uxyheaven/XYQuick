//
//  XYNetWorkEngine.m
//  JoinShow
//
//  Created by Heaven on 13-9-7.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import "NetworkEngine.h"
#if (1 ==  __USED_MKNetworkKit__)
@implementation NetworkEngine

-(id) initWithDefaultSettings {
    if (self = [super initWithHostName:@"testbed1.mknetworkkit.com" customHeaderFields:@{@"x-client-identifier" : @"iOS"}]) {
        
    }
    return self;
}
+(id) defaultSettings{
    NetworkEngine *eg = [[[NetworkEngine alloc] initWithDefaultSettings] autorelease];
    return eg;
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
  //  [op setFreezable:YES];
    
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
-(MKNetworkOperation *) downLoadForm:(NSString *)remoteURL toFile:(NSString *)filePath
{
    MKNetworkOperation *op = [self operationWithURLString:remoteURL];
    
    [op addDownloadStream:[NSOutputStream outputStreamToFileAtPath:filePath
                                                            append:YES]];
    return op;
}
-(void) addDownload:(MKNetworkOperation *)op
           progress:(void(^)(double progress))blockP
            succeed:(void (^)(MKNetworkOperation *operation))blockS
             failed:(void (^)(MKNetworkOperation *errorOp, NSError* err))blockF
{
    [op onDownloadProgressChanged:^(double progress) {
     if (blockP) blockP(progress);
    }];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        if (blockS) blockS(operation);
    }errorHandler:^(MKNetworkOperation *errorOp, NSError *err) {
        if (blockF) blockF(errorOp, err);
    }];
    [self enqueueOperation:op];
}

-(void) cancelOperationsContainingURLString:(NSString*)string{
     [NetworkEngine cancelOperationsContainingURLString:string];
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
#endif
