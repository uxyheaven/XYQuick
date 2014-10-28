//
//  AopTestM.m
//  JoinShow
//
//  Created by Heaven on 14/10/28.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import "AopTestM.h"

@implementation AopTestM

- (NSString *)sumA:(int)a andB:(int)b
{
    int value = a + b;
    NSString *str = [NSString stringWithFormat:@"fun running. sum : %d", value];
    NSLog(@"%@", str);
    
    return str;
}

@end
