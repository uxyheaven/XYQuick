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
 * 通过 Protocol 确定 NSArray 解析的类
 * uxy_as_JSONAutoParse(Man)
 * uxy_def_JSONAutoParse(Man)
 *
 * @property(strong, nonatomic) NSArray <Man> *users;
 *
 * 通过 Protocol 确定属性用来解析的类
 * uxy_as_JSONAutoParse(Man)
 * uxy_def_JSONAutoParse(Man)
 *
 * @property(strong, nonatomic) Man <Man> *man;
 */
@protocol XYJSONAutoBinding <NSObject> @end

#define uxy_as_JSONAutoParse( __name ) \
        @protocol __name <XYJSONAutoBinding> @end   \

#define uxy_def_JSONAutoParse( __name ) \
        @interface XYJSONAutoBinding_##__name : NSObject <__name> @end   \
        @implementation XYJSONAutoBinding_##__name @end

@interface NSObject (XYJSON_2)

/**
 * @brief 如果model需要取父类的属性，那么需要自己实现这个方法，并且返回YES
 */
+ (BOOL)uxy_hasSuperProperties;

/// @brief 为属性添加别名, 处理服务器返回的时候key起名和native的属性不对应问题
+ (void)uxy_addNickname:(NSString *)nicename forProperty:(NSString *)property;

/// 返回对象的JSON字串
//- (NSString *)uxy_JSONString;

@end


@interface NSData (XYJSON_2)

/// 是否保持JSON对象缓存, 默认关闭. 在需要用KeyPath解析多个对象的时候可以开启, 以提高效率
@property (nonatomic, assign) BOOL uxy_keepJSONObjectCache;
/// JSON对象缓存
@property (nonatomic, strong) id uxy_JSONObjectCache;


/// 返回JSON字串
- (NSString *)uxy_JSONString;

/// 返回JSON对象
- (id)uxy_JSONObject;

// JSON to Model
- (id)uxy_JSONObjectByClass:(Class)classType;
- (id)uxy_JSONObjectByClass:(Class)classType forKeyPath:(NSString *)keyPath;

@end

@interface NSString (XYJSON_2)
/// 是否保持JSON对象缓存, 默认关闭. 在需要用KeyPath解析多个对象的时候可以开启, 以提高效率
@property (nonatomic, assign) BOOL uxy_keepJSONObjectCache;
/// JSON对象缓存
@property (nonatomic, strong) id uxy_JSONObjectCache;

/// 返回JSON对象
- (id)uxy_JSONObject;

// JSON to Model
- (id)uxy_JSONObjectByClass:(Class)classType;
- (id)uxy_JSONObjectByClass:(Class)classType forKeyPath:(NSString *)keyPath;

@end

@interface NSDictionary (XYJSON_2)
- (NSString *)uxy_JSONString;
- (NSData *)uxy_JSONData;
@end

@interface NSArray (XYJSON_2)
@end

