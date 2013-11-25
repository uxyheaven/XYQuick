//
//  XYNetWorkEngine.h
//  JoinShow
//
//  Created by Heaven on 13-9-7.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

// 网络请求类, 基于MKNetworkEngine
// 用时需要从此类继承,并重写defaultSettings方法



#import "XYExternalPrecompile.h"
#import "MKNetworkEngine.h"

//////////////////        MKNetworkOperation (XY)        ////////////////////
typedef MKNetworkOperation HttpRequest;

@interface RequestHelper : MKNetworkEngine

typedef enum {
    requestHelper_get = 1,
    requestHelper_post,
    requestHelper_put,
    requestHelper_del,
} HTTPMethod;

@property (nonatomic, assign) BOOL freezable;
@property (nonatomic, assign) BOOL forceReload;
//
+(id) defaultSettings;

-(HttpRequest *) get:(NSString *)path;
-(HttpRequest *) get:(NSString *)path
              params:(id)anObject;

-(HttpRequest *) post:(NSString *)path
               params:(id)anObject;

-(HttpRequest *) request:(NSString *)path
                  params:(id)anObject
                  method:(HTTPMethod)httpMethod;
// cancel
-(void) cancelRequestWithString:(NSString*)string;

-(id) submit:(HttpRequest *)op;

//////////////////        Image        ////////////////////
#pragma mark- Image
// 设置图片缓存引擎
#define XY_setupWebImageCache [RequestHelper webImageSetup];
+(void) webImageSetup;

// 子类需要重新写, 暂时废弃
//+(NSString *) generateAccessTokenWithObject:(id)anObject;
@end

#pragma mark -  MKNetworkOperation (XY)
@interface MKNetworkOperation (XY)

-(id) uploadFiles:(NSDictionary *)name_path;
-(id) succeed:(void (^)(HttpRequest *op))blockS
       failed:(void (^)(HttpRequest *op, NSError* err))blockF;
-(id) submitInQueue:(RequestHelper *)requests;
@end

#pragma mark - download
@class DownloadHelper;
@class Downloader;

@interface Downloader : HttpRequest

@property (nonatomic, copy) NSString *toFile;

-(id) submitInQueue:(DownloadHelper *)requests;
-(id) progress:(void(^)(double progress))blockP;
-(id) succeed:(void (^)(HttpRequest *op))blockS
       failed:(void (^)(HttpRequest *op, NSError* err))blockF;
@end

@interface DownloadHelper : MKNetworkEngine
+(id) defaultSettings;

// 下载前,请先执行此方法;
-(void) setup;

-(Downloader *) downLoad:(NSString *)remoteURL
                      to:(NSString*)filePath
                  params:(id)anObject
        breakpointResume:(BOOL)isResume;

-(void) cancelAllDownloads;
-(void) cancelDownloadWithString:(NSString *)string;
-(NSArray *) allDownloads;
-(Downloader *) getADownloadWithString:(NSString *)string;
-(void) clearAllTempFile;

-(id) submit:(Downloader *)op;

#pragma mark- todo ,数量控制
// 定义队列最大并发数量, 默认为wifi下 6, 2g/3g下 2
//@property (nonatomic, assign) int maxOperationCount;
@end











