//
//  XYModuleManager.m
//  XYQuick
//
//  Created by heaven on 2016/12/20.
//  Copyright © 2016年 xingyao095. All rights reserved.
//

#import "XYModuleManager.h"
#import <objc/message.h>


@interface XYModuleManager ()

@property (nonatomic, strong) NSMutableArray *modules;

@end

@implementation XYModuleManager

- (void)hookAppDelegate:(id <UIApplicationDelegate>)appDelegate
{
    unsigned int numberOfMethods = 0;
    struct objc_method_description *methodDescriptions = protocol_copyMethodDescriptionList(@protocol(UIApplicationDelegate), NO, YES, &numberOfMethods);
    
    for (unsigned int i = 0; i < numberOfMethods; ++i)
    {
        struct objc_method_description methodDescription = methodDescriptions[i];
        SEL selector = methodDescription.name;
        
        if (![self respondsToSelector:selector])
        {
            NSLog(@"%s", selector);
            
            SEL aSelectorNew = NSSelectorFromString([NSString stringWithFormat:@"xy__%s", selector]);
        }
    }
}


- (void)addAModule:(id)module
{
    
}


#pragma mark -

#pragma mark -

static id __singleton__objc__token;
static dispatch_once_t __singleton__token__token;
+ (instancetype)sharedInstance
{
    dispatch_once(&__singleton__token__token, ^{ __singleton__objc__token = [[self alloc] init]; });
    return __singleton__objc__token;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _modules = @[].mutableCopy;
    }
    return self;
}

+ (void)load
{
    @autoreleasepool {
        
    }
}


@end
