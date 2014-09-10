//
//  XYJSONHelper.h
//  JoinShow
//
//  Created by Heaven on 14-9-9.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//
//  Copy from YYJSONHelper

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#define Json_string_options 0


@interface XYJSONHelper : NSObject

@end

#pragma mark - XYJSONHelperProtocol
@protocol XYJSONHelperProtocol
/*
 * 通过 Protocol 免去NSArray 手动bind
 * @property(strong, nonatomic) NSArray	<AudioPartModel> *audioParts;
 * @property(strong, nonatomic) Man <XYJSONHelperProtocol> *man;
*/
 @end


#pragma mark - NSObject (XYJSONHelper)
@interface NSObject (XYJSONHelper)

/**
 * @brief 如果model需要取父类的属性，那么需要自己实现这个方法，并且返回YES
 */
+ (BOOL)hasSuperProperties;

/**
 * @brief 映射好的字典 {jsonkey:property}
 */
+ (NSDictionary *)XYJSONKeyDict;

/**
 * @brief 自己绑定jsonkey和property
 * @brief 如果没有自己绑定，默认为 {jsonkey:property} 【jsonkey=property】
 */
+ (void)bindXYJSONKey:(NSString *)jsonKey toProperty:(NSString *)property;

/**
 * @brief 返回jsonString
 */
- (NSString *)XYJSONString;

/**
 * @brief 返回jsonData
 */
- (NSData *)XYJSONData;

/**
 * @brief 返回json字典, 不支持NSArray
 */
- (NSDictionary *)XYJSONDictionary;
@end


#pragma mark - NSString (XYJSONHelper)
@interface NSString (XYJSONHelper)
- (id)toModel:(Class)modelClass;

- (id)toModel:(Class)modelClass forKey:(NSString *)jsonKey;

- (NSArray *)toModels:(Class)modelClass;

- (NSArray *)toModels:(Class)modelClass forKey:(NSString *)jsonKey;

- (id)JSONValue;

@end

#pragma mark - NSDictionary (XYJSONHelper)
@interface NSDictionary (XYJSONHelper)
/**
 * @brief jsonString
 */
- (NSString *)XYJSONString;

- (id)__objectForKey:(id)key;

@end

#pragma mark - NSData (XYJSONHelper)
@interface NSData (XYJSONHelper)
/**
 * @brief 传入modelClass，返回对应的实例
 */
- (id)toModel:(Class)modelClass;

/**
 * @brief 传入modelClass和json的key，返回对用的实例
 */
- (id)toModel:(Class)modelClass forKey:(NSString *)key;

/**
 * @brief 传入modelClass，返回对应的实例集合
 */
- (NSArray *)toModels:(Class)modelClass;

/**
 * @brief 传入modelClass和key，返回对应的实例集合
 */
- (NSArray *)toModels:(Class)modelClass forKey:(NSString *)key;

/**
 * @brief 返回jsonString
 */
- (NSString *)XYJSONString;
@end

#pragma mark - NSArray (XYJSONHelper)
@interface NSArray (XYJSONHelper)
/**
 * @brief 返回jsonString
 */
- (NSString *)XYJSONString;

/**
 * @brief 返回jsonData
 */
- (NSData *)XYJSONData;

@end





