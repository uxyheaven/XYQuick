//
//  NSString+XY.h
//  JoinShow
//
//  Created by Heaven on 13-10-16.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//  Copy from bee Framework

#import "XYPrecompile.h"

#pragma mark -

typedef NSString *			(^NSStringAppendBlock)( id format, ... );
typedef NSString *			(^NSStringReplaceBlock)( NSString * string, NSString * string2 );

typedef NSMutableString *	(^NSMutableStringAppendBlock)( id format, ... );
typedef NSMutableString *	(^NSMutableStringReplaceBlock)( NSString * string, NSString * string2 );

#pragma mark -

@interface NSString (XY)

@property (nonatomic, readonly) NSStringAppendBlock		APPEND;
@property (nonatomic, readonly) NSStringAppendBlock		LINE;
@property (nonatomic, readonly) NSStringReplaceBlock	REPLACE;

@property (nonatomic, readonly) NSString 				*MD5;
@property (nonatomic, readonly) NSData                  *MD5Data;

@property (nonatomic, readonly) NSData                  *data;
@property (nonatomic, readonly) NSDate                  *date;

@property (nonatomic, readonly) NSString 				*SHA1;


-(NSArray *) allURLs;

-(NSString *) urlByAppendingDict:(NSDictionary *)params;
-(NSString *) urlByAppendingDict:(NSDictionary *)params encoding:(BOOL)encoding;
-(NSString *) urlByAppendingArray:(NSArray *)params;
-(NSString *) urlByAppendingArray:(NSArray *)params encoding:(BOOL)encoding;
-(NSString *) urlByAppendingKeyValues:(id)first, ...;

+(NSString *) queryStringFromDictionary:(NSDictionary *)dict;
+(NSString *) queryStringFromDictionary:(NSDictionary *)dict encoding:(BOOL)encoding;;
+(NSString *) queryStringFromArray:(NSArray *)array;
+(NSString *) queryStringFromArray:(NSArray *)array encoding:(BOOL)encoding;;
+(NSString *) queryStringFromKeyValues:(id)first, ...;

-(NSString *) URLEncoding;
-(NSString *) URLDecoding;

// 去掉首尾的空格和换行
-(NSString *) trim;
// 去掉首尾的 " '
-(NSString *) unwrap;
-(NSString *) repeat:(NSUInteger)count;
-(NSString *) normalize;

-(BOOL) match:(NSString *)expression;
-(BOOL) matchAnyOf:(NSArray *)array;

-(BOOL) empty;
-(BOOL) notEmpty;

-(BOOL)eq:(NSString *)other;
-(BOOL)equal:(NSString *)other;

-(BOOL)is:(NSString *)other;
-(BOOL)isNot:(NSString *)other;

// 是否在array里, caseInsens 区分大小写
-(BOOL)isValueOf:(NSArray *)array;
-(BOOL)isValueOf:(NSArray *)array caseInsens:(BOOL)caseInsens;

-(BOOL)isNormal;
-(BOOL)isTelephone;
-(BOOL)isUserName;
-(BOOL)isChineseUserName;
-(BOOL)isPassword;
-(BOOL)isEmail;
-(BOOL)isUrl;
-(BOOL)isIPAddress;

// 包含一个字符和数字
-(BOOL)isHasCharacterAndNumber;

-(NSString *)substringFromIndex:(NSUInteger)from untilCharset:(NSCharacterSet *)charset;
-(NSString *)substringFromIndex:(NSUInteger)from untilCharset:(NSCharacterSet *)charset endOffset:(NSUInteger *)endOffset;

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
-(CGSize)sizeWithFont:(UIFont *)font byWidth:(CGFloat)width;
-(CGSize)sizeWithFont:(UIFont *)font byHeight:(CGFloat)height;
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

+(NSString *)fromResource:(NSString *)resName;

// 中英文混排，获取字符串长度
-(NSInteger) getLength;
-(NSInteger) getLength2;

// Unicode格式的字符串编码转成中文的方法(如\u7E8C)转换成中文,unicode编码以\u开头
-(NSString *) replaceUnicode;

/**
 * 擦除保存的值, 建议敏感信息在不用的是调用此方法擦除.
 * 如果是这样 _text = @"information"的 被分配到data区的无法擦除
 */
-(void) erasure;

@end


#pragma mark -

@interface NSMutableString(BeeExtension)

@property (nonatomic, readonly) NSMutableStringAppendBlock	APPEND;
@property (nonatomic, readonly) NSMutableStringAppendBlock	LINE;
@property (nonatomic, readonly) NSMutableStringReplaceBlock	REPLACE;

@end

