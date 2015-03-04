//
//  XYSignal.m
//  JoinShow
//
//  Created by heaven on 15/2/28.
//  Copyright (c) 2015年 Heaven. All rights reserved.
//

#import "XYSignal.h"
#import <objc/runtime.h>

#define kUXYSignalHandler_key "NSObject.signalHandler.key"

@implementation XYSignal

+ (id)signalWithName:(NSString *)name
{
    
}

@end

#pragma mark- UXYSignalHandler

@implementation NSObject (UXYSignalHandler)

@dynamic uxy_nextSignalHandler;

- (void)uxy_performSignal:(XYSignal *)signal
{
    
}

- (void)uxy_handleSignal:(XYSignal *)signal
{
    [self uxy_performSignal:signal];
    
    if (signal.isDead == YES)
    {
        return;
    }
    
    if (signal.isReach == YES)
    {
        return;
    }
    
    id next = self.uxy_nextSignalHandler ?: [self uxy_defaultNextSignalHandler];
    if (next)
    {
        signal.jump++;
        [next uxy_handleSignal:signal];
    }
    else
    {
        signal.isReach = YES;
    }
}

- (void)setUxy_NextSignalHandler:(id)nextSignalHandler
{
    objc_setAssociatedObject(self, kUXYSignalHandler_key, nextSignalHandler, OBJC_ASSOCIATION_ASSIGN);
}

- (id)uxy_NextSignalHandler
{
    return objc_getAssociatedObject(self, kUXYSignalHandler_key);
}

#pragma mark- private

- (id)uxy_defaultNextSignalHandler
{
    return nil;
}

@end

#pragma mark - UIView

@implementation UIView (UXYSignalHandler)

- (id)uxy_defaultNextSignalHandler
{
    return self.superview ?: [self uxy_currentViewController];
}

#pragma mark- private
- (UIViewController *)uxy_currentViewController
{
    id viewController = [self nextResponder];
    UIView *view      = self;
    
    while (viewController && ![viewController isKindOfClass:[UIViewController class]])
    {
        view           = [view superview];
        viewController = [view nextResponder];
    }
    
    return viewController;
}
@end

#pragma mark - UIViewController

@implementation UIViewController (UXYSignalHandler)

- (id)uxy_defaultNextSignalHandler
{
    id defaultNext;
    
    if ([self isKindOfClass:[UINavigationController class]])
    {
        //defaultNext = [(UINavigationController *)self topViewController];
    }
    else
    {
        defaultNext = [self parentViewController];
    }
    
    return defaultNext;
}

@end


