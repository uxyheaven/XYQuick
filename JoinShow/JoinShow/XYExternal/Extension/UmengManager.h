//
//  StatisticsManager.h
//  JoinShow
//
//  Created by Heaven on 13-8-7.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

// 友盟信息统计管理类
#import "XYExternalPrecompile.h"
#ifdef UMENG
#import "MobClick.h"

#define Umeng_appkey @"aaaaaaaaaaaaaaaaaaaaaaaa"

#define Umeng_startWithAppkey [UmengManager startWithAppkey];
#define Umeng_beginLogPageView(a) [UmengManager beginLogPageView:a];
#define Umeng_endLogPageView(a) [UmengManager endLogPageView:a];
#define Umeng_eventAttributes(a, b) [UmengManager event:a attributes:b];
#define Umeng_checkUpdate [UmengManager checkUpdate];
#define Umeng_updateOnlineConfig  [UmengManager updateOnlineConfig];

@interface UmengManager : NSObject

//AS_SINGLETON(UmengManager)

+ (void)startWithAppkey;
+ (void)beginLogPageView:(NSString *)str;
+ (void)endLogPageView:(NSString *)str;
+ (void)event:(NSString *)eventID attributes:(NSDictionary *)dic;
+ (void)checkUpdate;
+ (NSString *)getConfigParams:(NSString *)key;
+ (void)updateOnlineConfig;

@end
#endif
