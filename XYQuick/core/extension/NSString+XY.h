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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark -

@interface NSString (XY)

@property (nonatomic, readonly, strong) NSData *uxy_MD5Data;
@property (nonatomic, readonly, copy) NSString *uxy_MD5String;

@property (nonatomic, readonly, strong) NSData *uxy_SHA1Data;
@property (nonatomic, readonly, copy) NSString *uxy_SHA1String;

@property (nonatomic, readonly, copy) NSString *uxy_BASE64Decrypted;

@property (nonatomic, readonly, strong) NSData *uxy_data;

// url相关
- (NSArray *)uxy_allURLs;

- (NSString *)uxy_urlByAppendingDict:(NSDictionary *)params;
- (NSString *)uxy_urlByAppendingDict:(NSDictionary *)params encoding:(BOOL)encoding;
- (NSString *)uxy_urlByAppendingArray:(NSArray *)params;
- (NSString *)uxy_urlByAppendingArray:(NSArray *)params encoding:(BOOL)encoding;
- (NSString *)uxy_urlByAppendingKeyValues:(id)first, ...;

+ (NSString *)uxy_queryStringFromDictionary:(NSDictionary *)dict;
+ (NSString *)uxy_queryStringFromDictionary:(NSDictionary *)dict encoding:(BOOL)encoding;;
+ (NSString *)uxy_queryStringFromArray:(NSArray *)array;
+ (NSString *)uxy_queryStringFromArray:(NSArray *)array encoding:(BOOL)encoding;;
+ (NSString *)uxy_queryStringFromKeyValues:(id)first, ...;

- (NSString *)uxy_URLEncoding;      // 编码
- (NSString *)uxy_URLDecoding;      // 解码

- (NSMutableDictionary *)uxy_dictionaryFromQueryComponents;

// 去掉首尾的空格和换行
- (NSString *)uxy_trim;
// 去掉首尾的 " '
- (NSString *)uxy_unwrap;
- (NSString *)uxy_repeat:(NSUInteger)count;
- (NSString *)uxy_normalize;

- (BOOL)uxy_match:(NSString *)expression;
- (BOOL)uxy_matchAnyOf:(NSArray *)array;

- (BOOL)uxy_empty;
- (BOOL)uxy_notEmpty;

- (BOOL)uxy_eq:(NSString *)other;
- (BOOL)uxy_equal:(NSString *)other;

- (BOOL)uxy_is:(NSString *)other;
- (BOOL)uxy_isNot:(NSString *)other;

// 是否在array里, caseInsens 区分大小写
- (BOOL)uxy_isValueOf:(NSArray *)array;
- (BOOL)uxy_isValueOf:(NSArray *)array caseInsens:(BOOL)caseInsens;

#pragma mark - bee里的检测
- (BOOL)uxy_isNormal;
- (BOOL)uxy_isTelephone;
- (BOOL)uxy_isUserName;
- (BOOL)uxy_isChineseUserName;
- (BOOL)uxy_isPassword;
- (BOOL)uxy_isEmail;
- (BOOL)uxy_isURL;
- (BOOL)uxy_isIPAddress;

#pragma mark - 额外的检测
// 包含一个字符和数字
- (BOOL)uxy_isHasCharacterAndNumber;
// 昵称
- (BOOL)uxy_isNickname;
- (BOOL)uxy_isTelephone2;

- (NSString *)uxy_substringFromIndex:(NSUInteger)from untilCharset:(NSCharacterSet *)charset;
- (NSString *)uxy_substringFromIndex:(NSUInteger)from untilCharset:(NSCharacterSet *)charset endOffset:(NSUInteger *)endOffset;

+ (NSString *)uxy_fromResource:(NSString *)resName;

// 中英文混排，获取字符串长度
- (NSInteger)uxy_getLength;
- (NSInteger)uxy_getLength2;

// Unicode格式的字符串编码转成中文的方法(如\u7E8C)转换成中文,unicode编码以\u开头
- (NSString *)uxy_replaceUnicode;

/**
 * 擦除保存的值, 建议敏感信息在不用的是调用此方法擦除.
 * 如果是这样 _text = @"information"的 被分配到data区的无法擦除
 */
- (void)uxy_erasure;

// 大写字母 (International Business Machines 变成 IBM)
- (NSString*)uxy_stringByInitials;

// 返回显示字串所需要的尺寸
- (CGSize)uxy_calculateSize:(CGSize)size font:(UIFont *)font;

- (NSTimeInterval)uxy_displayTime;

@end


#pragma mark -

