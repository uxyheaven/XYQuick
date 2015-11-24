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
#import "XYUnitTest.h"

UXY_TEST_CASE( Core, JSON )
{
    //	TODO( "test case" )
}

UXY_DESCRIBE( test1 )
{
    NSString *str = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"json1.json" ofType:nil] encoding:NSUTF8StringEncoding error:nil];
    if (str.length == 0)
        return;
    
    NSDictionary *dic = [str uxy_JSONDictionary];
    UXY_EXPECTED( dic.count == 3 );
}

UXY_DESCRIBE( test2 )
{
    //  UXY_EXPECTED( 1 == 1 );
    //  UXY_EXPECTED( [@"123" isEqualToString:@"123"] );
}

UXY_DESCRIBE( test3 )
{
    // UXY_EXPECTED( [@"123" isEqualToString:@"123456"] );
}

UXY_TEST_CASE_END

#endif