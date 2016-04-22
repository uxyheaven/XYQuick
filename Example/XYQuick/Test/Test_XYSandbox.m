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

UXY_TEST_CASE( Core, XYSandbox )
{
}

UXY_DESCRIBE( test_touchFile )
{
    NSString *path = [[XYSandbox docPath] stringByAppendingString:@"/aaa/bbb.json"];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    [XYSandbox touchFile:path];
    UXY_EXPECTED([[NSFileManager defaultManager] fileExistsAtPath:path] == YES );
}


UXY_TEST_CASE_END

#endif