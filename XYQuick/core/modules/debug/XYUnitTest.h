//
//  XYUnitTest.h
//  JoinShow
//
//  Created by heaven on 15/4/21.
//  Copyright (c) 2015年 Heaven. All rights reserved.
//  copy from Samurai http://www.samurai-framework.com

#import "XYQuick_Predefine.h"

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

@interface XYUnitTest : NSObject uxy_as_singleton
@property (nonatomic, assign) NSUInteger failedCount;
@property (nonatomic, assign) NSUInteger succeedCount;

- (void)run;

- (void)writeLog:(NSString *)format, ...;
- (void)flushLog;

@end
