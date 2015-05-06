//
//  XYSystemInfo.h
//  JoinShow
//
//  Created by Heaven on 13-9-23.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//
//  Copy from Samurai Framework

// 系统信息
#import <Foundation/Foundation.h>
#import "XYPredefine.h"

#undef Screen_WIDTH
#define Screen_WIDTH   [[UIScreen mainScreen] bounds].size.width
#undef Screen_HEIGHT
#define Screen_HEIGHT  [[UIScreen mainScreen] bounds].size.height

#pragma mark -

#define IOS9_OR_LATER		[[XYSystemInfo sharedInstance] isOsVersionOrLater:@"9.0"]
#define IOS8_OR_LATER		[[XYSystemInfo sharedInstance] isOsVersionOrLater:@"8.0"]
#define IOS7_OR_LATER		[[XYSystemInfo sharedInstance] isOsVersionOrLater:@"7.0"]
#define IOS6_OR_LATER		[[XYSystemInfo sharedInstance] isOsVersionOrLater:@"6.0"]
#define IOS5_OR_LATER		[[XYSystemInfo sharedInstance] isOsVersionOrLater:@"5.0"]
#define IOS4_OR_LATER		[[XYSystemInfo sharedInstance] isOsVersionOrLater:@"4.0"]

#define IOS9_OR_EARLIER		[[XYSystemInfo sharedInstance] isOsVersionOrEarlier:@"9.0"]
#define IOS8_OR_EARLIER		[[XYSystemInfo sharedInstance] isOsVersionOrEarlier:@"8.0"]
#define IOS7_OR_EARLIER		[[XYSystemInfo sharedInstance] isOsVersionOrEarlier:@"7.0"]
#define IOS6_OR_EARLIER		[[XYSystemInfo sharedInstance] isOsVersionOrEarlier:@"6.0"]
#define IOS5_OR_EARLIER		[[XYSystemInfo sharedInstance] isOsVersionOrEarlier:@"5.0"]
#define IOS4_OR_EARLIER		[[XYSystemInfo sharedInstance] isOsVersionOrEarlier:@"4.0"]




@interface XYSystemInfo : NSObject __AS_SINGLETON

#pragma mark- app,设备相关
- (NSString *)osVersion;
- (NSString *)bundleVersion;
- (NSString *)bundleShortVersion;
- (NSString *)bundleIdentifier;
- (NSString *)urlSchema;
- (NSString *)urlSchemaWithName:(NSString *)name;
- (NSString *)deviceModel;
- (NSString *)deviceUUID;

// 返回本机ip地址
- (NSString *)localHost;

// 是否越狱
- (BOOL)isJailBroken		NS_AVAILABLE_IOS(4_0);

// 在ip设备上运行
- (BOOL)runningOnPhone;
// 在ipad设备上运行
- (BOOL)runningOnPad;

- (BOOL)requiresPhoneOS;

#pragma mark- 屏幕相关
- (CGSize)screenSize;
- (BOOL)isScreenPhone;
- (BOOL)isScreen320x480;    // 这个是历史了
- (BOOL)isScreen640x960;    // ip4s
- (BOOL)isScreen640x1136;   // ip5 ip5s ip6放大模式
- (BOOL)isScreen750x1334;   // ip6
- (BOOL)isScreen1242x2208;  // ip6p
- (BOOL)isScreen1125x2001;  // ip6p放大模式

- (BOOL)isScreenPad;
- (BOOL)isScreen768x1024;
- (BOOL)isScreen1536x2048;

// 是否retina屏
- (BOOL)isRetina;

- (BOOL)isScreenSizeSmallerThan:(CGSize)size;
- (BOOL)isScreenSizeBiggerThan:(CGSize)size;
- (BOOL)isScreenSizeEqualTo:(CGSize)size;

#pragma mark- 版本判断相关
- (BOOL)isOsVersionOrEarlier:(NSString *)ver;
- (BOOL)isOsVersionOrLater:(NSString *)ver;
- (BOOL)isOsVersionEqualTo:(NSString *)ver;

#pragma mark- 启动相关
- (BOOL)isFirstRun;
- (BOOL)isFirstRunCurrentVersion;
- (void)setFirstRun;
- (void)setNotFirstRun;

- (BOOL)isFirstRunWithUser:(NSString *)user;
- (BOOL)isFirstRunCurrentVersionWithUser:(NSString *)user;
- (void)setFirstRunWithUser:(NSString *)user;
- (void)setNotFirstRunWithUser:(NSString *)user;

@end
