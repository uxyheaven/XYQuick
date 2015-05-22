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

#pragma mark - conversion
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
- (id)deepCopy1; // 基于NSKeyArchive

#pragma mark- associated
- (id)uxy_getAssociatedObjectForKey:(const char *)key;
- (id)uxy_copyAssociatedObject:(id)obj forKey:(const char *)key;
- (id)uxy_retainAssociatedObject:(id)obj forKey:(const char *)key;
- (id)uxy_assignAssociatedObject:(id)obj forKey:(const char *)key;
- (void)uxy_removeAssociatedObjectForKey:(const char *)key;
- (void)uxy_removeAllAssociatedObjects;

@end


