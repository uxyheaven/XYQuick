//
//  XYRuntime.h
//  JoinShow
//
//  Created by Heaven on 14/11/13.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYRuntime : NSObject

/**
 * @brief 移魂大法
 * @param clazz 原方法的类
 * @param original 原方法
 * @param replacement 劫持后的方法
 */
+ (void)swizzleInstanceMethodWithClass:(Class)clazz originalSel:(SEL)original replacementSel:(SEL)replacement;

@end


#pragma mark -

#undef	uxy_class
#define	uxy_class( x )		NSClassFromString(@ #x)

#undef	uxy_instance
#define	uxy_instance( x )	[[NSClassFromString(@ #x) alloc] init]

#pragma mark -

@interface NSObject (uxyRuntime)

+ (NSArray *)uxy_subClasses;

+ (NSArray *)uxy_methods;
+ (NSArray *)uxy_methodsWithPrefix:(NSString *)prefix;
+ (NSArray *)uxy_methodsUntilClass:(Class)baseClass;
+ (NSArray *)uxy_methodsWithPrefix:(NSString *)prefix untilClass:(Class)baseClass;

+ (NSArray *)uxy_properties;
+ (NSArray *)uxy_propertiesUntilClass:(Class)baseClass;
+ (NSArray *)uxy_propertiesWithPrefix:(NSString *)prefix;
+ (NSArray *)uxy_propertiesWithPrefix:(NSString *)prefix untilClass:(Class)baseClass;

+ (NSArray *)uxy_classesWithProtocol:(NSString *)protocolName;

+ (void *)uxy_replaceSelector:(SEL)sel1 withSelector:(SEL)sel2;

@end