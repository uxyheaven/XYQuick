//
//  Associated.m
//  JoinShow
//
//  Created by Heaven on 15/8/28.
//  Copyright (c) 2015年 Heaven. All rights reserved.
//

#import "Associated.h"

@implementation Associated

@end

@implementation Associated (test)

uxy_def_property_basicDataType(int, age)
uxy_def_property_basicDataType(NSTimeInterval, time)
uxy_def_property_copy(NSString *, name)
uxy_def_property_weak(NSDate *, date)
@end


// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if (1 == __XY_DEBUG_UNITTESTING__)

UXY_TEST_CASE( Test, Associated )
{
    //	TODO( "test case" )
    NSDate *_date;
}

UXY_DESCRIBE( before )
{
    _date = [NSDate date];
}

UXY_DESCRIBE( test1 )
{
    Associated *associated = [[Associated alloc] init];
    associated.age = 10;
    associated.time = 100.5f;
    associated.name = @"aaa";
    associated.date = _date;
    
    UXY_EXPECTED( associated.age == 10 );
    UXY_EXPECTED( associated.time == 100.5f );
    UXY_EXPECTED( [associated.name isEqualToString:@"aaa"] );
    UXY_EXPECTED( [associated.date isEqualToDate:_date] );
}

UXY_TEST_CASE_END

#endif