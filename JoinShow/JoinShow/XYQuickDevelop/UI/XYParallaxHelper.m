//
//  ParallaxHelper.m
//  JoinShow
//
//  Created by Heaven on 13-10-9.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import "XYParallaxHelper.h"

@interface XYParallaxHelper (){
    CMMotionManager *_motion;
    int orientation1;
    int orientation2;
    
    int orientationType;
}

@property (nonatomic, strong) NSMutableArray *views;
@property (nonatomic, strong) NSMutableArray *intensitys;

@property (nonatomic, strong) CMAttitude *lastAttitude;
@property (nonatomic, strong) CMAttitude *curAttitude;

@end

@implementation XYParallaxHelper

DEF_SINGLETON(XYParallaxHelper)

- (id)init
{
    self = [super init];
    if (self) {
        self.views = [NSMutableArray arrayWithCapacity:15];
        self.intensitys = [NSMutableArray arrayWithCapacity:15];
        _updateInterval = ParallaxHelper_updateInterval;
    }
    return self;
}

- (void)dealloc
{
}

-(void) start{
    if (!_motion) {
        _motion = [[CMMotionManager alloc] init];
        //_updateInterval_motion.updateInterval = _updateInterval;
        if (_motion.deviceMotionAvailable) {
            [_motion startDeviceMotionUpdates];
            self.lastAttitude = _motion.deviceMotion.attitude;
            self.curAttitude = _motion.deviceMotion.attitude;
            [self resetDeviceOrientation];
            [self timer:_updateInterval repeat:YES];

            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
        }else{
            SHOWMSG(@"Message", @"Can't use deviceMotionAvailable.", @"cancel");
            [self stop];

        }
    }
    
}

-(void) stop{
    if (_motion) {
        [_motion stopDeviceMotionUpdates];
        _motion = nil;
        [self cancelTimer:nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
        [_views enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIView *view = obj;
            view.transform = CGAffineTransformIdentity;
        }];
    }
}
- (void)deviceOrientationDidChange:(NSNotification *)notification{
    [self resetDeviceOrientation];
}
-(void) resetDeviceOrientation{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    switch (orientation) {
        case UIInterfaceOrientationPortrait:
        {
            orientation1 = 1;
            orientation2 = 1;
            orientationType = 1;
            break;
        }
        case UIInterfaceOrientationPortraitUpsideDown:
        {
            orientation1 = -1;
            orientation2 = -1;
            orientationType = 1;
            break;
        }
        case UIInterfaceOrientationLandscapeLeft:
        {
            orientation1 = 1;
            orientation2 = -1;
            orientationType = 2;
            break;
        }
        case UIInterfaceOrientationLandscapeRight:
        {
            orientation1 = -1;
            orientation2 = 1;
            orientationType = 2;
            break;
        }
        default:
            break;
    }
}
-(void) setView:(id)aView intensity:(float)i{
    NSUInteger index = [_views indexOfObject:aView];
    if (index == NSNotFound) {
        [_views addObject:aView];
        [_intensitys addObject:@(i)];
    }else{
        [_intensitys replaceObjectAtIndex:index withObject:@(i)];
    }
}
-(void) removeView:(id)aView{
    NSUInteger index = [_views indexOfObject:aView];
    if (index != NSNotFound) {
        [_views removeObjectAtIndex:index];
        [_intensitys removeObjectAtIndex:index];
    }
}
-(void) removeAllView{
    [_views removeAllObjects];
    [_intensitys removeAllObjects];
}

#define mark - XYTimerDelegate
ON_TIMER(){
    CMDeviceMotion *motion = _motion.deviceMotion;
    self.curAttitude = motion.attitude;
    
    CGPoint point = CGPointMake((self.curAttitude.roll - self.lastAttitude.roll), (self.curAttitude.pitch - self.lastAttitude.pitch));
    //  NSLogD(@"%@", NSStringFromCGPoint(point));
    
    [_views enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *view = obj;
        float f = [[_intensitys objectAtIndex:idx] floatValue];
        
        CGPoint attitudeDifference = CGPointMake(point.x * f * orientation1, point.y * f * orientation2);
        CGAffineTransform newTransform;
        if (orientationType == 1) {
            if (f > 0) {
                newTransform = CGAffineTransformMakeTranslation(MAX(MIN(f, attitudeDifference.x), -f),
                                                                MAX(MIN(f, attitudeDifference.y), -f));
            } else {
                newTransform = CGAffineTransformMakeTranslation(MIN(MAX(f, attitudeDifference.x), -f),
                                                                MIN(MAX(f, attitudeDifference.y), -f));
            }
        }else{
            if (f > 0) {
                newTransform = CGAffineTransformMakeTranslation(MAX(MIN(f, attitudeDifference.y), -f),
                                                                MAX(MIN(f, attitudeDifference.x), -f));
            } else {
                newTransform = CGAffineTransformMakeTranslation(MIN(MAX(f, attitudeDifference.y), -f),
                                                                MIN(MAX(f, attitudeDifference.x), -f));
            }
        }
        
        
        view.transform = newTransform;
    }];

}

#pragma mark - kvo

@end
