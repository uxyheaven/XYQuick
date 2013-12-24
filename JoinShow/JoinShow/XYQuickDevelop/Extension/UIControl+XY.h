//
//  UIControl+XY.h
//  JoinShow
//
//  Created by Heaven on 13-12-24.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//  copy from BlockUI

#import <UIKit/UIKit.h>

@interface UIControl (XY)

-(void) handleControlEvent:(UIControlEvents)event withBlock:(void(^)(id sender))block;
-(void) removeHandlerForEvent:(UIControlEvents)event;

@end
