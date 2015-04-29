//
//  XCModuleCooperative.m
//  xcar
//
//  Created by heaven on 15/4/29.
//  Copyright (c) 2015年 heaven. All rights reserved.
//

#import "XYModuleCooperative.h"


@implementation XYModuleCooperativeInterface
@end

@implementation XYModuleCooperativeEvent

- (void)dealloc
{
    NSLog(@"%s, %@",__FUNCTION__, _interface.identifier);
}

@end


@interface XYModuleCooperative ()

@property (nonatomic, strong) NSMutableDictionary *moduleInterfaces;

@end

@implementation XYModuleCooperative __DEF_SINGLETON

- (instancetype)init
{
    self = [super init];
    if (self) {
        _moduleInterfaces = [@{} mutableCopy];
    }
    return self;
}

// 注册一个数据标识
- (void)registerDataIdentifier:(NSString *)identifier target:(id <XYModuleCooperativeProtocol>)target
{
    if ([target conformsToProtocol:@protocol(XYModuleCooperativeProtocol)])
        return;
    
    XYModuleCooperativeInterface *mi = _moduleInterfaces[identifier];
    if (mi == nil)
    {
        mi = [[XYModuleCooperativeInterface alloc] init];
    }
    
    mi.target = target;
    mi.identifier = identifier;
    
    _moduleInterfaces[identifier] = mi;
}

// 获取数据
- (XYModuleCooperativeEvent *)invocationDataIndentifier:(NSString *)identifier
                                         completedBlock:(XYModuleCooperativeCompletedBlock)block
{
    XYModuleCooperativeInterface *mi = _moduleInterfaces[identifier];
    XYModuleCooperativeEvent *event = [[XYModuleCooperativeEvent alloc] init];
    event.interface = mi;
    event.completedBlock = block;
    // NSError *error = [NSError errorWithDomain:NSStringFromClass([self class]) code:0 userInfo:nil];
    
    if (mi == nil)
    {
        event.error = [NSError errorWithDomain:NSStringFromClass([self class]) code:0 userInfo:(NSDictionary *)@"XCModuleCooperativeInterface == nil"];
        event.completedBlock(event);
        return event;
    }
    
    if (mi.target == nil)
    {
        event.error = [NSError errorWithDomain:NSStringFromClass([self class]) code:0 userInfo:(NSDictionary *)@"XCModuleCooperativeInterface == nil"];
        event.completedBlock(event);
        return event;
    }
    
    NSString *tmpIndentifer = mi.identifier;
    
    NSMethodSignature *signature = [[mi.target class] methodSignatureForSelector:@selector(XYModuleCooperativeWithDataIdentifier:event:)];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    
    [invocation setTarget:mi.target];
    [invocation setSelector:@selector(XYModuleCooperativeWithDataIdentifier:event:)];
    [invocation setArgument:&tmpIndentifer atIndex:2];
    [invocation setArgument:&event atIndex:3];
    [invocation invoke];

    if (!event.isAsync)
    {
        event.completedBlock(event);
    }

    return event;
}

@end
