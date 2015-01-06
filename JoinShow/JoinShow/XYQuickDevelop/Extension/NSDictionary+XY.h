//
//  NSDictionary+XY.h
//  KeyLinks2
//
//  Created by Heaven on 14-5-27.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (XY)

+ (NSMutableDictionary *)nonRetainDictionary;

@end

@interface NSMutableDictionary (XY)

- (NSDictionary *)immutable;

@end