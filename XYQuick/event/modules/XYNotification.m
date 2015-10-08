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

#import "XYNotification.h"
#import "NSObject+XY.h"


void (*XYNotification_action1)(id, SEL, id) = (void (*)(id, SEL, id))objc_msgSend;

#pragma mark - XYNotification
@interface XYNotification ()

@property (nonatomic, weak) id target;                  //
@property (nonatomic, assign) SEL selector;             //
@property (nonatomic, copy) NSString *name;
@property (nonatomic, weak) id sender;                // 来源
@property (nonatomic, strong) id userInfo;

@property (nonatomic, copy) XYNotification_block block;

@end

@implementation XYNotification

- (instancetype)initWithName:(NSString *)name sender:(id)sender target:(id)target selector:(SEL)selector;
{
    self = [super init];
    if (self)
    {
        _name     = name;
        _sender   = sender;
        _target   = target;
        _selector = selector;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleNotification:)                                                            name:name                                                            object:sender];
    }
    
    return self;
}

- (instancetype)initWithName:(NSString *)name sender:(id)sender block:(XYNotification_block)block
{
    self = [super init];
    if (self)
    {
        _name   = name;
        _sender = sender;
        _block  = block;
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(handleNotification:)                                                            name:name                                                            object:sender];
    }
    
    return self;
}

- (void)handleNotification:(NSNotification *)notification
{
    if (_block)
    {
        _block(notification);
        return;
    }
    
    XYNotification_action1(_target, _selector, notification);
}

- (void)dealloc
{
    //NSLogD(@"%@", _name);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:_name object:nil];
}
    
@end

#pragma mark - NSObject (XYNotification)
@implementation NSObject (XYNotification)

uxy_staticConstString(NSObject_notifications)

- (id)uxy_notifications
{
    id object = [self uxy_getAssociatedObjectForKey:NSObject_notifications];
    
    if (nil == object)
    {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:4];
        [self uxy_setRetainAssociatedObject:dic forKey:NSObject_notifications];
        return dic;
    }
    
    return object;
}

- (void)uxy_registerNotification:(const char *)name
{
    NSString *str = [NSString stringWithUTF8String:name];
    SEL aSel = NSSelectorFromString([NSString stringWithFormat:@"__uxy_handleNotification_%@:", str]);
    if ([self respondsToSelector:aSel])
    {
        [self notificationWihtName:name target:self selector:aSel];
        return;
    }
}

- (void)uxy_registerNotification:(const char *)name block:(XYNotification_block)block
{
    [self notificationWihtName:name block:block];
}

- (void)notificationWihtName:(const char *)name target:(id)target selector:(SEL)selector
{
    NSString *str = [NSString stringWithUTF8String:name];
    XYNotification *notification = [[XYNotification alloc] initWithName:str sender:nil target:target selector:selector];
    
    NSString *key = [NSString stringWithFormat:@"%@", str];
    [self.uxy_notifications setObject:notification forKey:key];
}
- (void)notificationWihtName:(const char *)name block:(XYNotification_block)block
{
    NSString *str = [NSString stringWithUTF8String:name];
    XYNotification *notification = [[XYNotification alloc] initWithName:str sender:nil block:block];
    
    NSString *key = [NSString stringWithFormat:@"%@", str];
    [self.uxy_notifications setObject:notification forKey:key];
}

- (void)uxy_postNotification:(const char *)name userInfo:(id)userInfo
{
    NSString *str = [NSString stringWithUTF8String:name];
    [[NSNotificationCenter defaultCenter] postNotificationName:str object:self userInfo:userInfo];
}

- (void)uxy_unregisterNotification:(const char *)name
{
    NSString *key = [NSString stringWithFormat:@"%s", name];
    [self.uxy_notifications removeObjectForKey:key];
}

- (void)uxy_unregisterAllNotification
{
    [self.uxy_notifications removeAllObjects];
}

@end