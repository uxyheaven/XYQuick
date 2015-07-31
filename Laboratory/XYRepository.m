//
//  XCRepository.m
//  xcar
//
//  Created by heaven on 15/4/29.
//  Copyright (c) 2015年 heaven. All rights reserved.
//

#import "XYRepository.h"


@implementation XYRepositoryInterface
@end

@implementation XYRepositoryEvent

- (void)dealloc
{
    NSLog(@"%s, %@",__FUNCTION__, _interface.identifier);
}

@end

#pragma mark -
@implementation Aggregate
@end

#pragma mark -
static NSMutableDictionary *repositories;
@interface XYRepository ()

@property (nonatomic, strong) NSMutableDictionary *moduleInterfaces;
@property (nonatomic, strong) NSMutableDictionary *aggregates;
@property (nonatomic, copy) NSString *domain;

@end

@implementation XYRepository __DEF_SINGLETON

- (instancetype)init
{
    self = [super init];
    if (self) {
       // _moduleInterfaces = [@{} mutableCopy];
        _aggregates = [@{} mutableCopy];
    }
    return self;
}

- (instancetype)initWithDomain:(NSString *)name
{
    self = [self init];
    if (self) {
        _domain = name;
    }
    return self;
}
/*
// 注册一个数据标识
- (void)registerDataAtIdentifier:(NSString *)identifier receiver:(id <XYRepositoryProtocol>)receiver
{
    if ([receiver conformsToProtocol:@protocol(XYRepositoryProtocol)])
        return;
    
    XYRepositoryInterface *mi = _moduleInterfaces[identifier];
    if (mi == nil)
    {
        mi = [[XYRepositoryInterface alloc] init];
    }
    
    mi.receiver = receiver;
    mi.identifier = identifier;
    
    _moduleInterfaces[identifier] = mi;
}

- (void)registerDataAtIdentifier:(NSString *)identifier receiverClassName:(NSString *)className
{
    Class clazz = NSClassFromString(className);
    
    if (clazz == nil)
        return;
    
    XYRepositoryInterface *mi = _moduleInterfaces[identifier];
    if (mi == nil)
    {
        mi = [[XYRepositoryInterface alloc] init];
    }
    
    mi.receiverClass = clazz;
    mi.identifier = identifier;
    
    _moduleInterfaces[identifier] = mi;
}


// 获取数据
- (XYRepositoryEvent *)invocationDataIndentifier:(NSString *)identifier
                                         completedBlock:(XYRepositoryCompletedBlock)block
{
    XYRepositoryInterface *mi = _moduleInterfaces[identifier];
    XYRepositoryEvent *event = [[XYRepositoryEvent alloc] init];
    event.interface = mi;
    event.completedBlock = block;
    // NSError *error = [NSError errorWithDomain:NSStringFromClass([self class]) code:0 userInfo:nil];
    
    if (mi == nil)
    {
        event.error = [NSError errorWithDomain:NSStringFromClass([self class]) code:0 userInfo:(NSDictionary *)@"XCRepositoryInterface == nil"];
        event.completedBlock(event);
        return event;
    }
    
    if (mi.receiver == nil)
    {
        event.error = [NSError errorWithDomain:NSStringFromClass([self class]) code:0 userInfo:(NSDictionary *)@"XCRepositoryInterface == nil"];
        event.completedBlock(event);
        return event;
    }
    
    NSString *tmpIndentifer = mi.identifier;
    id target = mi.receiver;
 if (target == nil && [mi.receiverClass respondsToSelector:@selector(sharedInstance)+ (instancetype)repositoryWithDomain:(NSString *)name;
 - (instancetype)initWithDomain:(NSString *)name;])
    {
        target = [mi.receiverClass sharedInstance];
        mi.receiver = target;
    }
    
    NSMethodSignature *signature = [[target class] methodSignatureForSelector:@selector(XYRepositoryWithDataIdentifier:event:)];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    
    [invocation setTarget:target];
    [invocation setSelector:@selector(XYRepositoryWithDataIdentifier:event:)];
    [invocation setArgument:&tmpIndentifer atIndex:2];
    [invocation setArgument:&event atIndex:3];
    [invocation invoke];

    if (!event.isAsync)
    {
        event.completedBlock(event);
    }

    return event;
}
*/

+ (instancetype)repositoryWithDomain:(NSString *)domain
{
    UNUSED(repositories      ?: (repositories = [@{} mutableCopy]))
    NSString *key = domain   ?: @"";
    
    return repositories[key] ?: ({
        repositories[key] = [[XYRepository alloc] initWithDomain:key];
        repositories[key];
    });
}

- (Aggregate *)aggregateForKey:(NSString *)key
{
    return _aggregates[key];
}

- (void)setAnAggregateRoot:(id)root forKey:(NSString *)key
{
    UNUSED(repositories[key] ?: (repositories[key] = [[Aggregate alloc] init]))
    [repositories[key] setValue:root forKey:@"root"];
}

- (void)removeAggregateForKey:(NSString *)key
{
    [_aggregates removeObjectForKey:key];
}
@end
