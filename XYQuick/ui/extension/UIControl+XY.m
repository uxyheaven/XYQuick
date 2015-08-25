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
#import "XYQuick_Predefine.h"
#import "NSObject+XY.h"

#undef	UIControl_key_events
#define UIControl_key_events	"UIControl.events"

static NSDictionary *XY_DicControlEventString = nil;
static NSDictionary *XY_DicControlStringEvent = nil;

DUMMY_CLASS(UIControl_XY);

@implementation UIControl (XY)

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
}

- (void)dealloc
{
    NSMutableDictionary *opreations = (NSMutableDictionary*)objc_getAssociatedObject(self, UIControl_key_events);
    if (opreations)
    {
        [opreations enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [self uxy_removeHandlerForEvent:[UIControl eventWithName:key]];
        }];
        [self uxy_assignAssociatedObject:nil forKey:UIControl_key_events];
    }
}

- (void)uxy_removeHandlerForEvent:(UIControlEvents)event
{
    
    NSString *methodName = [UIControl eventName:event];
    NSMutableDictionary *opreations = (NSMutableDictionary*)objc_getAssociatedObject(self, UIControl_key_events);
    
    if(opreations == nil)
    {
        opreations = [NSMutableDictionary dictionaryWithCapacity:2];
        [self uxy_retainAssociatedObject:opreations forKey:UIControl_key_events];
    }
    
    [opreations removeObjectForKey:methodName];
    [self removeTarget:self action:NSSelectorFromString(methodName) forControlEvents:event];
}

- (void)uxy_handleControlEvent:(UIControlEvents)event withBlock:(void(^)(id sender))block {
    
    NSString *methodName = [UIControl eventName:event];
    
    NSMutableDictionary *opreations = (NSMutableDictionary*)objc_getAssociatedObject(self, UIControl_key_events);
    
    if(opreations == nil)
    {
        opreations = [NSMutableDictionary dictionaryWithCapacity:2];
        [self uxy_retainAssociatedObject:opreations forKey:UIControl_key_events];
    }
    
    [opreations setObject:[block copy] forKey:methodName];
    [self addTarget:self action:NSSelectorFromString(methodName) forControlEvents:event];
}


- (void)UIControlEventTouchDown{[self callActionBlock:UIControlEventTouchDown];}
- (void)UIControlEventTouchDownRepeat{[self callActionBlock:UIControlEventTouchDownRepeat];}
- (void)UIControlEventTouchDragInside{[self callActionBlock:UIControlEventTouchDragInside];}
- (void)UIControlEventTouchDragOutside{[self callActionBlock:UIControlEventTouchDragOutside];}
- (void)UIControlEventTouchDragEnter{[self callActionBlock:UIControlEventTouchDragEnter];}
- (void)UIControlEventTouchDragExit{[self callActionBlock:UIControlEventTouchDragExit];}
- (void)UIControlEventTouchUpInside{[self callActionBlock:UIControlEventTouchUpInside];}
- (void)UIControlEventTouchUpOutside{[self callActionBlock:UIControlEventTouchUpOutside];}
- (void)UIControlEventTouchCancel{[self callActionBlock:UIControlEventTouchCancel];}
- (void)UIControlEventValueChanged{[self callActionBlock:UIControlEventValueChanged];}
- (void)UIControlEventEditingDidBegin{[self callActionBlock:UIControlEventEditingDidBegin];}
- (void)UIControlEventEditingChanged{[self callActionBlock:UIControlEventEditingChanged];}
- (void)UIControlEventEditingDidEnd{[self callActionBlock:UIControlEventEditingDidEnd];}
- (void)UIControlEventEditingDidEndOnExit{[self callActionBlock:UIControlEventEditingDidEndOnExit];}
- (void)UIControlEventAllTouchEvents{[self callActionBlock:UIControlEventAllTouchEvents];}
- (void)UIControlEventAllEditingEvents{[self callActionBlock:UIControlEventAllEditingEvents];}
- (void)UIControlEventApplicationReserved{[self callActionBlock:UIControlEventApplicationReserved];}
- (void)UIControlEventSystemReserved{[self callActionBlock:UIControlEventSystemReserved];}
- (void)UIControlEventAllEvents{[self callActionBlock:UIControlEventAllEvents];}


- (void)callActionBlock:(UIControlEvents)event
{
    
    NSMutableDictionary *opreations = (NSMutableDictionary*)objc_getAssociatedObject(self, UIControl_key_events);
    
    if(opreations == nil)
        return;
    
    void(^block)(id sender) = [opreations objectForKey:[UIControl eventName:event]];
    
    if (block)
        block(self);
    
}
+ (NSString *)eventName:(UIControlEvents)event
{
    return [XY_DicControlEventString objectForKey:@(event)];
}
+ (UIControlEvents)eventWithName:(NSString *)name
{
    return [[XY_DicControlStringEvent objectForKey:name] integerValue];
}

@end
