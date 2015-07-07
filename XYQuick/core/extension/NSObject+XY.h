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
@end

#pragma mark- XY_associated
#define uxy_property_as_associated_strong( __type, __name) \
        @property (nonatomic, strong, setter=set__##__name:, getter=__##__name) __type __name;

#define uxy_property_def_associated_strong( __type, __name) \
        - (__type)__##__name   \
        { return [self uxy_getAssociatedObjectForKey:#__name]; }   \
        - (void)set__##__name:(id)__##__name   \
        { [self uxy_retainAssociatedObject:__##__name forKey:#__name]; }

#define uxy_property_as_associated_weak( __type, __name) \
        @property (nonatomic, weak, setter=set__##__name:, getter=__##__name) __type __name;

#define uxy_property_def_associated_weak( __type, __name) \
        - (__type)__##__name   \
        { return [self uxy_getAssociatedObjectForKey:#__name]; }   \
        - (void)set__##__name:(id)__##__name   \
        { [self uxy_retainAssociatedObject:__##__name forKey:#__name]; }


#define uxy_property_as_associated_copy( __type, __name) \
        @property (nonatomic, copy, setter=set__##__name:, getter=__##__name) __type __name;

#define uxy_property_def_associated_copy( __type, __name) \
        - (__type)__##__name   \
        { return [self uxy_copyAssociatedObject:#__name]; }   \
        - (void)set__##__name:(id)__##__name   \
        { [self uxy_copyAssociatedObject:__##__name forKey:#__name]; }

#define uxy_property_as_associated_retain( __type, __name) \
        @property (nonatomic, retain, setter=set__##__name:, getter=__##__name) __type __name;

#define uxy_property_def_associated_retain( __type, __name) \
        - (__type)__##__name   \
        { return [self uxy_retainAssociatedObject:#__name]; }   \
        - (void)set__##__name:(id)__##__name   \
        { [self uxy_retainAssociatedObject:__##__name forKey:#__name]; }

#define uxy_property_as_associated_assign( __type, __name) \
        @property (nonatomic, assign, setter=set__##__name:, getter=__##__name) __type __name;

#define uxy_property_def_associated_assign( __type, __name) \
        - (__type)__##__name   \
        { return [self uxy_getAssociatedObjectForKey:#__name]; }   \
        - (void)set__##__name:(id)__##__name   \
        { [self uxy_assignAssociatedObject:__##__name forKey:#__name]; }

@interface NSObject (XY_associated)
- (id)uxy_getAssociatedObjectForKey:(const char *)key;
- (id)uxy_copyAssociatedObject:(id)obj forKey:(const char *)key;
- (id)uxy_retainAssociatedObject:(id)obj forKey:(const char *)key;
- (id)uxy_assignAssociatedObject:(id)obj forKey:(const char *)key;
- (void)uxy_removeAssociatedObjectForKey:(const char *)key;
- (void)uxy_removeAllAssociatedObjects;
@end


