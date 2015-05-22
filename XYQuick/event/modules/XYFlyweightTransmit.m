//
//  XYFlyweightTransmit.m
//  JoinShow
//
//  Created by heaven on 15/5/22.
//  Copyright (c) 2015年 Heaven. All rights reserved.
//

#import "XYFlyweightTransmit.h"
#import "XYQuick_Predefine.h"

#pragma mark - UXYFlyweightTransmit
#define NSObject_key_flyweightData	"UXY.NSObject.flyweightData"
#define NSObject_key_objectDic	"UXY.NSObject.objectDic"
#define NSObject_key_eventBlockDic	"UXY.NSObject.eventBlockDic"

@implementation NSObject (UXYFlyweightTransmit)

- (id)uxy_flyweightData
{
    return objc_getAssociatedObject(self, NSObject_key_flyweightData);
}

- (void)setUxy_flyweightData:(id)flyweightData
{
    [self willChangeValueForKey:@"uxy_flyweightData"];
    objc_setAssociatedObject(self, NSObject_key_flyweightData, flyweightData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"uxy_flyweightData"];
}


- (void)uxy_receiveObject:(void(^)(id object))aBlock withIdentifier:(NSString *)identifier
{
    NSString *key = identifier ?: @"uxy_sendObject";
    NSMutableDictionary *dic = objc_getAssociatedObject(self, NSObject_key_objectDic);
    if(dic == nil)
    {
        dic = [NSMutableDictionary dictionaryWithCapacity:4];
        objc_setAssociatedObject(self, NSObject_key_objectDic, dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    [dic setObject:[aBlock copy] forKey:key];
}

- (void)uxy_sendObject:(id)anObject withIdentifier:(NSString *)identifier
{
    NSString *key = identifier ?: @"uxy_sendObject";
    NSDictionary *dic = objc_getAssociatedObject(self, NSObject_key_objectDic);
    if(dic == nil)
    {
        return;
    }
    
    void(^aBlock)(id anObject) = [dic objectForKey:key];
    aBlock(anObject);
}

- (void)uxy_handlerEventWithBlock:(id)aBlock withIdentifier:(NSString *)identifier
{
    NSString *key = identifier ?: @"uxy_handlerEvent";
    NSMutableDictionary *dic = objc_getAssociatedObject(self, NSObject_key_eventBlockDic);
    if(dic == nil)
    {
        dic = [NSMutableDictionary dictionaryWithCapacity:4];
        objc_setAssociatedObject(self, NSObject_key_eventBlockDic, dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    [dic setObject:[aBlock copy] forKey:key];
}

- (id)uxy_blockForEventWithIdentifier:(NSString *)identifier
{
    NSString *key = identifier ?: @"uxy_handlerEvent";
    NSDictionary *dic = objc_getAssociatedObject(self, NSObject_key_eventBlockDic);
    if(dic == nil)
        return nil;
    
    return [dic objectForKey:key];
}

@end;