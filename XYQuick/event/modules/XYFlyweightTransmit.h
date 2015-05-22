//
//  XYFlyweightTransmit.h
//  JoinShow
//
//  Created by heaven on 15/5/22.
//  Copyright (c) 2015年 Heaven. All rights reserved.
//

#import <Foundation/Foundation.h>

// 解决a知道b,b不知道a, b传数据给a的情况

@interface NSObject (XYFlyweightTransmit)
@property (nonatomic, strong) id uxy_flyweightData;
- (void)uxy_receiveObject:(void(^)(id object))aBlock withIdentifier:(NSString *)identifier;
- (void)uxy_sendObject:(id)anObject withIdentifier:(NSString *)identifier;
- (void)uxy_handlerEventWithBlock:(id)aBlock withIdentifier:(NSString *)identifier;
- (id)uxy_blockForEventWithIdentifier:(NSString *)identifier;
@end

#pragma mark-
@protocol XYFlyweightTransmit <NSObject>

@property (nonatomic, strong) id uxy_flyweightData;

// 传递一个数据
- (void)uxy_receiveObject:(void(^)(id object))aBlock withIdentifier:(NSString *)identifier;
- (void)uxy_sendObject:(id)anObject withIdentifier:(NSString *)identifier;

// 设置一个block作为回调
- (void)uxy_handlerEventWithBlock:(id)aBlock withIdentifier:(NSString *)identifier;
- (id)uxy_blockForEventWithIdentifier:(NSString *)identifier;

@end


