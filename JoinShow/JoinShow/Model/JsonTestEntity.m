//
//  JsonTestEntity.m
//  JoinShow
//
//  Created by Heaven on 14-4-24.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import "JsonTestEntity.h"

@implementation JsonTestEntity

- (void)dealloc
{
    self.array = nil;
    self.dic = nil;
    
    [super dealloc];
}
@end
