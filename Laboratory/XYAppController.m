//
//  XYAppController.m
//  JoinShow
//
//  Created by heaven on 15/4/22.
//  Copyright (c) 2015年 Heaven. All rights reserved.
//

#import "XYAppController.h"
#import "XYUnitTest.h"
#import "XYClassLoader.h"
#import "XYRuntime.h"


@interface XYAppController ()

- (void)__before_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

- (void)before_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
- (void)after_application_didFinishLaunchingWithOptions;

@end


BOOL __applicationDidFinishLaunchingWithOptions(id self, SEL _cmd, UIApplication *application, NSDictionary *launchOptions)
{
    [[XYAppController sharedInstance] __before_application:application didFinishLaunchingWithOptions:launchOptions];

    NSMethodSignature *sig = [self methodSignatureForSelector:@selector(application:didFinishLaunchingWithOptions:)];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
    [invocation setTarget:self];
    [invocation setSelector:@selector(__applicationDidFinishLaunchingWithOptions)];
    [invocation setArgument:&application atIndex:2];
    [invocation setArgument:&launchOptions atIndex:3];
    [invocation invoke];
    BOOL returnValue;
    [invocation getReturnValue:&returnValue];
    return returnValue;
}

@implementation XYAppController uxy_def_singleton

+ (void)load
{
    XYAppController *appController = [XYAppController sharedInstance];
    NSArray *classes = [NSObject uxy_classesWithProtocol:@"UIApplicationDelegate"];
    
    if (classes.count > 0)
    {
        Class clazz = NSClassFromString(classes[0]);
        Method a = class_getInstanceMethod(clazz, @selector(application:didFinishLaunchingWithOptions:));
        if (class_addMethod(clazz, @selector(__applicationDidFinishLaunchingWithOptions), (IMP)__applicationDidFinishLaunchingWithOptions, "B@:@@"))
        {
            Method b = class_getInstanceMethod(clazz, @selector(__applicationDidFinishLaunchingWithOptions));
            method_exchangeImplementations(a, b);
        }
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:appController
                                             selector:@selector(__after_application_didFinishLaunchingWithOptions)
                                                 name:UIApplicationDidFinishLaunchingNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:appController
                                             selector:@selector(UIApplicationWillTerminateNotification)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];
}

#pragma mark- hook
- (void)__before_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // NSLog(@"%s", __FUNCTION__);
    [self before_application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)__after_application_didFinishLaunchingWithOptions
{
    [self startup];
    [self after_application_didFinishLaunchingWithOptions];
}

- (void)UIApplicationWillTerminateNotification
{
    
}

- (void)startup
{
    [[XYClassLoader classLoader] loadClasses:@[
                                               ]];
}
#pragma mark-virtual function
- (void)before_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
}
- (void)after_application_didFinishLaunchingWithOptions
{
    
}
@end
