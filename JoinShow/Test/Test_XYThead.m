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
#import "XYUnitTest.h"

UXY_TEST_CASE( Core, XYThead )
{
    //	TODO( "test case" )
}

UXY_DESCRIBE( test1 )
{
    __block int step = 1;
    dispatch_after( [XYGCD seconds:1], [XYGCD sharedInstance].backConcurrentQueue, ^{
        {
            step = 3;
        }
    });
    step = 2;
}

UXY_DESCRIBE( test2 )
{
    __block int step = 1;
    dispatch_async( [XYGCD sharedInstance].backConcurrentQueue, ^{
        {
            step = 3;
            dispatch_async( dispatch_get_main_queue(), ^{
                {
                    step = 4;
                }
            });
        }
    });
    step = 2;
}


UXY_TEST_CASE_END
#endif