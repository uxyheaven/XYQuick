//
//  ParallaxManager.h
//  JoinShow
//
//  Created by Heaven on 13-10-9.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//


#import "XYPrecompile.h"
#import "XYFoundation.h"

#define ParallaxManager_updateInterval 0.05
#define ParallaxManager_timer @"Parallax"

@interface XYParallaxManager : NSObject

XY_SINGLETON(XYParallaxManager)

// 设备信息刷新间隔
@property (nonatomic, assign) NSTimeInterval updateInterval;

-(void) start;
-(void) stop;

// when device orientation change, run it.
-(void) resetDeviceOrientation;

-(void) setView:(id)aView intensity:(float)i;
-(void) removeView:(id)aView;
-(void) removeAllView;

@end
