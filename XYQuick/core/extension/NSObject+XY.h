//
//  NSObject+XY.h
//  JoinShow
//
//  Created by Heaven on 13-7-31.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (XY)

#pragma mark - perform

#pragma mark - property
// 属性列表
@property (nonatomic, readonly, strong) NSArray                *attributeList;

#pragma mark - Conversion
- (NSInteger)asInteger;
- (float)asFloat;
- (BOOL)asBool;

- (NSNumber *)asNSNumber;
- (NSString *)asNSString;
- (NSDate *)asNSDate;
- (NSData *)asNSData;	// TODO
- (NSArray *)asNSArray;
//- (NSArray *)asNSArrayWithClass:(Class)clazz;
- (NSMutableArray *)asNSMutableArray;
//-(NSMutableArray *) asNSMutableArrayWithClass:(Class)clazz;
- (NSDictionary *)asNSDictionary;
- (NSMutableDictionary *)asNSMutableDictionary;

#pragma mark- copy
// 基于NSKeyArchive.如果 self导入XYAutoCoding.h,可用与自定义对象
- (id)deepCopy1;

#pragma mark- associated
- (id)uxy_getAssociatedObjectForKey:(const char *)key;
- (id)uxy_copyAssociatedObject:(id)obj forKey:(const char *)key;
- (id)uxy_retainAssociatedObject:(id)obj forKey:(const char *)key;
- (id)uxy_assignAssociatedObject:(id)obj forKey:(const char *)key;
- (void)uxy_removeAssociatedObjectForKey:(const char *)key;
- (void)uxy_removeAllAssociatedObjects;

@end

#pragma mark - UXYFlyweightTransmit
@protocol UXYFlyweightTransmit

@property (nonatomic, strong) id uxy_tempObject;

// send object
// handle block with default identifier is @"sendObject".
- (void)uxy_receiveObject:(void(^)(id object))aBlock;
- (void)uxy_sendObject:(id)anObject;

//tag can't be nil
- (void)uxy_receiveObject:(void(^)(id object))aBlock withIdentifier:(NSString *)identifier;
- (void)uxy_sendObject:(id)anObject withIdentifier:(NSString *)identifier;

// handle block with default identifier is @"EventBlock".
- (void)uxy_handlerDefaultEventWithBlock:(id)aBlock;
- (id)uxy_blockForDefaultEvent;

// 设置一个block作为回调
- (void)uxy_handlerEventWithBlock:(id)aBlock withIdentifier:(NSString *)identifier;
- (id)uxy_blockForEventWithIdentifier:(NSString *)identifier;

@end





