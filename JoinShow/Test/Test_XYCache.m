//
//  Test_Cache.m
//  JoinShow
//
//  Created by Heaven on 15/12/11.
//  Copyright © 2015年 Heaven. All rights reserved.
//

#import "XYQuick.h"

#pragma mark -
#if (1 == __XY_DEBUG_UNITTESTING__)
// ----------------------------------
// Unit test
// ----------------------------------

UXY_TEST_CASE( Core, XYCache )
{
    //	TODO( "test case" )
}

UXY_DESCRIBE( test1 )
{
    [[XYFileCache sharedInstance] setObject:@"aaaaaa" forKey:@"aa"];
    NSData *data = [[XYFileCache sharedInstance] objectForKey:@"aa"];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    UXY_EXPECTED( [str isEqualToString:@"aaaaaa"] );
}


UXY_TEST_CASE_END
#endif