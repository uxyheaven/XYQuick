//
//  StatisticsManager.m
//  JoinShow
//
//  Created by Heaven on 13-8-7.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import "UmengManager.h"
#ifdef UMENG
@implementation UmengManager

//DEF_SINGLETON(UmengManager)

+ (void)startWithAppkey{
    [MobClick startWithAppkey:Umeng_appkey];
}

+ (void)beginLogPageView:(NSString *)str{
    [MobClick beginLogPageView:str];
}

+ (void)endLogPageView:(NSString *)str{
    [MobClick endLogPageView:str];
}

+ (void)event:(NSString *)eventID attributes:(NSDictionary *)dic{
    [MobClick event:eventID attributes:dic];
}

+ (void)checkUpdate{
    [MobClick checkUpdate];
}

+ (NSString *)getConfigParams:(NSString *)key{
    return [MobClick getConfigParams:key];
}

+ (void)updateOnlineConfig{
    [MobClick updateOnlineConfig];
}

@end
#endif