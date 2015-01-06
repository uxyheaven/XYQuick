//
//  NSSet+XY.h
//  JoinShow
//
//  Created by Heaven on 14-8-1.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSSet (XY)

+ (NSMutableDictionary *)nonRetainSet;


@end

@interface NSMutableSet (XY)

- (NSSet *)immutable;

@end