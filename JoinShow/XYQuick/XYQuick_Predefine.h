//
//  XYPredefine.h
//
//  Created by Heaven on 13-5-29.
//
//

#ifndef JoinShow_XYPredefine_h
#define JoinShow_XYPredefine_h

#endif

// ----------------------------------
// on-off
// ----------------------------------
#define __XYQuick_Framework__       (0) // 打包,暂时无用

#ifdef DEBUG

    #define __XY_DEBUG__                             (1)     // 调试
    #define __XY_PERFORMANCE__                       (1)     // 性能测试
    #define __XY_UISIGNAL_CALLPATH__                 (1)     // XYUISIGNAL
    #define __XY_DEBUG_SHOWBORDER__                  (1)     // 点击区域红色边框
    #define __XY_DEBUG_UNITTESTING__                 (1)     // 单元测试
#else

    #define __XY_DEBUG__                             (0)
    #define __XY_PERFORMANCE__                       (0)
    #define __XY_UISIGNAL_CALLPATH__                 (0)
    #define __XY_DEBUG_SHOWBORDER__                  (0)
    #define __XY_DEBUG_UNITTESTING__                 (0)

#endif


#define __TimeOut__ON__             (0)
#define __TimeOut__date__           @"2015-3-10 00:00:00"


// ----------------------------------
// header.h
// ----------------------------------

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVSpeechSynthesis.h>
#import <CoreMotion/CoreMotion.h>
#import <Social/Social.h>

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
#define TODO( X )			_Pragma(macro_cstr(message("✖✖✖✖✖✖✖✖✖✖✖✖✖✖✖✖✖✖ TODO: " X)))
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
#undef	__AS_SINGLETON
#define __AS_SINGLETON    \
        + (instancetype)sharedInstance;
//+ (void) purgeSharedInstance;

#undef	DEF_SINGLETON
#define DEF_SINGLETON( __class ) \
        + (instancetype)sharedInstance \
        { \
            static dispatch_once_t once; \
            static id __singleton__; \
            dispatch_once( &once, ^{ __singleton__ = [[self alloc] init]; } ); \
            return __singleton__; \
        }

#undef	__DEF_SINGLETON
#define __DEF_SINGLETON \
        + (instancetype)sharedInstance \
        { \
            static dispatch_once_t once; \
            static id __singleton__; \
            dispatch_once( &once, ^{ __singleton__ = [[self alloc] init]; } ); \
            return __singleton__; \
        }

// 执行一次
#undef	XY_ONCE_BEGIN
#define XY_ONCE_BEGIN( __name ) \
        static dispatch_once_t once_##__name; \
        dispatch_once( &once_##__name , ^{

#undef	XY_ONCE_END
#define XY_ONCE_END		});

// ----------------------------------
// Meta macro
// ----------------------------------

#ifndef	macro_first

#define macro_first(...)									macro_first_( __VA_ARGS__, 0 )
#define macro_first_( A, ... )								A

#define macro_concat( A, B )								macro_concat_( A, B )
#define macro_concat_( A, B )								A##B

#define macro_count(...)									macro_at( 8, __VA_ARGS__, 8, 7, 6, 5, 4, 3, 2, 1 )
#define macro_more(...)										macro_at( 8, __VA_ARGS__, 1, 1, 1, 1, 1, 1, 1, 1 )

#define macro_at0(...)										macro_first(__VA_ARGS__)
#define macro_at1(_0, ...)									macro_first(__VA_ARGS__)
#define macro_at2(_0, _1, ...)								macro_first(__VA_ARGS__)
#define macro_at3(_0, _1, _2, ...)							macro_first(__VA_ARGS__)
#define macro_at4(_0, _1, _2, _3, ...)						macro_first(__VA_ARGS__)
#define macro_at5(_0, _1, _2, _3, _4 ...)					macro_first(__VA_ARGS__)
#define macro_at6(_0, _1, _2, _3, _4, _5 ...)				macro_first(__VA_ARGS__)
#define macro_at7(_0, _1, _2, _3, _4, _5, _6 ...)			macro_first(__VA_ARGS__)
#define macro_at8(_0, _1, _2, _3, _4, _5, _6, _7, ...)		macro_first(__VA_ARGS__)
#define macro_at(N, ...)									macro_concat(macro_at, N)( __VA_ARGS__ )

#define macro_join0( ... )
#define macro_join1( A )									A
#define macro_join2( A, B )									A##____##B
#define macro_join3( A, B, C )								A##____##B##____##C
#define macro_join4( A, B, C, D )							A##____##B##____##C##____##D
#define macro_join5( A, B, C, D, E )						A##____##B##____##C##____##D##____##E
#define macro_join6( A, B, C, D, E, F )						A##____##B##____##C##____##D##____##E##____##F
#define macro_join7( A, B, C, D, E, F, G )					A##____##B##____##C##____##D##____##E##____##F##____##G
#define macro_join8( A, B, C, D, E, F, G, H )				A##____##B##____##C##____##D##____##E##____##F##____##G##____##H
#define macro_join( ... )									macro_concat(macro_join, macro_count(__VA_ARGS__))(__VA_ARGS__)

#define macro_cstr( A )										macro_cstr_( A )
#define macro_cstr_( A )									#A

#define macro_string( A )									macro_string_( A )
#define macro_string_( A )									@(#A)

#endif

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














