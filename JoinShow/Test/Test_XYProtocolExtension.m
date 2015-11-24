//
//  Test_XYJSON.m
//  JoinShow
//
//  Created by Heaven on 15/11/24.
//  Copyright © 2015年 Heaven. All rights reserved.
//

#import "XYQuick.h"

#pragma mark -
// ----------------------------------
// Unit test
// ----------------------------------
#if (1 == __XY_DEBUG_UNITTESTING__)

// Protocol

@protocol ProtocolExtension_Protocrl1 <NSObject>

@optional
- (NSString *)method1;

@required
- (NSString *)method2;

@end

// Protocol Extension

@uxy_defProtocolMethod(ProtocolExtension_Protocrl1)

- (NSString *)method1
{
    return @"1";
}

- (NSString *)method2
{
    return @"2";
}

@end

// Concrete Class

@interface ProtocolExtension_Class : NSObject <ProtocolExtension_Protocrl1>
@end

@implementation ProtocolExtension_Class

- (NSString *)method2
{
    return @"a";
}

@end


UXY_TEST_CASE( Core, XYProtocolExtension )
{
}

UXY_DESCRIBE( test_1 )
{
    NSString *str1 = [[ProtocolExtension_Class alloc] method1];
    NSString *str2 = [[ProtocolExtension_Class alloc] method2];
    UXY_EXPECTED( [str1 isEqualToString:@"1"] );
    UXY_EXPECTED( [str2 isEqualToString:@"a"] );
}

UXY_TEST_CASE_END

#endif