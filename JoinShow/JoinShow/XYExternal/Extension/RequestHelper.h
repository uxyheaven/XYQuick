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

@interface RequestHelper : MKNetworkEngine

typedef enum {
    requestHelper_get = 1,
    requestHelper_post,
    requestHelper_put,
    requestHelper_del,
} HTTPMethod;
typedef MKNetworkOperation HttpRequest;
@property (nonatomic, assign) BOOL freezable;
@property (nonatomic, assign) BOOL forceReload;
//
+(id) defaultSettings;

-(HttpRequest *) get:(NSString *)path;
-(HttpRequest *) get:(NSString *)path
              params:(id)anObject;

-(HttpRequest *) post:(NSString *)path
               params:(id)anObject;


-(HttpRequest *) post:(NSString *)path
               params:(id)anObject
                files:(NSMutableDictionary *)files;


-(HttpRequest *) request:(NSString *)path
                  params:(id)anObject
                   files:(NSMutableDictionary *)files
                  method:(HTTPMethod)httpMethod;
// cancel
-(void) cancelRequestWithString:(NSString*)string;

//////////////////        Image        ////////////////////
#pragma mark- Image
// 设置图片缓存引擎
#define XY_initWebImageCache [NetworkEngine webImageSetup];
+(void) webImageSetup;

-(id) submit:(HttpRequest *)op;
@end


#pragma mark - download
@interface DownloadHelper : MKNetworkEngine
+(id) defaultSettings;

// @property (nonatomic, copy) NSString *tempFilePath;
-(MKNetworkOperation *) downLoad:(NSString *)remoteURL
                              to:(NSString*)filePath
                          params:(id)anObject
                     rewriteFile:(BOOL)isRewrite
                breakpointResume:(BOOL)paramResume
                        progress:(void(^)(double progress))blockP
                         succeed:(void (^)(MKNetworkOperation *operation))blockS
                          failed:(void (^)(MKNetworkOperation *errorOp, NSError* err))blockF;

-(void) cancelAllDownloads;
-(void) cancelDownloadWithString:(NSString *)string;
-(NSArray *) allDownloads;
-(MKNetworkOperation *) getADownloadWithString:(NSString *)string;
-(void) clearAllTempDownload;

-(id) submit:(MKNetworkOperation *)op;
// 子类需要重新写, 暂时废弃
//+(NSString *) generateAccessTokenWithObject:(id)anObject;

#pragma mark- todo ,数量控制
// 定义队列最大并发数量, 默认为wifi下 6, 2g/3g下 2
//@property (nonatomic, assign) int maxOperationCount;
@end

//////////////////        MKNetworkOperation (XY)        ////////////////////
#pragma mark -  MKNetworkOperation (XY)
@interface MKNetworkOperation (XY)

// 属性列表
@property (nonatomic, copy) NSString *toFile;
@property (nonatomic, copy) NSString *tempFile;

-(id) succeed:(void (^)(HttpRequest *op))blockS
       failed:(void (^)(HttpRequest *op, NSError* err))blockF;
//-(void) submit;
@end
