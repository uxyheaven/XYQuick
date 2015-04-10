//
//  NSString+XY.m
//  JoinShow
//
//  Created by Heaven on 13-10-16.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import "NSString+XY.h"
#import "NSObject+XY.h"
#import "NSData+XY.h"

#import "XYPrecompile.h"
#import "XYCommon.h"

DUMMY_CLASS(NSString_XY);

@implementation NSString (XY)

// 这里有依赖了
@dynamic uxySHA1String;
@dynamic uxySHA1Data;
- (NSString *)uxyMD5String
{
    return [[NSData dataWithBytes:[self UTF8String] length:[self length]] uxyMD5String];
}
- (NSData *)uxyMD5Data
{
    return [[NSData dataWithBytes:[self UTF8String] length:[self length]] uxyMD5Data];
}

@dynamic uxyMD5String;
@dynamic uxyMD5Data;
- (NSString *)uxySHA1String
{
    return [[NSData dataWithBytes:[self UTF8String] length:[self length]] uxySHA1String];
}
- (NSData *)uxySHA1Data
{
    return [[NSData dataWithBytes:[self UTF8String] length:[self length]] uxySHA1Data];
}

@dynamic uxyBASE64Decrypted;
- (NSData *)uxyBASE64Decrypted
{
    static char * __base64EncodingTable = (char *)"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    static char * __base64DecodingTable = nil;
    
    // copy from THREE20
    
    if ( 0 == [self length] )
    {
        return [NSData data];
    }
    
    if ( NULL == __base64DecodingTable )
    {
        __base64DecodingTable = (char *)malloc( 256 );
        if ( NULL == __base64DecodingTable )
        {
            return nil;
        }
        
        memset( __base64DecodingTable, CHAR_MAX, 256 );
        
        for ( int i = 0; i < 64; i++)
        {
            __base64DecodingTable[(short)__base64EncodingTable[i]] = (char)i;
        }
    }
    
    const char * characters = [self cStringUsingEncoding:NSASCIIStringEncoding];
    if ( NULL == characters )     //  Not an ASCII string!
    {
        return nil;
    }
    
    char * bytes = (char *)malloc( ([self length] + 3) * 3 / 4 );
    if ( NULL == bytes )
    {
        return nil;
    }
    
    NSUInteger length = 0;
    NSUInteger i = 0;
    
    while ( 1 )
    {
        char	buffer[4] = { 0 };
        short	bufferLength = 0;
        
        for ( bufferLength = 0; bufferLength < 4; i++ )
        {
            if ( characters[i] == '\0' )
            {
                break;
            }
            
            if ( isspace(characters[i]) || characters[i] == '=' )
            {
                continue;
            }
            
            buffer[bufferLength] = __base64DecodingTable[(short)characters[i]];
            if ( CHAR_MAX == buffer[bufferLength++] )
            {
                free(bytes);
                return nil;
            }
        }
        
        if ( 0 == bufferLength )
        {
            break;
        }
        
        if ( 1 == bufferLength )
        {
            // At least two characters are needed to produce one byte!
            
            free(bytes);
            return nil;
        }
        
        //  Decode the characters in the buffer to bytes.
        
        bytes[length++] = (char)((buffer[0] << 2) | (buffer[1] >> 4));
        
        if (bufferLength > 2)
        {
            bytes[length++] = (char)((buffer[1] << 4) | (buffer[2] >> 2));
        }
        
        if (bufferLength > 3)
        {
            bytes[length++] = (char)((buffer[2] << 6) | buffer[3]);
        }
    }
    
    realloc( bytes, length );
    
    return [NSData dataWithBytesNoCopy:bytes length:length];
}

@dynamic uxyData;
- (NSData *)uxyData
{
	return [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
}

@dynamic uxyDate;
- (NSDate *)uxyDate
{
	NSTimeZone * local = [NSTimeZone localTimeZone];
	
	NSString * format = @"yyyy-MM-dd HH:mm:ss";
	NSString * text = [(NSString *)self substringToIndex:format.length];
	
	NSDateFormatter * dateFormatter = [XYCommon dateFormatterTemp];
	[dateFormatter setDateFormat:format];
	[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	
	return [NSDate dateWithTimeInterval:(3600 + [local secondsFromGMT])
							  sinceDate:[dateFormatter dateFromString:text]];
}

- (NSArray *)allURLs
{
	NSMutableArray * array = [NSMutableArray array];
	
	NSInteger stringIndex = 0;
	while ( stringIndex < self.length )
	{
		NSRange searchRange = NSMakeRange(stringIndex, self.length - stringIndex);
		NSRange httpRange = [self rangeOfString:@"http://" options:NSCaseInsensitiveSearch range:searchRange];
		NSRange httpsRange = [self rangeOfString:@"https://" options:NSCaseInsensitiveSearch range:searchRange];
		
		NSRange startRange;
		if ( httpRange.location == NSNotFound )
		{
			startRange = httpsRange;
		}
		else if ( httpsRange.location == NSNotFound )
		{
			startRange = httpRange;
		}
		else
		{
			startRange = (httpRange.location < httpsRange.location) ? httpRange : httpsRange;
		}
		
		if (startRange.location == NSNotFound)
		{
			break;
		}
		else
		{
			NSRange beforeRange = NSMakeRange( searchRange.location, startRange.location - searchRange.location );
			if ( beforeRange.length )
			{
				//				NSString * text = [string substringWithRange:beforeRange];
				//				[array addObject:text];
			}
			
			NSRange subSearchRange = NSMakeRange(startRange.location, self.length - startRange.location);
			NSRange endRange = [self rangeOfString:@" " options:NSCaseInsensitiveSearch range:subSearchRange];
			if ( endRange.location == NSNotFound)
			{
				NSString * url = [self substringWithRange:subSearchRange];
				[array addObject:url];
				break;
			}
			else
			{
				NSRange URLRange = NSMakeRange(startRange.location, endRange.location - startRange.location);
				NSString * url = [self substringWithRange:URLRange];
				[array addObject:url];
				
				stringIndex = endRange.location;
			}
		}
	}
	
	return array;
}

+ (NSString *)queryStringFromDictionary:(NSDictionary *)dict
{
    return [self queryStringFromDictionary:dict encoding:YES];
}

+ (NSString *)queryStringFromDictionary:(NSDictionary *)dict encoding:(BOOL)encoding
{
    NSMutableArray * pairs = [NSMutableArray array];
	for ( NSString * key in dict.allKeys )
	{
		NSString * value = [((NSObject *)[dict objectForKey:key]) asNSString];
		NSString * urlEncoding = encoding ? [value URLEncoding] : value;
		[pairs addObject:[NSString stringWithFormat:@"%@=%@", key, urlEncoding]];
	}
	
	return [pairs componentsJoinedByString:@"&"];
}

+ (NSString *)queryStringFromArray:(NSArray *)array
{
    return [self queryStringFromArray:array encoding:YES];
}

+ (NSString *)queryStringFromArray:(NSArray *)array encoding:(BOOL)encoding
{
	NSMutableArray *pairs = [NSMutableArray array];
	
	for ( NSUInteger i = 0; i < [array count]; i += 2 )
	{
		NSObject * obj1 = [array objectAtIndex:i];
		NSObject * obj2 = [array objectAtIndex:i + 1];
		
		NSString * key = nil;
		NSString * value = nil;
		
		if ( [obj1 isKindOfClass:[NSNumber class]] )
		{
			key = [(NSNumber *)obj1 stringValue];
		}
		else if ( [obj1 isKindOfClass:[NSString class]] )
		{
			key = (NSString *)obj1;
		}
		else
		{
			continue;
		}
		
		if ( [obj2 isKindOfClass:[NSNumber class]] )
		{
			value = [(NSNumber *)obj2 stringValue];
		}
		else if ( [obj1 isKindOfClass:[NSString class]] )
		{
			value = (NSString *)obj2;
		}
		else
		{
			continue;
		}
		
		NSString * urlEncoding = encoding ? [value URLEncoding] : value;
		[pairs addObject:[NSString stringWithFormat:@"%@=%@", key, urlEncoding]];
	}
	
	return [pairs componentsJoinedByString:@"&"];
}

+ (NSString *)queryStringFromKeyValues:(id)first, ...
{
	NSMutableDictionary * dict = [NSMutableDictionary dictionary];
	
	va_list args;
	va_start( args, first );
	
	for ( ;; )
	{
		NSObject<NSCopying> * key = [dict count] ? va_arg( args, NSObject * ) : first;
		if ( nil == key )
			break;
		
		NSObject * value = va_arg( args, NSObject * );
		if ( nil == value )
			break;
		
		[dict setObject:value forKey:key];
	}
	va_end( args );
	return [NSString queryStringFromDictionary:dict];
}

- (NSString *)urlByAppendingDict:(NSDictionary *)params
{
    return [self urlByAppendingDict:params encoding:YES];
}

- (NSString *)urlByAppendingDict:(NSDictionary *)params encoding:(BOOL)encoding
{
    NSURL * parsedURL = [NSURL URLWithString:self];
	NSString * queryPrefix = parsedURL.query ? @"&" : @"?";
	NSString * query = [NSString queryStringFromDictionary:params encoding:encoding];
	return [NSString stringWithFormat:@"%@%@%@", self, queryPrefix, query];
}

- (NSString *)urlByAppendingArray:(NSArray *)params
{
    return [self urlByAppendingArray:params encoding:YES];
}

- (NSString *)urlByAppendingArray:(NSArray *)params encoding:(BOOL)encoding
{
    NSURL * parsedURL = [NSURL URLWithString:self];
	NSString * queryPrefix = parsedURL.query ? @"&" : @"?";
	NSString * query = [NSString queryStringFromArray:params encoding:encoding];
	return [NSString stringWithFormat:@"%@%@%@", self, queryPrefix, query];
}

- (NSString *)urlByAppendingKeyValues:(id)first, ...
{
	NSMutableDictionary * dict = [NSMutableDictionary dictionary];
	
	va_list args;
	va_start( args, first );
	
	for ( ;; )
	{
		NSObject<NSCopying> * key = [dict count] ? va_arg( args, NSObject * ) : first;
		if ( nil == key )
			break;
		
		NSObject * value = va_arg( args, NSObject * );
		if ( nil == value )
			break;
        
		[dict setObject:value forKey:key];
	}
    va_end( args );
	return [self urlByAppendingDict:dict];
}

- (BOOL)empty
{
	return [self length] > 0 ? NO : YES;
}

- (BOOL)notEmpty
{
	return [self length] > 0 ? YES : NO;
}

- (BOOL)eq:(NSString *)other
{
	return [self isEqualToString:other];
}

- (BOOL)equal:(NSString *)other
{
	return [self isEqualToString:other];
}

- (BOOL)is:(NSString *)other
{
	return [self isEqualToString:other];
}

- (BOOL)isNot:(NSString *)other
{
	return NO == [self isEqualToString:other];
}

- (BOOL)isValueOf:(NSArray *)array
{
	return [self isValueOf:array caseInsens:NO];
}

- (BOOL)isValueOf:(NSArray *)array caseInsens:(BOOL)caseInsens
{
	NSStringCompareOptions option = caseInsens ? NSCaseInsensitiveSearch : 0;
	
	for ( NSObject * obj in array )
	{
		if ( NO == [obj isKindOfClass:[NSString class]] )
			continue;
		
		if ( [(NSString *)obj compare:self options:option] )
			return YES;
	}
	
	return NO;
}

- (NSString *)URLEncoding
{
    CFStringRef aCFString = CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault,
                                                                    (CFStringRef)self,
                                                                    NULL,
                                                                    (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                    kCFStringEncodingUTF8 );
	NSString * result = (NSString *)CFBridgingRelease(aCFString);
    CFRelease(aCFString);
    
	return result;
}

- (NSString *)URLDecoding
{
	NSMutableString * string = [NSMutableString stringWithString:self];
    [string replaceOccurrencesOfString:@"+"
							withString:@" "
							   options:NSLiteralSearch
								 range:NSMakeRange(0, [string length])];
    return [string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSMutableDictionary *)dictionaryFromQueryComponents
{
    NSMutableDictionary *queryComponents = [NSMutableDictionary dictionary];
    for(NSString *keyValuePairString in [self componentsSeparatedByString:@"&"])
    {
        NSArray *keyValuePairArray = [keyValuePairString componentsSeparatedByString:@"="];
        if ([keyValuePairArray count] < 2) continue; // Verify that there is at least one key, and at least one value.  Ignore extra = signs
        NSString *key = [[keyValuePairArray objectAtIndex:0] URLDecoding];
        NSString *value = [[keyValuePairArray objectAtIndex:1] URLDecoding];
        NSMutableArray *results = [queryComponents objectForKey:key]; // URL spec says that multiple values are allowed per key
        if(!results) // First object
        {
            results = [NSMutableArray arrayWithCapacity:1];
            [queryComponents setObject:results forKey:key];
        }
        [results addObject:value];
    }
    return queryComponents;
}

- (NSString *)trim
{
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)unwrap
{
	if ( self.length >= 2 )
	{
		if ( [self hasPrefix:@"\""] && [self hasSuffix:@"\""] )
		{
			return [self substringWithRange:NSMakeRange(1, self.length - 2)];
		}
        
		if ( [self hasPrefix:@"'"] && [self hasSuffix:@"'"] )
		{
			return [self substringWithRange:NSMakeRange(1, self.length - 2)];
		}
	}
    
	return self;
}

- (NSString *)repeat:(NSUInteger)count
{
	if ( 0 == count )
		return @"";
	
	NSMutableString * text = [NSMutableString string];
	
	for ( NSUInteger i = 0; i < count; ++i )
	{
		[text appendString:self];
	}
	
	return text;
}

- (NSString *)normalize
{
	return [self stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
}


- (BOOL)isNormal{
    NSString *regex = @"([^%&',;=!~?$]+)";
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
	
	return [pred evaluateWithObject:self];
}

- (BOOL)isUserName
{
	NSString *		regex = @"(^[A-Za-z0-9]{3,20}$)";
	NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
	
	return [pred evaluateWithObject:self];
}

- (BOOL) isChineseUserName
{
	NSString *		regex = @"(^[A-Za-z0-9\u4e00-\u9fa5]{3,20}$)";
	NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
	
	return [pred evaluateWithObject:self];
}

- (BOOL)isPassword
{
	NSString *		regex = @"(^[A-Za-z0-9]{6,20}$)";
	NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
	
	return [pred evaluateWithObject:self];
}

- (BOOL)isEmail
{
	NSString *		regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
	
	return [pred evaluateWithObject:self];
}

- (BOOL)isUrl
{
    NSString *		regex = @"http(s)?:\\/\\/([\\w-]+\\.)+[\\w-]+(\\/[\\w- .\\/?%&=]*)?";
	NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
	
	return [pred evaluateWithObject:self];
}

- (BOOL)isIPAddress
{
	NSArray *			components = [self componentsSeparatedByString:@"."];
	NSCharacterSet *	invalidCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890"] invertedSet];
	
	if ( [components count] == 4 )
	{
		NSString *part1 = [components objectAtIndex:0];
		NSString *part2 = [components objectAtIndex:1];
		NSString *part3 = [components objectAtIndex:2];
		NSString *part4 = [components objectAtIndex:3];
		
		if ( [part1 rangeOfCharacterFromSet:invalidCharacters].location == NSNotFound &&
            [part2 rangeOfCharacterFromSet:invalidCharacters].location == NSNotFound &&
            [part3 rangeOfCharacterFromSet:invalidCharacters].location == NSNotFound &&
            [part4 rangeOfCharacterFromSet:invalidCharacters].location == NSNotFound )
		{
			if ( [part1 intValue] < 255 &&
                [part2 intValue] < 255 &&
                [part3 intValue] < 255 &&
                [part4 intValue] < 255 )
			{
				return YES;
			}
		}
	}
	
	return NO;
}

- (BOOL)isTelephone
{
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestphs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    
    return  [regextestmobile evaluateWithObject:self]   ||
    [regextestphs evaluateWithObject:self]      ||
    [regextestct evaluateWithObject:self]       ||
    [regextestcu evaluateWithObject:self]       ||
    [regextestcm evaluateWithObject:self];
}

////////////////////
- (BOOL)isHasCharacterAndNumber{
    BOOL isExistDigit = [self rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].location != NSNotFound;
    
    BOOL isExistLetter = [self rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]].location != NSNotFound;
    
    return isExistDigit && isExistLetter;
}
- (BOOL)isNickname{
    if (self == nil) {
		return NO;
	}
    
    NSString *regex = @"^[a-zA-Z0-9_\u4E00-\u9FFF-]{1,12}+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
	BOOL isMatch = [pred evaluateWithObject:self];
    
    return isMatch;
}

- (BOOL)isTelephone2{
    if (self == nil)
        return NO;

	//联通号码
	NSString *regex_Unicom = @"^(130|131|132|133|185|186|156|155)[0-9]{8}";
	//移动号码
	NSString *regex_CMCC = @"^(134|135|136|137|138|139|147|150|151|152|157|158|159|182|187|188)[0-9]{8}";
	//电信号码段(电信新增号段181)
	NSString *regex_Telecom = @"^(133|153|180|181|189)[0-9]{8}";
	
	NSPredicate *pred_Unicom = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex_Unicom];
	BOOL isMatch_Unicom = [pred_Unicom evaluateWithObject:self];
	
	NSPredicate *pred_CMCC = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex_CMCC];
	BOOL isMatch_CMCC = [pred_CMCC evaluateWithObject:self];
	
	NSPredicate *pred_Telecom = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex_Telecom];
	BOOL isMatch_Telecom = [pred_Telecom evaluateWithObject:self];
	
	if (isMatch_Unicom || isMatch_CMCC || isMatch_Telecom)
    {
		return YES;
	}
	else
    {
        return NO;
	}
}
///////////////////

- (NSString *)substringFromIndex:(NSUInteger)from untilCharset:(NSCharacterSet *)charset
{
	return [self substringFromIndex:from untilCharset:charset endOffset:NULL];
}

- (NSString *)substringFromIndex:(NSUInteger)from untilCharset:(NSCharacterSet *)charset endOffset:(NSUInteger *)endOffset
{
	if ( 0 == self.length )
		return nil;
	
	if ( from >= self.length )
		return nil;
    
	NSRange range = NSMakeRange( from, self.length - from );
	NSRange range2 = [self rangeOfCharacterFromSet:charset options:NSCaseInsensitiveSearch range:range];
    
	if ( NSNotFound == range2.location )
	{
		if ( endOffset )
		{
			*endOffset = range.location + range.length;
		}
		
		return [self substringWithRange:range];
	}
	else
	{
		if ( endOffset )
		{
			*endOffset = range2.location + range2.length;
		}
        
		return [self substringWithRange:NSMakeRange(from, range2.location - from)];
	}
}

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
- (CGSize)sizeWithFont:(UIFont *)font byWidth:(CGFloat)width
{
	return [self sizeWithFont:font
			constrainedToSize:CGSizeMake(width, 999999.0f)
				lineBreakMode:UILineBreakModeWordWrap];
}

- (CGSize)sizeWithFont:(UIFont *)font byHeight:(CGFloat)height
{
	return [self sizeWithFont:font
			constrainedToSize:CGSizeMake(999999.0f, height)
				lineBreakMode:UILineBreakModeWordWrap];
}
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

+ (NSString *)fromResource:(NSString *)resName
{
	NSString *	extension = [resName pathExtension];
	NSString *	fullName = [resName substringToIndex:(resName.length - extension.length - 1)];
    
	NSString * path = [[NSBundle mainBundle] pathForResource:fullName ofType:extension];
	return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
}

- (BOOL)match:(NSString *)expression
{
	NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:expression
																			options:NSRegularExpressionCaseInsensitive
																			  error:nil];
	if ( nil == regex )
		return NO;
	
	NSUInteger numberOfMatches = [regex numberOfMatchesInString:self
														options:0
														  range:NSMakeRange(0, self.length)];
	if ( 0 == numberOfMatches )
		return NO;
    
	return YES;
}

- (BOOL)matchAnyOf:(NSArray *)array
{
	for ( NSString * str in array )
	{
		if ( NSOrderedSame == [self compare:str options:NSCaseInsensitiveSearch] )
		{
			return YES;
		}
	}
	
	return NO;
}

- (NSInteger)getLength
{
    NSInteger strLength = 0;
    char *p = (char *)[self cStringUsingEncoding:NSUnicodeStringEncoding];
    for (NSInteger i = 0; i < [self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding]; i++)
    {
        if (*p)
        {
            p++;
            strLength++;
        }
        else
        {
            p++;
        }
    }
    return strLength;
}
- (NSInteger)getLength2
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *data = [self dataUsingEncoding:enc];
    return [data length];
}

- (NSString *)replaceUnicode
{
    NSString *tempStr1 = [self stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    //  NSLog(@"%@",returnStr);
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}

- (void)erasure
{
    char *string = (char *)CFStringGetCStringPtr((CFStringRef)self, CFStringGetSystemEncoding());
    memset(string, 0, [self length]);
}

- (NSString*)stringByInitials
{
    NSMutableString *result = [NSMutableString string];
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length) options:NSStringEnumerationByWords | NSStringEnumerationLocalized usingBlock:^(NSString *word, NSRange wordRange, NSRange enclosingWordRange, BOOL *stop1) {
        __block NSString *firstLetter = nil;
        [self enumerateSubstringsInRange:NSMakeRange(0, word.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *letter, NSRange letterRange, NSRange enclosingLetterRange, BOOL *stop2) {
            firstLetter = letter;
            *stop2 = YES;
        }];
        if (firstLetter != nil) {
            [result appendString:firstLetter];
        };
    }];
    return result;
}

- (CGSize)calculateSize:(CGSize)size font:(UIFont *)font
{
    CGSize expectedLabelSize = CGSizeZero;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
        
        expectedLabelSize = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    } else {
        expectedLabelSize = [self sizeWithFont:font
                             constrainedToSize:size
                                 lineBreakMode:NSLineBreakByWordWrapping];
    }
    
    return CGSizeMake(ceil(expectedLabelSize.width), ceil(expectedLabelSize.height));
}

- (NSTimeInterval) displayTime
{
    return MAX((float)self.length * 0.1 + 2, 2);
}

@end

#pragma mark -
