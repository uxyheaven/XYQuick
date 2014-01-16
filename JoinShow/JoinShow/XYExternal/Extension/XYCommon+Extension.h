//
//  XYFunction+Extension.h
//  JoinShow
//
//  Created by Heaven on 13-10-24.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import "XYExternalPrecompile.h"

@class MBProgressHUD;
@interface XYCommon (Extension)

#if (1 == __USED_FMDatabase__)
/** 
 * 更新表结构
 * api parameters 说明
 * tableName 表明, dbPath 数据库路径, anObject 实体对象
 */
+ (BOOL) updateTable:(NSString *)tableName dbPath:(NSString *)dbPath object:(id)anObject;
#endif


#if (1 == __USED_MBProgressHUD__)
/**
 * 显示MBProgressHUD指示器
 * api parameters 说明
 * aTitle 标题
 * aMsg 信息
 * aImg 图片, 为nil时,只显示标题
 * d 延时消失时间, 为0时需要主动隐藏
 * blockE 执行的代码快
 * blockF 结束时的代码块
 * 执行时改变hub需要调用Common_MainFun(aFun)
 */
#define HIDDENMBProgressHUD [XYCommon hiddenMBProgressHUD];
+(void) hiddenMBProgressHUD;

+(MBProgressHUD *) MBProgressHUD;

#define SHOWMBProgressHUD(aTitle, aMsg, aImg, aDimBG, aDelay) [XYCommon showMBProgressHUDTitle:aTitle msg:aMsg image:aImg dimBG:aDimBG delay:aDelay];
+(MBProgressHUD *) showMBProgressHUDTitle:(NSString *)aTitle msg:(NSString *)aMsg image:(UIImage *)aImg dimBG:(BOOL)dimBG delay:(float)d;

#define SHOWMBProgressHUDIndeterminate(aTitle, aMsg, aDimBG) [XYCommon showMBProgressHUDModeIndeterminateTitle:aTitle msg:aMsg dimBG:aDimBG];
+(MBProgressHUD *) showMBProgressHUDModeIndeterminateTitle:(NSString *)aTitle msg:(NSString *)aMsg dimBG:(BOOL)dimBG;

+(MBProgressHUD *) showMBProgressHUDTitle:(NSString *)aTitle msg:(NSString *)aMsg dimBG:(BOOL)dimBG executeBlock:(void(^)(MBProgressHUD *hud))blockE finishBlock:(void(^)(void))blockF;
#else
#define SHOWMBProgressHUD(aTitle, aMsg, aImg, aDimBG, aDelay) SHOWMSG(aTitle, aMsg, @"cancel");
#endif


#if (1 ==  __USED_ASIHTTPRequest__)
/**
 * 开启一个异步请求
 * api parameters 说明
 * url
 * blockS 成功的代码块
 * blockF 失败的代码块
 */
+(ASIHTTPRequest *) startAsynchronousRequestWithURLString:(NSString *)str
                                                  succeed:(void (^)(ASIHTTPRequest *request))blockS
                                                   failed:(void (^)(NSError *error))blockF;
#endif

#if (1 ==  __USED_ASIHTTPRequest__)
/**
 * 检查软件更新
 * api parameters 说明
 * appID 应用程序ID
 * aVersion 当前版本号 (nil 默认为CFBundleVersion)
 * link 应用程序链接,选择升级则跳转
 * blockstayStill 选择不升级的代码块
 * blockSame 版本相同的 的代码快 (如无网络也调用)
 * blocklocalIsOld 本地是旧的版本代码块
 */
// 有提示框弹出
+(void) checkUpdateInAppStore:(NSString *)appID curVersion:(NSString *)aVersion appURLString:(NSString *)strURL
                         same:(void(^)(void))blockSame
                    stayStill:(void(^)(void))blockStayStill;
// 需要自己处理弹出对话框
+(void) checkUpdateInAppStore:(NSString *)appID curVersion:(NSString *)aVersion
                         same:(void(^)(void))blockSame
                   localIsOld:(void(^)(NSString *appStoreVersion))blockLocalIsOld;
#endif

@end
