//
//  NSString+XY.h
//  JoinShow
//
//  Created by Heaven on 13-10-16.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//  Copy from bee Framework

#import <Foundation/Foundation.h>

#pragma mark -


#pragma mark -

@interface NSString (XY)

@property (nonatomic, readonly, strong) NSData *uxyMD5Data;
@property (nonatomic, readonly, copy) NSString *uxyMD5String;

@property (nonatomic, readonly, strong) NSData *uxySHA1Data;
@property (nonatomic, readonly, copy) NSString *uxySHA1String;

@property (nonatomic, readonly, copy) NSString *uxyBASE64Decrypted;

@property (nonatomic, readonly, strong) NSData *uxyData;

@property (nonatomic, readonly, strong) NSDate *uxyDate;

// url相关
- (NSArray *)allURLs;

- (NSString *)urlByAppendingDict:(NSDictionary *)params;
- (NSString *)urlByAppendingDict:(NSDictionary *)params encoding:(BOOL)encoding;
- (NSString *)urlByAppendingArray:(NSArray *)params;
- (NSString *)urlByAppendingArray:(NSArray *)params encoding:(BOOL)encoding;
- (NSString *)urlByAppendingKeyValues:(id)first, ...;

+ (NSString *)queryStringFromDictionary:(NSDictionary *)dict;
+ (NSString *)queryStringFromDictionary:(NSDictionary *)dict encoding:(BOOL)encoding;;
+ (NSString *)queryStringFromArray:(NSArray *)array;
+ (NSString *)queryStringFromArray:(NSArray *)array encoding:(BOOL)encoding;;
+ (NSString *)queryStringFromKeyValues:(id)first, ...;

- (NSString *)URLEncoding;
- (NSString *)URLDecoding;

- (NSMutableDictionary *)dictionaryFromQueryComponents;

// 去掉首尾的空格和换行
- (NSString *)trim;
// 去掉首尾的 " '
- (NSString *)unwrap;
- (NSString *)repeat:(NSUInteger)count;
- (NSString *)normalize;

- (BOOL)match:(NSString *)expression;
- (BOOL)matchAnyOf:(NSArray *)array;

- (BOOL)empty;
- (BOOL)notEmpty;

- (BOOL)eq:(NSString *)other;
- (BOOL)equal:(NSString *)other;

- (BOOL)is:(NSString *)other;
- (BOOL)isNot:(NSString *)other;

// 是否在array里, caseInsens 区分大小写
- (BOOL)isValueOf:(NSArray *)array;
- (BOOL)isValueOf:(NSArray *)array caseInsens:(BOOL)caseInsens;

#pragma mark - bee里的检测
- (BOOL)isNormal;
- (BOOL)isTelephone;
- (BOOL)isUserName;
- (BOOL)isChineseUserName;
- (BOOL)isPassword;
- (BOOL)isEmail;
- (BOOL)isUrl;
- (BOOL)isIPAddress;

#pragma mark - 额外的检测
// 包含一个字符和数字
- (BOOL)isHasCharacterAndNumber;
// 昵称
- (BOOL)isNickname;
- (BOOL)isTelephone2;

- (NSString *)substringFromIndex:(NSUInteger)from untilCharset:(NSCharacterSet *)charset;
- (NSString *)substringFromIndex:(NSUInteger)from untilCharset:(NSCharacterSet *)charset endOffset:(NSUInteger *)endOffset;

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
- (CGSize)sizeWithFont:(UIFont *)font byWidth:(CGFloat)width;
- (CGSize)sizeWithFont:(UIFont *)font byHeight:(CGFloat)height;
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

+ (NSString *)fromResource:(NSString *)resName;

// 中英文混排，获取字符串长度
- (NSInteger)getLength;
- (NSInteger)getLength2;

// Unicode格式的字符串编码转成中文的方法(如\u7E8C)转换成中文,unicode编码以\u开头
- (NSString *)replaceUnicode;

/**
 * 擦除保存的值, 建议敏感信息在不用的是调用此方法擦除.
 * 如果是这样 _text = @"information"的 被分配到data区的无法擦除
 */
- (void)erasure;

// 大写字母 (International Business Machines 变成 IBM)
- (NSString*)stringByInitials;

// 返回显示字串所需要的尺寸
- (CGSize)calculateSize:(CGSize)size font:(UIFont *)font;

- (NSTimeInterval)displayTime;

@end


#pragma mark -

