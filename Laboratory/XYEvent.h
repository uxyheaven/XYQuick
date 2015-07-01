//
//  XYEvent.h
//  JoinShow
//
//  Created by XingYao on 15/7/1.
//  Copyright (c) 2015年 Heaven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYEventCenter : NSObject

+ (instancetype)defaultCenter;

- (void)addTarget:(id)target action:(SEL)action forEvent:(NSString *)event;
- (void)sendActionsForEvent:(NSString *)event;

@end
