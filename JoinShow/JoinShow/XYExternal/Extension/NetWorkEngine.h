//
//  XYNetWorkEngine.h
//  JoinShow
//
//  Created by Heaven on 13-9-7.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

// 网络请求类, 基于MKNetworkEngine
// 建议从此类继承
/*
 MKNetworkEngine是一个假单例的类，负责管理你的app的网络队列。因此，简单的请求时，你应该直接使用MKNetworkEngine的方法。在更为复杂的定制中，你应该集成并子类化它。每一个MKNetworkEngine的子类都有他自己的Reachability对象来通知服务器的连通情况。你应该考虑为你的每一个特别的REST服务器请求子类化MKNetworkEngine。因为是假单例模式，每一个单独的子类的请求，都会通过仅有的队列发送。
 
 你可以在应用的delegate里面retain MKNetworkEngine的实例，就像CoreDatademanagedObjectContext类。当你使用MKNetworkKit的时候，你创建一个MKNetworkEngine的子类来从逻辑上分组你的网络请求。就是说，Yahoo相关的请求都在一个类中，Facebook相关的请求都在另一个类中。我们会看到3个不同的使用库的例子。
 
 重写 MKNetworkEngin的一些方法时,需要调用 -(void) registerOperationSubclass:(Class) aClass;
 
 改变提交的数据类型需要设置postDataEncoding
 */

#import "XYExternalPrecompile.h"

#if (1 ==  __USED_MKNetworkKit__)
#import "MKNetworkEngine.h"
@interface NetworkEngine : MKNetworkEngine
#else
@class MKNetworkOperation;
@class MKNetworkEngine;
@interface NetworkEngine : NSObject
#endif

// 建议子类重写 initWithDefaultSettings
+(id) defaultSettings;
-(id) initWithDefaultSettings;
 
// get
-(MKNetworkOperation *) addGetRequestWithPath:(NSString *)path
                       params:(NSMutableDictionary *)params
                      succeed:(void (^)(MKNetworkOperation *operation))blockS
                       failed:(void (^)(MKNetworkOperation *errorOp, NSError* err))blockF;
// post
#pragma mark -todo, post
-(MKNetworkOperation *) addPostRequestWithPath:(NSString *)path
                        params:(NSMutableDictionary *)params
                       succeed:(void (^)(MKNetworkOperation *operation))blockS
                        failed:(void (^)(MKNetworkOperation *errorOp, NSError* err))blockF;

// upload
// files @{fileName:filePath}
-(MKNetworkOperation *) addPostRequestWithPath:(NSString *)path
                                        params:(NSMutableDictionary *)params
                                         files:(NSMutableDictionary *)files
                                       succeed:(void (^)(MKNetworkOperation *operation))blockS
                                        failed:(void (^)(MKNetworkOperation *errorOp, NSError* err))blockF;

// download
-(MKNetworkOperation *) downLoadForm:(NSString *)remoteURL toFile:(NSString*)filePath;
-(void) addDownload:(MKNetworkOperation *)op
           progress:(void(^)(double progress))blockP
            succeed:(void (^)(MKNetworkOperation *operation))blockS
             failed:(void (^)(MKNetworkOperation *errorOp, NSError* err))blockF;

// cancel
-(void) cancelOperationsContainingURLString:(NSString*)string;

// 子类需要重新
+(NSString *) generateAccessTokenWithObject:(id)anObject;

#pragma mark- todo ,数量控制
// 定义队列最大并发数量, 默认为wifi下 6, 2g/3g下 2
//@property (nonatomic, assign) int maxOperationCount;

// 设置图片缓存引擎
#define XY_initWebImageCache [NetworkEngine setWebImageEngine:nil];
// if engine == nil, used MKNetworkEngine.
+(void) setWebImageEngine:(MKNetworkEngine *)engine;

@end
