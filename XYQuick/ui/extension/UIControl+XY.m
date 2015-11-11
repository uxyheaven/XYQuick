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

static NSDictionary *XY_DicControlEventString = nil;
static NSDictionary *XY_DicControlStringEvent = nil;


#pragma mark-
@implementation UIControl (XYExtension)

+ (void)load
{
    XY_DicControlEventString = @{@(UIControlEventTouchDown): @"UIControlEventTouchDown",
                                 @(UIControlEventTouchDownRepeat): @"UIControlEventTouchDownRepeat",
                                 @(UIControlEventTouchDragInside): @"UIControlEventTouchDragInside",
                                 @(UIControlEventTouchDragOutside): @"UIControlEventTouchDragOutside",
                                 @(UIControlEventTouchDragEnter): @"UIControlEventTouchDragEnter",
                                 @(UIControlEventTouchDragExit): @"UIControlEventTouchDragExit",
                                 @(UIControlEventTouchUpInside): @"UIControlEventTouchUpInside",
                                 @(UIControlEventTouchUpOutside): @"UIControlEventTouchUpOutside",
                                 @(UIControlEventTouchCancel): @"UIControlEventTouchCancel",
                                 @(UIControlEventValueChanged): @"UIControlEventValueChanged",
                                 @(UIControlEventEditingDidBegin): @"UIControlEventEditingDidBegin",
                                 @(UIControlEventEditingChanged): @"UIControlEventEditingChanged",
                                 @(UIControlEventEditingDidEnd): @"UIControlEventEditingDidEnd",
                                 @(UIControlEventEditingDidEndOnExit): @"UIControlEventEditingDidEndOnExit",
                                 @(UIControlEventAllTouchEvents): @"UIControlEventAllTouchEvents",
                                 @(UIControlEventAllEditingEvents): @"UIControlEventAllEditingEvents",
                                 @(UIControlEventApplicationReserved): @"UIControlEventApplicationReserved",
                                 @(UIControlEventSystemReserved): @"UIControlEventSystemReserved",
                                 @(UIControlEventAllEvents): @"UIControlEventAllEvents"
                                 };
    
    XY_DicControlStringEvent = @{@"UIControlEventTouchDown": @(UIControlEventTouchDown),
                                 @"UIControlEventTouchDownRepeat": @(UIControlEventTouchDownRepeat),
                                 @"UIControlEventTouchDragInside": @(UIControlEventTouchDragInside),
                                 @"UIControlEventTouchDragOutside": @(UIControlEventTouchDragOutside),
                                 @"UIControlEventTouchDragEnter": @(UIControlEventTouchDragEnter),
                                 @"UIControlEventTouchDragExit": @(UIControlEventTouchDragExit),
                                 @"UIControlEventTouchUpInside": @(UIControlEventTouchUpInside),
                                 @"UIControlEventTouchUpOutside": @(UIControlEventTouchUpOutside),
                                 @"UIControlEventTouchCancel": @(UIControlEventTouchCancel),
                                 @"UIControlEventValueChanged": @(UIControlEventValueChanged),
                                 @"UIControlEventEditingDidBegin": @(UIControlEventEditingDidBegin),
                                 @"UIControlEventEditingChanged": @(UIControlEventEditingChanged),
                                 @"UIControlEventEditingDidEnd": @(UIControlEventEditingDidEnd),
                                 @"UIControlEventEditingDidEndOnExit": @(UIControlEventEditingDidEndOnExit),
                                 @"UIControlEventAllTouchEvents": @(UIControlEventAllTouchEvents),
                                 @"UIControlEventAllEditingEvents": @(UIControlEventAllEditingEvents),
                                 @"UIControlEventApplicationReserved": @(UIControlEventApplicationReserved),
                                 @"UIControlEventSystemReserved": @(UIControlEventSystemReserved),
                                 @"UIControlEventAllEvents": @(UIControlEventAllEvents)
                                 };
    
    Method a = class_getInstanceMethod([UIControl class], @selector(sendAction:to:forEvent:));
    Method b = class_getInstanceMethod([UIControl class], @selector(__uxy_sendAction:to:forEvent:));
    method_exchangeImplementations(a, b);
    
}

uxy_staticConstString(UIControl_key_events)

- (void)dealloc
{
    NSMutableDictionary *opreations = (NSMutableDictionary*)objc_getAssociatedObject(self, UIControl_key_events);
    if (opreations)
    {
        [opreations enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [self uxy_removeHandlerForEvent:[UIControl __uxy_eventWithName:key]];
        }];
        objc_setAssociatedObject(self, UIControl_key_events, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)uxy_handleControlEvent:(UIControlEvents)event withBlock:(void(^)(id sender))block {
    
    NSString *methodName = [UIControl __uxy_eventName:event];
    
    NSMutableDictionary *opreations = (NSMutableDictionary*)objc_getAssociatedObject(self, UIControl_key_events);
    
    if(opreations == nil)
    {
        opreations = [NSMutableDictionary dictionaryWithCapacity:2];
        objc_setAssociatedObject(self, UIControl_key_events, opreations, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    [opreations setObject:[block copy] forKey:methodName];
    [self addTarget:self action:NSSelectorFromString(methodName) forControlEvents:event];
}

- (void)uxy_removeHandlerForEvent:(UIControlEvents)event
{
    
    NSString *methodName = [UIControl __uxy_eventName:event];
    NSMutableDictionary *opreations = (NSMutableDictionary*)objc_getAssociatedObject(self, UIControl_key_events);
    
    if(opreations == nil)
    {
        opreations = [NSMutableDictionary dictionaryWithCapacity:2];
        objc_setAssociatedObject(self, UIControl_key_events, opreations, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    [opreations removeObjectForKey:methodName];
    [self removeTarget:self action:NSSelectorFromString(methodName) forControlEvents:event];
}

uxy_staticConstString(UIControl_acceptEventInterval)

- (NSTimeInterval)uxy_acceptEventInterval
{
    return [objc_getAssociatedObject(self, UIControl_acceptEventInterval) doubleValue];
}

- (void)setUxy_acceptEventInterval:(NSTimeInterval)uxy_acceptEventInterval
{
    objc_setAssociatedObject(self, UIControl_acceptEventInterval, @(uxy_acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - private
// todo 命名待重构
- (void)UIControlEventTouchDown{[self __uxy_callActionBlock:UIControlEventTouchDown];}
- (void)UIControlEventTouchDownRepeat{[self __uxy_callActionBlock:UIControlEventTouchDownRepeat];}
- (void)UIControlEventTouchDragInside{[self __uxy_callActionBlock:UIControlEventTouchDragInside];}
- (void)UIControlEventTouchDragOutside{[self __uxy_callActionBlock:UIControlEventTouchDragOutside];}
- (void)UIControlEventTouchDragEnter{[self __uxy_callActionBlock:UIControlEventTouchDragEnter];}
- (void)UIControlEventTouchDragExit{[self __uxy_callActionBlock:UIControlEventTouchDragExit];}
- (void)UIControlEventTouchUpInside{[self __uxy_callActionBlock:UIControlEventTouchUpInside];}
- (void)UIControlEventTouchUpOutside{[self __uxy_callActionBlock:UIControlEventTouchUpOutside];}
- (void)UIControlEventTouchCancel{[self __uxy_callActionBlock:UIControlEventTouchCancel];}
- (void)UIControlEventValueChanged{[self __uxy_callActionBlock:UIControlEventValueChanged];}
- (void)UIControlEventEditingDidBegin{[self __uxy_callActionBlock:UIControlEventEditingDidBegin];}
- (void)UIControlEventEditingChanged{[self __uxy_callActionBlock:UIControlEventEditingChanged];}
- (void)UIControlEventEditingDidEnd{[self __uxy_callActionBlock:UIControlEventEditingDidEnd];}
- (void)UIControlEventEditingDidEndOnExit{[self __uxy_callActionBlock:UIControlEventEditingDidEndOnExit];}
- (void)UIControlEventAllTouchEvents{[self __uxy_callActionBlock:UIControlEventAllTouchEvents];}
- (void)UIControlEventAllEditingEvents{[self __uxy_callActionBlock:UIControlEventAllEditingEvents];}
- (void)UIControlEventApplicationReserved{[self __uxy_callActionBlock:UIControlEventApplicationReserved];}
- (void)UIControlEventSystemReserved{[self __uxy_callActionBlock:UIControlEventSystemReserved];}
- (void)UIControlEventAllEvents{[self __uxy_callActionBlock:UIControlEventAllEvents];}


- (void)__uxy_callActionBlock:(UIControlEvents)event
{
    NSMutableDictionary *opreations = (NSMutableDictionary*)objc_getAssociatedObject(self, UIControl_key_events);
    
    if(opreations == nil) return;
    
    void(^block)(id sender) = [opreations objectForKey:[UIControl __uxy_eventName:event]];
    
    block ? block(self) : nil ;
    
}

+ (NSString *)__uxy_eventName:(UIControlEvents)event
{
    return [XY_DicControlEventString objectForKey:@(event)];
}

+ (UIControlEvents)__uxy_eventWithName:(NSString *)name
{
    return [[XY_DicControlStringEvent objectForKey:name] integerValue];
}

uxy_staticConstString(UIControl_acceptedEventTime)

- (NSTimeInterval)uxy_acceptedEventTime
{
    return [objc_getAssociatedObject(self, UIControl_acceptedEventTime) doubleValue];
}

- (void)setUxy_acceptedEventTime:(NSTimeInterval)uxy_acceptedEventTime
{
    objc_setAssociatedObject(self, UIControl_acceptedEventTime, @(uxy_acceptedEventTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)__uxy_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    if (NSDate.date.timeIntervalSince1970 - self.uxy_acceptedEventTime < self.uxy_acceptEventInterval) return;
    
    if (self.uxy_acceptEventInterval > 0)
    {
        self.uxy_acceptedEventTime = NSDate.date.timeIntervalSince1970;
    }
    
    [self __uxy_sendAction:action to:target forEvent:event];
}
@end
