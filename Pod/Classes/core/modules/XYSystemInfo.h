//
//  __  __          ____           _          _
//  \ \/ / /\_/\   /___ \  _   _  (_)   ___  | | __
//   \  /  \_ _/  //  / / | | | | | |  / __| | |/ /
//   /  \   / \  / \_/ /  | |_| | | | | (__  |   <
//  /_/\_\  \_/  \___,_\   \__,_| |_|  \___| |_|\_\
//
//  Copyright (C) Heaven.
//
//	https://github.com/uxyheaven/XYQuick
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.
//
//  This file Copy from Samurai.

#import "XYQuick_Predefine.h"
#pragma mark -

#define XY_SCREEN_WIDTH   UIScreen.mainScreen.bounds.size.width
#define XY_SCREEN_HEIGHT  UIScreen.mainScreen.bounds.size.height

#pragma mark -

#define XY_IOS9_OR_LATER		[[XYSystemInfo sharedInstance] isOsVersionOrLater:@"9.0"]
#define XY_IOS8_OR_LATER		[[XYSystemInfo sharedInstance] isOsVersionOrLater:@"8.0"]
#define XY_IOS7_OR_LATER		[[XYSystemInfo sharedInstance] isOsVersionOrLater:@"7.0"]
#define XY_IOS6_OR_LATER		[[XYSystemInfo sharedInstance] isOsVersionOrLater:@"6.0"]
#define XY_IOS5_OR_LATER		[[XYSystemInfo sharedInstance] isOsVersionOrLater:@"5.0"]
#define XY_IOS4_OR_LATER		[[XYSystemInfo sharedInstance] isOsVersionOrLater:@"4.0"]

#define XY_IOS9_OR_EARLIER		[[XYSystemInfo sharedInstance] isOsVersionOrEarlier:@"9.0"]
#define XY_IOS8_OR_EARLIER		[[XYSystemInfo sharedInstance] isOsVersionOrEarlier:@"8.0"]
#define XY_IOS7_OR_EARLIER		[[XYSystemInfo sharedInstance] isOsVersionOrEarlier:@"7.0"]
#define XY_IOS6_OR_EARLIER		[[XYSystemInfo sharedInstance] isOsVersionOrEarlier:@"6.0"]
#define XY_IOS5_OR_EARLIER		[[XYSystemInfo sharedInstance] isOsVersionOrEarlier:@"5.0"]
#define XY_IOS4_OR_EARLIER		[[XYSystemInfo sharedInstance] isOsVersionOrEarlier:@"4.0"]


@interface XYSystemInfo : NSObject

+ (instancetype)sharedInstance;
+ (void)purgeSharedInstance;

#pragma mark- app,设备相关
- (NSString *)osVersion;
- (NSString *)bundleVersion;
- (NSString *)bundleShortVersion;
- (NSString *)bundleIdentifier;
- (NSString *)urlSchema;
- (NSString *)urlSchemaWithName:(NSString *)name;
- (NSString *)deviceModel;
- (NSString *)deviceUUID;

/// 返回本机 WiFi IP地址, 错误则返回@"error"
- (NSString *)wiFiHost;
/// 获取本机 移动网络 IP地址, 错误则返回@"error"
- (NSString *)cellHost;

/// 获取当前网络状态, @"无网络", @"2G", @"3G", @"4G", @"WIFI", @"error"
- (NSString *)netWorkState;
/// 是否越狱
- (BOOL)isJailBroken		NS_AVAILABLE_IOS(4_0);

/// 在iPhone设备上运行
- (BOOL)runningOnPhone;
// 在iPad设备上运行
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

#pragma mark- 第一次启动相关
- (BOOL)isFirstRunWithUser:(NSString *)user event:(NSString *)event;
- (BOOL)isFirstRunAtCurrentVersionWithUser:(NSString *)user event:(NSString *)event;
- (void)setFirstRun:(BOOL)isFirst user:(NSString *)user event:(NSString *)event;

@end
