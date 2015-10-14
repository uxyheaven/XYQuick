//
//  NSObject+FunctionalProgramming.h
//  JoinShow
//
//  Created by XingYao on 15/10/13.
//  Copyright © 2015年 Heaven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (FunctionalProgramming)

+ (BOOL)AND:(id)spec, ...;

+ (BOOL (^)())$blockAnd;
+ (int (^)())blockTest;

+ (void)showBlock:(id)block;

@end
