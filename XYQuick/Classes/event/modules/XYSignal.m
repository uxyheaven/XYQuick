//
//  __  __          ____           _          _
//  \ \/ / /\_/\   /___ \  _   _  (_)   ___  | | __
//   \  /  \_ _/  //  / / | | | | | |  / __| | |/ /
//   /  \   / \  / \_/ /  | |_| | | | | (__  |   <
//  /_/\_\  \_/  \___,_\   \__,_| |_|  \___| |_|\_\
//
//  Copyright (C) Heaven.
//
//	https://github.com/uxyheaven/XYQuick
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.
//

#import "XYSignal.h"

#define kUXYSignalHandler_key "NSObject.signalHandler.key"

#pragma mark- XYSignal
@implementation XYSignal
@end

#pragma mark- NSObject(__XYSignalHandler)
@interface NSObject (__XYSignalHandler) <XYSignalTarget>
@property (nonatomic, weak) id uxy_nextSignalHandler;
@end

@implementation NSObject (XYSignalHandler)

- (XYSignal *)uxy_sendSignalWithName:(NSString *)name userInfo:(id)userInfo
{
    return [self uxy_sendSignalWithName:name userInfo:userInfo sender:self];
}

- (XYSignal *)uxy_sendSignalWithName:(NSString *)name userInfo:(id)userInfo sender:(id)sender
{
    XYSignal *signal = [[XYSignal alloc] init];
    signal.sender    = sender ?: self;
    signal.name      = name;
    signal.userInfo  = userInfo;
    
    [self __uxy_handleSignal:signal];
    
    return signal;
}

#pragma mark- private
- (BOOL)__uxy_performSignal:(XYSignal *)signal
{
    // 1. 普通的
    NSString *string = [NSString stringWithFormat:@"__uxy_handleSignal_n_%@:", signal.name];
    SEL sel = NSSelectorFromString(string);
    if ([self respondsToSelector:sel])
    {
        signal.isReach = YES;
        NSMethodSignature *methodSignature = [[self class] instanceMethodSignatureForSelector:sel];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        [invocation setTarget:self];
        [invocation setSelector:sel];
        [invocation setArgument:&signal atIndex:2];
        [invocation invoke];
        
        return YES;
    }

    return NO;
}

- (id)__uxy_handleSignal:(XYSignal *)signal
{
    id result;
    signal.jump++;
    
    [self __uxy_performSignal:signal];
    
    if (signal.isDead == YES) return nil;
    if (signal.isReach == YES) return nil;
    
    id next = self.uxy_nextSignalHandler ?: self.uxy_defaultNextSignalHandler;
    
    result = [next __uxy_handleSignal:signal];
    
    return result;
}

- (id)uxy_defaultNextSignalHandler
{
    return nil;
}

uxy_staticConstString(XYSignalHandler_nextSignalHandler)
- (void)setUxy_nextSignalHandler:(id)nextSignalHandler
{
    objc_setAssociatedObject(self, XYSignalHandler_nextSignalHandler, nextSignalHandler, OBJC_ASSOCIATION_ASSIGN);
}
- (id)uxy_nextSignalHandler
{
    return objc_getAssociatedObject(self, XYSignalHandler_nextSignalHandler);
}
@end

#pragma mark - UIView
@implementation UIView (XYSignalHandler)

- (id)uxy_defaultNextSignalHandler
{
    return self.nextResponder;
}

@end

#pragma mark - UIViewController
@implementation UIViewController (XYSignalHandler)

- (id)uxy_defaultNextSignalHandler
{
    id result;
    
    if ([self isKindOfClass:[UINavigationController class]])
    {
        //result = [(UINavigationController *)self topViewController];
    }
    else
    {
        result = [self parentViewController];
    }
    
    return result;
}

@end

#pragma mark -
/*
@implementation XYSignalBus
+ (instancetype)defaultBus
{
    static dispatch_once_t once;
    static id __singleton__;
    dispatch_once( &once, ^{ __singleton__ = [[self alloc] init]; } );
    return __singleton__;
}
@end
 */
