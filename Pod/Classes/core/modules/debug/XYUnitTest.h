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
#import <Foundation/Foundation.h>
#pragma mark -

#define	UXY_TEST_CASE( __module, __name ) \
        @interface __TestCase__##__module##_##__name : XYTestCase \
        @end \
        @implementation __TestCase__##__module##_##__name

#define	UXY_TEST_CASE_END \
        @end

// 测试的方法
#define	UXY_DESCRIBE( ... ) \
        - (void) metamacro_concat( runTest_, __LINE__ )

#define UXY_REPEAT( __n ) \
        for ( int __i_##__LINE__ = 0; __i_##__LINE__ < __n; ++__i_##__LINE__ )

// 验证
#define UXY_EXPECTED( ... ) \
        if ( !(__VA_ARGS__) ) \
        { \
            [[XYUnitTest sharedInstance] writeLog:@"✖ EXPECTED( %s )", #__VA_ARGS__]; \
            [[XYUnitTest sharedInstance] flushLog]; \
            @throw [XYTestFailure expr:#__VA_ARGS__ file:__FILE__ line:__LINE__]; \
        }

#define UXY_TIMES( __n ) \
        /* [[XYUnitTest sharedInstance] writeLog:@"Loop %d times @ %@(#%d)", __n, [@(__FILE__) lastPathComponent], __LINE__]; */ \
        for ( int __i_##__LINE__ = 0; __i_##__LINE__ < __n; ++__i_##__LINE__ )

#define	UXY_TEST( __name, __block ) \
        [[XYUnitTest sharedInstance] writeLog:@"> %@", @(__name)]; \
        __block

#pragma mark -

#if (1 == __XY_DEBUG_UNITTESTING__)

@interface XYTestFailure : NSException

@property (nonatomic, copy) NSString *expr;
@property (nonatomic, copy) NSString *file;
@property (nonatomic, assign) NSInteger line;

+ (XYTestFailure *)expr:(const char *)expr file:(const char *)file line:(int)line;

@end

#pragma mark -

@interface XYTestCase : NSObject
@end

#pragma mark -

@interface XYUnitTest : NSObject

+ (instancetype)sharedInstance;
+ (void)purgeSharedInstance;

@property (nonatomic, assign) NSUInteger failedCount;
@property (nonatomic, assign) NSUInteger succeedCount;

- (void)run;

- (void)writeLog:(NSString *)format, ...;
- (void)flushLog;

@end

#endif
