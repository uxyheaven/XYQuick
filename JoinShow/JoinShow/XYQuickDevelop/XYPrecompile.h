//
//  XYPrecompile.h
//  TWP_SkyBookShelf
//
//  Created by Heaven on 13-5-29.
//
//

#ifndef TWP_SkyBookShelf_XYPrecompile_h
#define TWP_SkyBookShelf_XYPrecompile_h

// 打包
#define __XYQuick_Framework__       (0)

// 调试
#define __XYDEBUG__                 (1)
// 点击区域红色边框
#define __XYDEBUG__showborder__     (1)
// 性能测试
#define __XY_PERFORMANCE__          (1)

#define __XY_DEVELOPMENT__          (1)


// XYUISIGNAL
#define __XYUISIGNAL_USED_CALLPATH__         (1)


#define __TimeOut__ON__             (0)
#define __TimeOut__date__           @"2015-3-10 00:00:00"

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <mach/mach.h>
#import <mach/mach_host.h>
#import <execinfo.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CoreMotion/CoreMotion.h>
#import <Social/Social.h>
#import <AVFoundation/AVFoundation.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <AVFoundation/AVSpeechSynthesis.h>

#import "XYCommonDefine.h"
#import "XYDebug.h"

#pragma mark -

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000

#define UILineBreakMode					NSLineBreakMode
#define UILineBreakModeWordWrap			NSLineBreakByWordWrapping
#define UILineBreakModeCharacterWrap	NSLineBreakByCharWrapping
#define UILineBreakModeClip				NSLineBreakByClipping
#define UILineBreakModeHeadTruncation	NSLineBreakByTruncatingHead
#define UILineBreakModeTailTruncation	NSLineBreakByTruncatingTail
#define UILineBreakModeMiddleTruncation	NSLineBreakByTruncatingMiddle

#define UITextAlignmentLeft				NSTextAlignmentLeft
#define UITextAlignmentCenter			NSTextAlignmentCenter
#define UITextAlignmentRight			NSTextAlignmentRight
#define	UITextAlignment					NSTextAlignment

#endif	// #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000

#endif
