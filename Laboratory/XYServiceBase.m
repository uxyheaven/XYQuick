//
//  TDServiceBase.m
//  iThunder
//
//  Created by heaven on 15/4/15.
//  Copyright (c) 2015年 xunlei.com. All rights reserved.
//

#import "XYServiceBase.h"

// 先用xmpp里的多路委托这类将就用下
#import "XYMulticastDelegate.h"

@interface XYServiceBase ()

@property (nonatomic, strong) XYMulticastDelegate *multicastDelggate;

@end

@implementation XYServiceBase

+ (instancetype)instance
{
  //  return [[TDServiceLoader sharedInstance] service:[self class]];
}

- (id)init
{
    self = [super init];
    if ( self )
    {
        self.name = NSStringFromClass([self class]);
        self.bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[[self class] description] ofType:@"bundle"] ];
        self.multicastDelggate = [[XYMulticastDelegate alloc] init];
    }
    return self;
}

- (void)dealloc
{
    if ( _running )
    {
        [self powerOff];
    }
    
    self.bundle = nil;
    self.name = nil;
    self.multicastDelggate = nil;
}

- (void)install
{
}

- (void)uninstall
{
}

- (void)powerOn
{
}

- (void)powerOff
{
}

- (void)addDelegate:(id)delegate
{
    [_multicastDelggate addDelegate:delegate delegateQueue:dispatch_get_main_queue()];
}

- (void)removeDelegate:(id)delegate
{
    [_multicastDelggate removeDelegate:delegate];
}

- (void)removeAllDelegates
{
    [_multicastDelggate removeAllDelegates];
}

@end
