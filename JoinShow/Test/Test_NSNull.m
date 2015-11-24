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

UXY_TEST_CASE( Core, NSNull )
{
}

UXY_DESCRIBE( test_array )
{
    UXY_EXPECTED( ((NSArray *)[NSNull null])[1] == nil );
}

UXY_DESCRIBE( test_dictionary )
{
    UXY_EXPECTED( ((NSDictionary *)[NSNull null])[nil] == nil );
}

UXY_DESCRIBE( test_string )
{
    UXY_EXPECTED( [((NSString *)[NSNull null]) substringToIndex:2] == nil );
}

UXY_TEST_CASE_END

#endif