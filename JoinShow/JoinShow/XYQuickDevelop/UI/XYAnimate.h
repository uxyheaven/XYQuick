//
//  XYAnimate.h
//  JoinShow
//
//  Created by Heaven on 13-11-18.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYPrecompile.h"
#import "XYFoundation.h"
//#import "XYExtension.h"

typedef void (^XYAnimateStepBlock)(void);


@interface XYAnimate : NSObject

@end
//////////////////////          XYAnimateStep        ///////////////////////


@interface XYAnimateStep : NSObject

+ (id)duration:(NSTimeInterval)duration
       animate:(XYAnimateStepBlock)step;

+ (id)delay:(NSTimeInterval)delay
   duration:(NSTimeInterval)duration
    animate:(XYAnimateStepBlock)step;

+ (id)delay:(NSTimeInterval)delay
   duration:(NSTimeInterval)duration
    option:(UIViewAnimationOptions)option
    animate:(XYAnimateStepBlock)step;

@property (nonatomic, assign) NSTimeInterval         delay;
@property (nonatomic, assign) NSTimeInterval         duration;
@property (nonatomic, copy  ) XYAnimateStepBlock     step;
@property (nonatomic, assign) UIViewAnimationOptions option;


- (void)runAnimated:(BOOL)animated;
- (void)run;

@end
//////////////////////          XYAnimateSerialStep        ///////////////////////
// 串行 序列  Serial Sequence
@interface XYAnimateSerialStep : XYAnimateStep
@property (nonatomic, strong, readonly) NSArray* steps;

+ (id)animate;
- (id)addStep:(XYAnimateStep *)aStep;

@end
//////////////////////          XYAnimateParallelStep        ///////////////////////
// 并行 序列 Parallel Spawn
@interface XYAnimateParallelStep : XYAnimateStep

@property (nonatomic, strong, readonly) NSArray* steps;

+ (id)animate;
- (id)addStep:(XYAnimateStep *)aStep;

@end












