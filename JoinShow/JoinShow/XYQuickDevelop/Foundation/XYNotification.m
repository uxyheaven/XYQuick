//
//  XYNotification.m
//  JoinShow
//
//  Created by Heaven on 14-6-3.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import "XYNotification.h"
#import "XYPrecompile.h"

void (*XYNotification_action)(id, SEL, ...) = (void (*)(id, SEL, ...))objc_msgSend;


#pragma mark - XYNotification
@interface XYNotification ()

@property (nonatomic, weak) id target;                  //
@property (nonatomic, assign) SEL selector;             //
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) id sender;                // 来源
@property (nonatomic, strong) id userInfo;

@property (nonatomic, copy) XYNotification_block block;

@end

@implementation XYNotification

-(instancetype) initWithName:(NSString *)name sender:(id)sender target:(id)target selector:(SEL)selector;
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

-(instancetype) initWithName:(NSString *)name sender:(id)sender block:(XYNotification_block)block
{
    self = [super init];
    if (self)
    {
        _name   = name;
        _sender = sender;
        _block  = block;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleNotification:)                                                            name:name                                                            object:sender];
    }
    
    return self;
}

- (void)handleNotification:(NSNotification *) notification
{
    if (_block)
    {
        _block(notification);
        return;
    }
    
    XYNotification_action(_target, _selector, notification);
}

- (void)dealloc
{
    //NSLogD(@"%@", _name);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:_name object:nil];
}
    
@end

#pragma mark - NSObject (XYNotification)
@implementation NSObject (XYNotification)

@dynamic notifications;

- (id)notifications{
    id object = objc_getAssociatedObject(self, NSObject_notifications);
    
    if (nil == object)
    {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:8];
        objc_setAssociatedObject(self, NSObject_notifications, dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return dic;
    }
    
    return object;
}

- (void)registerNotification:(NSString *)name
{
    SEL aSel = NSSelectorFromString([NSString stringWithFormat:@"%@NotificationHandle:", name]);
    if ([self respondsToSelector:aSel])
    {
        [self notificationWihtName:name target:self selector:aSel];
        return;
    }
}

- (void)registerNotification:(NSString *)name block:(XYNotification_block)block
{
    [self notificationWihtName:name block:block];
}

- (void)notificationWihtName:(NSString *)name target:(id)target selector:(SEL)selector
{
    XYNotification *notification = [[XYNotification alloc] initWithName:name sender:nil target:target selector:selector];
    
    NSString *key = [NSString stringWithFormat:@"%@", name];
    [self.notifications setObject:notification forKey:key];
}
- (void)notificationWihtName:(NSString *)name block:(XYNotification_block)block
{
    XYNotification *notification = [[XYNotification alloc] initWithName:name sender:nil block:block];
    
    NSString *key = [NSString stringWithFormat:@"%@", name];
    [self.notifications setObject:notification forKey:key];
}

- (void)postNotification:(NSString *)name userInfo:(id)userInfo
{
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:self userInfo:userInfo];
}

- (void)unregisterNotification:(NSString*)name
{
     NSString *key = [NSString stringWithFormat:@"%@", name];
    [self.notifications removeObjectForKey:key];
}

- (void)unregisterAllNotification
{
    [self.notifications removeAllObjects];
}

@end