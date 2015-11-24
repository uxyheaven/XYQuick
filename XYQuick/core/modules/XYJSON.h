//
//  __  __          ____           _          _
//  \ \/ / /\_/\   /___ \  _   _  (_)   ___  | | __
//   \  /  \_ _/  //  / / | | | | | |  / __| | |/ /
//   /  \   / \  / \_/ /  | |_| | | | | (__  |   <
//  /_/\_\  \_/  \___,_\   \__,_| |_|  \___| |_|\_\
//
//  Copyright (C) Heaven.
//
//	https://github.com/uxyheaven/XYQuick
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.
//
//  This file Copy from YYJSONHelper.

#import "XYQuick_Predefine.h"
#pragma mark -

#define JSON_string_options NSJSONReadingAllowFragments

/*
 在kvc中, 字串类型 可以被转化成基本的 数值类型,
 所以在设计实体数据类的时候,如果属性是int bool float double, 无论服务器的值是字串还是数值,都可以转换成数值类型
 */


#pragma mark - XYJSONAutoBinding
/**
 * 通过 Protocol 免去NSArray 手动bind
 * @interface AudioPartModel : NSObject
 * @protocol AudioPartModel @end
 * @property(strong, nonatomic) NSArray	<AudioPartModel> *audioParts;
 *
 * 通过 Protocol 免去id 手动bind
 * @interface Man : NSObject <XYJSONAutoBinding> @end
 * @property(strong, nonatomic) Man *man;
 */
@protocol XYJSONAutoBinding
@end

@interface NSObject (XYJSON_2)
@property (nonatomic, assign) BOOL uxy_keepJOSNObjectCache;     // JSON对象缓存, 默认关闭. 在需要用KeyPath解析多个对象的时候可以开启, 以提高效率

+ (BOOL)uxy_hasSuperProperties;
+ (NSDictionary *)uxy_JSONKeyProperties;
+ (void)uxy_bindJSONKey:(NSString *)JSONKey toProperty:(NSString *)property;
+ (void)uxy_removeJSONKeyWithProperty:(NSString *)property;

- (id)uxy_toModel:(Class)classType __deprecated_msg("New method is `uxy_JSONObjectAtClass:`");
- (id)uxy_toModel:(Class)classType forKey:(NSString *)JSONKey __deprecated_msg("New method is `uxy_JSONObjectAtClass:forKeyPath:`");
- (NSArray *)uxy_toModels:(Class)classType __deprecated_msg("New method is `uxy_JSONObjectAtClass:`");
- (NSArray *)uxy_toModels:(Class)classType forKey:(NSString *)JSONKey __deprecated_msg("New method is `uxy_JSONObjectAtClass:forKeyPath:`");

@end

@interface NSString (XYJSON_2)
- (NSString *)uxy_JSONString;
- (NSData *)uxy_JSONData;
- (id)uxy_JSONObject;
- (NSDictionary *)uxy_JSONDictionary;
- (id)uxy_JSONObjectAtClass:(Class)classType;
- (id)uxy_JSONObjectAtClass:(Class)classType forKeyPath:(NSString *)keyPath;
@end

@interface NSData (XYJSON_2)
- (NSString *)uxy_JSONString;
- (NSData *)uxy_JSONData;
- (id)uxy_JSONObject;
- (NSDictionary *)uxy_JSONDictionary;
- (id)uxy_JSONObjectAtClass:(Class)classType;
- (id)uxy_JSONObjectAtClass:(Class)classType forKeyPath:(NSString *)keyPath;
@end

@interface NSDictionary (XYJSON_2)
- (NSString *)uxy_JSONString;
- (NSData *)uxy_JSONData;
- (id)uxy_JSONObjectAtClass:(Class)classType;
- (id)uxy_JSONObjectAtClass:(Class)classType forKeyPath:(NSString *)keyPath;
@end

@interface NSArray (XYJSON_2)
- (NSString *)uxy_JSONString;
- (NSData *)uxy_JSONData;
- (id)uxy_JSONObjectAtClass:(Class)classType;
- (id)uxy_JSONObjectAtClass:(Class)classType forKeyPath:(NSString *)keyPath;
@end

#pragma mark - NSObject (XYJSON)
@interface NSObject (XYJSON)

/**
 * @brief 如果model需要取父类的属性，那么需要自己实现这个方法，并且返回YES
 */
+ (BOOL)uxy_hasSuperProperties;

/**
 * @brief 映射好的字典 {JSONkey:property}
 */
+ (NSDictionary *)uxy_JSONKeyProperties;

/**
 * @brief 自己绑定JSONkey和property
 * @brief 如果没有自己绑定，默认为 {JSONkey:property}, 其中JSONkey=property
 */
+ (void)uxy_bindJSONKey:(NSString *)JSONKey toProperty:(NSString *)property;

/**
 * @brief 解除不需要解析的属性
 */
+ (void)uxy_removeJSONKeyWithProperty:(NSString *)property;

// model to JSON
/**
 * @brief 返回JSONString
 */
- (NSString *)uxy_JSONString;

/**
 * @brief 返回JSONData
 */
- (NSData *)uxy_JSONData;

/**
 * @brief 对象返回JSON字典, 不支持NSArray
 */
- (NSDictionary *)uxy_JSONDictionary;

// JSON to model
- (id)uxy_toModel:(Class)classType;
- (id)uxy_toModel:(Class)classType forKey:(NSString *)JSONKey;
- (NSArray *)uxy_toModels:(Class)classType;
- (NSArray *)uxy_toModels:(Class)classType forKey:(NSString *)JSONKey;

@end


#pragma mark - NSString (XYJSON)
@interface NSString (XYJSON)
- (id)uxy_JSONValue;

/**
 *   @brief  解析结果直接在parser的result字段里面，这个方法主要是为了提高解析的效率
 *   如果一个JSON中有多个key ex：{用户列表，商品列表、打折列表}那么传3个解析器进来就好了，不会对data进行三次重复的解析操作
 *   @param  parsers 要解析为JSON的解析器(XYJSONParser)集合
 */
- (void)uxy_parseToObjectWithParsers:(NSArray *)parsers;
@end

#pragma mark - NSDictionary (XYJSON)
@interface NSDictionary (XYJSON)
@end

#pragma mark - NSData (XYJSON)
@interface NSData (XYJSON)

- (id)uxy_JSONValue;

/**
 *   @brief  通过key拿到JSON数据
 */
- (id)uxy_JSONValueForKeyPath:(NSString *)key;

/**
 *   @brief  通过key集合拿到对应的key的JSON数据字典
 */
- (NSDictionary *)uxy_dictionaryForKeyPaths:(NSArray *)keys;

/**
 *   @brief  解析结果直接在parser的result字段里面，这个方法主要是为了提高解析的效率
 *   如果一个JSON中有多个key ex：{用户列表，商品列表、打折列表}那么传3个解析器进来就好了，不会对data进行三次重复的解析操作
 *   @param  parsers 要解析为JSON的解析器(XYJSONParser)集合
 */
- (void)uxy_parseToObjectWithParsers:(NSArray *)parsers;

@end

#pragma mark - NSArray (XYJSON)
@interface NSArray (XYJSON)
- (NSArray *)uxy_toModels:(Class)classType;
@end

#pragma mark - XYJSONParser
@interface XYJSONParser : NSObject

@property(nonatomic, strong) Class clazz;   // 要转换成什么class
@property(nonatomic, copy) NSString *key; // key
@property(nonatomic, strong) id result;     // 结果
@property(nonatomic, readonly, weak) id smartResult;

- (instancetype)initWithKey:(NSString *)key clazz:(Class)clazz;
+ (instancetype)objectWithKey:(NSString *)key clazz:(Class)clazz;

@end

@interface XYJSONParser_2 : NSObject

+ (instancetype)sharedInstance;

@end





