//
//  XYApplicationWorkspace.m
//  JoinShow
//
//  Created by Heaven on 15/8/5.
//  Copyright (c) 2015年 Heaven. All rights reserved.
//

#import "XYApplicationWorkspace.h"
#import "XYQuick.h"

@implementation XYApplicationWorkspace

- (NSArray *)allApplications
{
    Class LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace");
    NSObject *workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];
    NSArray *array = [workspace performSelector:@selector(allApplications)];
    return array;
}
@end

#if (1 == __XY_DEBUG_UNITTESTING__)

UXY_TEST_CASE( Core, XYApplicationWorkspace )
{
    //	TODO( "test case" )
}

UXY_DESCRIBE( test1 )
{
    NSArray *array = [[XYApplicationWorkspace alloc] allApplications];
    //NSLog(@"apps: %@", array);
    UXY_EXPECTED(array.count > 0);
}

UXY_TEST_CASE_END

#endif


