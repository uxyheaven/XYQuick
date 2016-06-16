//
//  Test_XYJSON.m
//  JoinShow
//
//  Created by Heaven on 15/11/24.
//  Copyright © 2015年 Heaven. All rights reserved.
//

#import "XYQuick.h"

#pragma mark -
#if (1 == __XY_DEBUG_UNITTESTING__)
// ----------------------------------
// Unit test
// ----------------------------------

UXY_TEST_CASE(Core, XYSystem)
{
    //	TODO( "test case" )
}

UXY_DESCRIBE(test1)
{
    UXY_EXPECTED([[XYSystemInfo sharedInstance] deviceIPAdress].length > 0);
}

UXY_DESCRIBE(test2)
{
}


UXY_TEST_CASE_END
#endif