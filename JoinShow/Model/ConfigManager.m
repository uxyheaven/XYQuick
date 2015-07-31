//
//  ConfigManager.m
//  JoinShow
//
//  Created by Heaven on 13-9-10.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import "ConfigManager.h"

@implementation ConfigManager uxy_def_singleton

-(NSString *) Strtest2
{
    [[NSUserDefaults standardUserDefaults] objectForKey:@"a"];
}
@end
