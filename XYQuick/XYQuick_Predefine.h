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

#ifndef __XYQUICK_PREDEFINE_H__
#define __XYQUICK_PREDEFINE_H__

// ----------------------------------
// on-off
// ----------------------------------
#define __XYQuick_Framework__       (0) // 打包,暂时无用


#ifdef CUSTOM_XYPREDEFINE
    #import "XYQuick_Custom_Predefine.h"   // 预编译
#else
#ifdef DEBUG
    #define __XY_DEBUG__                             (1)     // 调试
    #define __XY_PERFORMANCE__                       (1)     // 性能测试
    #define __XY_DEBUG_SHOWBORDER__                  (1)     // 点击区域红色边框
    #define __XY_DEBUG_UNITTESTING__                 (1)     // 单元测试
    #define __XY_DEBUG_DEBUGLABEL__                  (1)     // 调试的label
#else
    #define __XY_DEBUG__                             (0)
    #define __XY_PERFORMANCE__                       (0)
    #define __XY_DEBUG_SHOWBORDER__                  (0)
    #define __XY_DEBUG_UNITTESTING__                 (0)
    #define __XY_DEBUG_DEBUGLABEL__                  (0)     // 调试的label
#endif
#endif

// ----------------------------------
// header.h
// ----------------------------------

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVSpeechSynthesis.h>
#import <CoreMotion/CoreMotion.h>
#import <Social/Social.h>
#import <SystemConfiguration/SystemConfiguration.h>

#import <objc/runtime.h>
#import <objc/message.h>
#import <mach/mach.h>
#import <mach/mach_host.h>
#import <execinfo.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <ifaddrs.h>
#import <arpa/inet.h>

// ----------------------------------
// Common use macros
// ----------------------------------

#ifndef	IN
#define IN
#endif

#ifndef	OUT
#define OUT
#endif

#ifndef	INOUT
#define INOUT
#endif

#ifndef	UNUSED
#define	UNUSED( __x )		{ id __unused_var__ __attribute__((unused)) = (id)(__x); }
#endif

#ifndef	ALIAS
#define	ALIAS( __a, __b )	__typeof__(__a) __b = __a;
#endif

#ifndef	DEPRECATED
#define	DEPRECATED			__attribute__((deprecated))
#endif

#ifndef	TODO
#define TODO( X )			_Pragma(uxy_macro_cstr(message("✖✖✖✖✖✖✖✖✖✖✖✖✖✖✖✖✖✖ TODO: " X)))
#endif

#ifndef	EXTERN_C
#if defined(__cplusplus)
#define EXTERN_C			extern "C"
#else
#define EXTERN_C			extern
#endif
#endif

#ifndef	INLINE
#define	INLINE				__inline__ __attribute__((always_inline))
#endif

// ----------------------------------
// Code block
// ----------------------------------
// 单例模式
static id sharedInstance;
#define uxy_as_singleton    \
        + (instancetype)sharedInstance; \
        + (void)purgeSharedInstance;

#define uxy_def_singleton \
        static dispatch_once_t __singletonToken;     \
        static id __singleton__;    \
        + (instancetype)sharedInstance \
        { \
            dispatch_once( &__singletonToken, ^{ __singleton__ = [[self alloc] init]; } ); \
            return __singleton__; \
        }   \
        + (void)purgeSharedInstance \
        {   \
            __singleton__ = nil;    \
            __singletonToken = 0; \
        }


// 执行一次
#define uxy_once_begin( __name ) \
        static dispatch_once_t once_##__name; \
        dispatch_once( &once_##__name , ^{

#define uxy_once_end		});

// ----------------------------------
// Category
// ----------------------------------
//使用示例:
//UIColor+YYAdd.m
/*
 #import "UIColor+YYAdd.h"
 DUMMY_CLASS(UIColor+YYAdd)
 
 @implementation UIColor(YYAdd)
 ...
 @end
 */

#ifndef DUMMY_CLASS
#define DUMMY_CLASS(UNIQUE_NAME) \
        @interface DUMMY_CLASS_##UNIQUE_NAME : NSObject @end \
        @implementation DUMMY_CLASS_##UNIQUE_NAME @end
#endif
// ----------------------------------
// Version
// ----------------------------------
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
#endif

// ----------------------------------
// Meta macro
// ----------------------------------

#import "XYMetamacros.h"

#ifndef uxy_cstr
// 宏定义字符串 to char, NSString
#define uxy_macro_cstr( A )                 __uxy_macro_cstr_( A )
#define __uxy_macro_cstr_( A )              #A

#define uxy_macro_string( A )               __uxy_macro_string_( A )
#define __uxy_macro_string_( A )            @#A

// 定义静态常量字符串
#define uxy_staticConstString(__string)               static const char * __string = #__string;

#endif

// ----------------------------------
// ...
// ----------------------------------

#endif








