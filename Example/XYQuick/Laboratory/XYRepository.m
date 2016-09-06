//
//  XCRepository.m
//  xcar
//
//  Created by heaven on 15/4/29.
//  Copyright (c) 2015年 heaven. All rights reserved.
//

#import "XYRepository.h"
#import <objc/runtime.h>

@implementation XYRepositoryInterface
@end

@implementation XYRepositoryEvent

- (void)dealloc
{
//    NSLogD(@"%s, %@", __FUNCTION__, _interface.identifier);
}

@end

#pragma mark -
@implementation XYAggregate
@end

#pragma mark -
static NSMutableDictionary *s_repositories;
static NSMutableDictionary *s_moduleInterfaces;
@interface XYRepository ()

@property (nonatomic, strong) NSMutableDictionary *aggregates;
@property (nonatomic, copy) NSString *domain;

@end

@implementation XYRepository

+ (void)load
{
    s_moduleInterfaces = [@{} mutableCopy];
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}

- (instancetype)initWithDomain:(NSString *)name
{
    self = [self init];
    if (self)
    {
        _domain = name;
    }
    return self;
}

// 注册一个数据标识
- (void)registerDataAtIdentifier:(NSString *)identifier receiver:(id <XYRepositoryProtocol>)receiver
{
    if (![receiver conformsToProtocol:@protocol(XYRepositoryProtocol)])
    {
        return;
    }

    XYRepositoryInterface *mi = s_moduleInterfaces[identifier];
    if (mi == nil)
    {
        mi = [[XYRepositoryInterface alloc] init];
    }

    mi.receiver   = receiver;
    mi.identifier = identifier;

    s_moduleInterfaces[identifier] = mi;
}

- (void)registerDataAtIdentifier:(NSString *)identifier receiverClassName:(NSString *)className
{
    Class clazz = NSClassFromString(className);

    if (clazz == nil)
    {
        return;
    }

    XYRepositoryInterface *mi = s_moduleInterfaces[identifier];
    if (mi == nil)
    {
        mi = [[XYRepositoryInterface alloc] init];
    }

    mi.receiverClass = clazz;
    mi.identifier    = identifier;

    s_moduleInterfaces[identifier] = mi;
}

// 获取数据
- (XYRepositoryEvent *)invocationDataIndentifier:(NSString *)identifier
                                  completedBlock:(XYRepositoryCompletedBlock)block
{
    XYRepositoryInterface *mi = s_moduleInterfaces[identifier];
    XYRepositoryEvent *event  = [[XYRepositoryEvent alloc] init];
    event.interface      = mi;
    event.completedBlock = block;

    if (mi == nil)
    {
        event.error = [NSError errorWithDomain:NSStringFromClass([self class])
                                          code:0
                                      userInfo:(NSDictionary *)@"XCRepositoryInterface == nil"];
        event.completedBlock(event);
        return event;
    }

    if (mi.receiver == nil)
    {
        event.error = [NSError errorWithDomain:NSStringFromClass([self class])
                                          code:0
                                      userInfo:(NSDictionary *)@"XCRepositoryInterface == nil"];
        event.completedBlock(event);
        return event;
    }

    NSString *tmpIndentifer = mi.identifier;
    id target               = mi.receiver;
    if (target == nil && [mi.receiverClass respondsToSelector:@selector(sharedInstance)])
    {
        target      = [mi.receiverClass performSelector:@selector(sharedInstance) withObject:nil];
        mi.receiver = target;
    }

    NSMethodSignature *signature = [[target class] methodSignatureForSelector:@selector(XYRepositoryWithDataIdentifier:event:)];
    NSInvocation *invocation     = [NSInvocation invocationWithMethodSignature:signature];

    [invocation setTarget:target];
    [invocation setSelector:@selector(XYRepositoryWithDataIdentifier:event:)];
    [invocation setArgument:&tmpIndentifer
                    atIndex:2];
    [invocation setArgument:&event
                    atIndex:3];
    [invocation invoke];

    if (!event.isAsync)
    {
        event.completedBlock(event);
    }

    return event;
}

+ (instancetype)repositoryWithDomain:(NSString *)domain
{
    UNUSED(s_repositories ? : (s_repositories = [@{} mutableCopy]))
    NSString * key = domain ? : @"";

    return s_repositories[key] ? : ({
        s_repositories[key] = [[XYRepository alloc] initWithDomain:key];
        s_repositories[key];
    });
}

- (XYAggregate *)aggregateForKey:(NSString *)key
{
    return _aggregates[key];
}

- (void)setAnAggregateRoot:(id)root forKey:(NSString *)key
{
    UNUSED(s_repositories[key] ? : (s_repositories[key] = [[XYAggregate alloc] init]))
    [s_repositories[key] setValue: root forKey: @"root"];
}

- (void)removeAggregateForKey:(NSString *)key
{
    [_aggregates removeObjectForKey:key];
}

@end
