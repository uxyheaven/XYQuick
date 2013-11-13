//
//  NSString+XY.m
//  JoinShow
//
//  Created by Heaven on 13-10-16.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import "NSString+XY.h"
#import "XYPrecompile.h"

DUMMY_CLASS(NSString_XY);

@implementation NSString (XY)

@dynamic MD5;
@dynamic MD5Data;

@dynamic SHA1;

@dynamic data;
@dynamic date;

-(NSString *) SHA1{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}
-(NSString *) MD5
{
	const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    
    return result;
}

-(NSData *) MD5Data
{
	// TODO:
	return nil;
}

-(NSData *) data
{
	return [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
}

-(NSDate *) date
{
	NSTimeZone *local = [NSTimeZone localTimeZone];
	
	NSString *format = @"yyyy-MM-dd HH:mm:ss";
	NSString *text = [(NSString *)self substringToIndex:format.length];
	
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateFormat:format];
	[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	
	return [NSDate dateWithTimeInterval:(3600 + [local secondsFromGMT])
							  sinceDate:[dateFormatter dateFromString:text]];
}

-(NSString *) trim
{
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

-(BOOL) isUserName
{
	NSString *regex = @"(^[A-Za-z0-9]{3,20}$)";
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
	
	return [pred evaluateWithObject:self];
}

-(BOOL) isPassword
{
	NSString *regex = @"(^[A-Za-z0-9]{6,20}$)";
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
	
	return [pred evaluateWithObject:self];
}

-(BOOL) isEmail
{
	NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
	
	return [pred evaluateWithObject:self];
}

-(BOOL) isUrl
{
    NSString *regex = @"http(s)?:\\/\\/([\\w-]+\\.)+[\\w-]+(\\/[\\w- .\\/?%&=]*)?";
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
	
	return [pred evaluateWithObject:self];
}

-(BOOL) isTelephone
{
    NSString *MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString *CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString *CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString *CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    NSString *PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
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

-(BOOL) isValueOf:(NSArray *)array
{
	return [self isValueOf:array caseInsens:NO];
}

-(BOOL) isValueOf:(NSArray *)array caseInsens:(BOOL)caseInsens
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
@end
