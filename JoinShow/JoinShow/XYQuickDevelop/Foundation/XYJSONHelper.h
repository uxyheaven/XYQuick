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

#define Json_string_options NSJSONReadingAllowFragments


/*
 在kvc中, 字串 可以被转化成基本的 数值类型,
 所以在设计实体数据类的时候,如果属性是int bool float double, 无论服务器的值是字串还是数值,都可以转换成数值类型
 */


#pragma mark - XYJSONParser
@interface XYJSONParser : NSObject
@property(nonatomic, strong) Class clazz;   // 要转换成什么class
@property(nonatomic, assign) BOOL single;   // 是否单个
@property(nonatomic, copy) NSString *key; // key
@property(nonatomic, strong) id result;     // 结果
@property(nonatomic, readonly) id smartResult;

- (instancetype)initWithKey:(NSString *)key clazz:(Class)clazz single:(BOOL)single;

+ (instancetype)objectWithKey:(NSString *)key clazz:(Class)clazz single:(BOOL)single;

+ (instancetype)objectWithKey:(NSString *)key clazz:(Class)clazz;

@end

#pragma mark - XYJSONHelper
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
 * @brief 解除不需要解析的属性
 */
+ (void)removeXYJSONKeyWithProperty:(NSString *)property;

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


- (id)toModel:(Class)modelClass;

- (id)toModel:(Class)modelClass forKey:(NSString *)jsonKey;

- (NSArray *)toModels:(Class)modelClass;

- (NSArray *)toModels:(Class)modelClass forKey:(NSString *)jsonKey;

@end


#pragma mark - NSString (XYJSONHelper)
@interface NSString (XYJSONHelper)

- (id)JSONValue;

@end

#pragma mark - NSDictionary (XYJSONHelper)
@interface NSDictionary (XYJSONHelper)

- (id)__objectForKey:(id)key;

@end

#pragma mark - NSData (XYJSONHelper)
@interface NSData (XYJSONHelper)

/**
 *   @brief  通过key拿到json数据
 */
- (id)valueForJsonKey:(NSString *)key;

/**
 *   @brief  通过key集合拿到对应的key的json数据字典
 */
- (NSDictionary *)dictForJsonKeys:(NSArray *)keys;

/**
 *   @brief  解析结果直接在parser的result字段里面，这个方法主要是为了提高解析的效率
 *   如果一个json中有多个key ex：{用户列表，商品列表、打折列表}那么传3个解析器进来就好了，不会对data进行三次重复的解析操作
 *   @param  parsers 要解析为json的解析器集合
 */

- (void)parseToObjectWithParsers:(NSArray *)parsers;

- (id)JSONValue;

@end

#pragma mark - NSArray (XYJSONHelper)
@interface NSArray (XYJSONHelper)

- (NSArray *)toModels:(Class)modelClass;

@end





