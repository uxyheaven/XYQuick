//
//  XYApplicationWorkspace.m
//  JoinShow
//
//  Created by Heaven on 15/8/5.
//  Copyright (c) 2015年 Heaven. All rights reserved.
//

#import "XYApplicationWorkspace.h"

@implementation XYApplicationWorkspace

- (NSArray *)allApplications
{
    Class LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace");
    NSObject *workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];
    NSArray *array = [workspace performSelector:@selector(allApplications)];
    NSLog(@"apps: %@", array);
    return array;
}
@end
