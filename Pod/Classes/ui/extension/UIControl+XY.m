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
//  This file Copy from BlockUI.

#import "UIControl+XY.h"
#import <objc/runtime.h>
#pragma mark-
@implementation UIControl (XYExtension)

static const char *XYControl_key_events = "XYControl_key_events";

- (void)uxy_handleControlEvent:(UIControlEvents)event withBlock:(void(^)(id sender))block
{
    NSString *methodName = [UIControl __uxy_eventName:event];
    NSMutableDictionary *opreations = (NSMutableDictionary*)objc_getAssociatedObject(self, XYControl_key_events);
    
    if(opreations == nil)
    {
        opreations = [NSMutableDictionary dictionaryWithCapacity:2];
        objc_setAssociatedObject(self, XYControl_key_events, opreations, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    [opreations setObject:[block copy] forKey:methodName];
    [self addTarget:self action:NSSelectorFromString(methodName) forControlEvents:event];
}

- (void)uxy_removeHandlerForEvent:(UIControlEvents)event
{
    NSString *methodName = [UIControl __uxy_eventName:event];
    NSMutableDictionary *opreations = (NSMutableDictionary *)objc_getAssociatedObject(self, XYControl_key_events);
    
    if(opreations == nil)
    {
        opreations = [NSMutableDictionary dictionaryWithCapacity:2];
        objc_setAssociatedObject(self, XYControl_key_events, opreations, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    [opreations removeObjectForKey:methodName];
    [self removeTarget:self action:NSSelectorFromString(methodName) forControlEvents:event];
}

#pragma mark - private
- (void)__uxy_controlEventTouchDown{[self __uxy_callActionBlock:UIControlEventTouchDown];}
- (void)__uxy_controlEventTouchDownRepeat{[self __uxy_callActionBlock:UIControlEventTouchDownRepeat];}
- (void)__uxy_controlEventTouchDragInside{[self __uxy_callActionBlock:UIControlEventTouchDragInside];}
- (void)__uxy_controlEventTouchDragOutside{[self __uxy_callActionBlock:UIControlEventTouchDragOutside];}
- (void)__uxy_controlEventTouchDragEnter{[self __uxy_callActionBlock:UIControlEventTouchDragEnter];}
- (void)__uxy_controlEventTouchDragExit{[self __uxy_callActionBlock:UIControlEventTouchDragExit];}
- (void)__uxy_controlEventTouchUpInside{[self __uxy_callActionBlock:UIControlEventTouchUpInside];}
- (void)__uxy_controlEventTouchUpOutside{[self __uxy_callActionBlock:UIControlEventTouchUpOutside];}
- (void)__uxy_controlEventTouchCancel{[self __uxy_callActionBlock:UIControlEventTouchCancel];}
- (void)__uxy_controlEventValueChanged{[self __uxy_callActionBlock:UIControlEventValueChanged];}
- (void)__uxy_controlEventEditingDidBegin{[self __uxy_callActionBlock:UIControlEventEditingDidBegin];}
- (void)__uxy_controlEventEditingChanged{[self __uxy_callActionBlock:UIControlEventEditingChanged];}
- (void)__uxy_controlEventEditingDidEnd{[self __uxy_callActionBlock:UIControlEventEditingDidEnd];}
- (void)__uxy_controlEventEditingDidEndOnExit{[self __uxy_callActionBlock:UIControlEventEditingDidEndOnExit];}
- (void)__uxy_controlEventAllTouchEvents{[self __uxy_callActionBlock:UIControlEventAllTouchEvents];}
- (void)__uxy_controlEventAllEditingEvents{[self __uxy_callActionBlock:UIControlEventAllEditingEvents];}
- (void)__uxy_controlEventApplicationReserved{[self __uxy_callActionBlock:UIControlEventApplicationReserved];}
- (void)__uxy_controlEventSystemReserved{[self __uxy_callActionBlock:UIControlEventSystemReserved];}
- (void)__uxy_controlEventAllEvents{[self __uxy_callActionBlock:UIControlEventAllEvents];}

- (void)__uxy_callActionBlock:(UIControlEvents)event
{
    NSMutableDictionary *opreations = (NSMutableDictionary *)objc_getAssociatedObject(self, XYControl_key_events);
    
    if(opreations == nil)
        return;
    
    void(^block)(id sender) = [opreations objectForKey:[UIControl __uxy_eventName:event]];
    
    block ? block(self) : nil ;
}

+ (NSString *)__uxy_eventName:(UIControlEvents)event
{
    static NSDictionary *controlEventStrings = nil;
    
    static dispatch_once_t once;
    dispatch_once( &once, ^{
        controlEventStrings = @{@(UIControlEventTouchDown): @"__uxy_controlEventTouchDown",
                                @(UIControlEventTouchDownRepeat): @"__uxy_controlEventTouchDownRepeat",
                                @(UIControlEventTouchDragInside): @"__uxy_controlEventTouchDragInside",
                                @(UIControlEventTouchDragOutside): @"__uxy_controlEventTouchDragOutside",
                                @(UIControlEventTouchDragEnter): @"__uxy_controlEventTouchDragEnter",
                                @(UIControlEventTouchDragExit): @"__uxy_controlEventTouchDragExit",
                                @(UIControlEventTouchUpInside): @"__uxy_controlEventTouchUpInside",
                                @(UIControlEventTouchUpOutside): @"__uxy_controlEventTouchUpOutside",
                                @(UIControlEventTouchCancel): @"__uxy_controlEventTouchCancel",
                                @(UIControlEventValueChanged): @"__uxy_controlEventValueChanged",
                                @(UIControlEventEditingDidBegin): @"__uxy_controlEventEditingDidBegin",
                                @(UIControlEventEditingChanged): @"__uxy_controlEventEditingChanged",
                                @(UIControlEventEditingDidEnd): @"__uxy_controlEventEditingDidEnd",
                                @(UIControlEventEditingDidEndOnExit): @"__uxy_controlEventEditingDidEndOnExit",
                                @(UIControlEventAllTouchEvents): @"__uxy_controlEventAllTouchEvents",
                                @(UIControlEventAllEditingEvents): @"__uxy_controlEventAllEditingEvents",
                                @(UIControlEventApplicationReserved): @"__uxy_controlEventApplicationReserved",
                                @(UIControlEventSystemReserved): @"__uxy_controlEventSystemReserved",
                                @(UIControlEventAllEvents): @"__uxy_controlEventAllEvents"
                                };
    });
    
    return controlEventStrings[@(event)];
}

@end
