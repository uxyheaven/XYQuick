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

#import "NSObject+XY.h"
#import "XYQuick_Predefine.h"
#import "NSDate+XY.h"

#undef	NSObject_key_performSelector
#define NSObject_key_performSelector	"NSObject.performSelector"
#undef	NSObject_key_performTarget
#define NSObject_key_performTarget	"NSObject.performTarget"
#undef	NSObject_key_performBlock
#define NSObject_key_performBlock	"NSObject.performBlock"
#undef	NSObject_key_loop
#define NSObject_key_loop	"NSObject.loop"
#undef	NSObject_key_afterDelay
#define NSObject_key_afterDelay	"NSObject.afterDelay"
#undef	NSObject_key_object
#define NSObject_key_object	"NSObject.object"

#undef	UITableViewCell_key_rowHeight
#define UITableViewCell_key_rowHeight	"UITableViewCell.rowHeight"


DUMMY_CLASS(NSObject_XY);


@interface NSObject(XYPrivate)
- (void)myDealloc;
+ (NSDateFormatter *)__uxy_dateFormatterTemp;
@end

@implementation NSObject (XY)

@dynamic attributeList;

#pragma mark - hook

#pragma mark - perform

#pragma mark - property
- (NSArray *)attributeList
{
    unsigned int propertyCount = 0;
    objc_property_t*properties = class_copyPropertyList( [self class], &propertyCount );
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for ( NSUInteger i = 0; i < propertyCount; i++ )
    {
        const char *name = property_getName(properties[i]);
        NSString *propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        
        //   const char *attr = property_getAttributes(properties[i]);
        // NSLogD(@"%@, %s", propertyName, attr);
        [array addObject:propertyName];
    }
    free( properties );
    
    return array;
}

#pragma mark - Conversion
- (NSInteger)asInteger
{
	return [[self asNSNumber] integerValue];
}

- (float)asFloat
{
	return [[self asNSNumber] floatValue];
}

- (BOOL)asBool
{
	return [[self asNSNumber] boolValue];
}

- (NSNumber *)asNSNumber
{
	if ( [self isKindOfClass:[NSNumber class]] )
	{
		return (NSNumber *)self;
	}
	else if ( [self isKindOfClass:[NSString class]] )
	{
		return [NSNumber numberWithInteger:[(NSString *)self integerValue]];
	}
	else if ( [self isKindOfClass:[NSDate class]] )
	{
		return [NSNumber numberWithDouble:[(NSDate *)self timeIntervalSince1970]];
	}
	else if ( [self isKindOfClass:[NSNull class]] )
	{
		return [NSNumber numberWithInteger:0];
	}
    
	return nil;
}

- (NSString *)asNSString
{
	if ( [self isKindOfClass:[NSNull class]] )
		return nil;
    
	if ( [self isKindOfClass:[NSString class]] )
	{
		return (NSString *)self;
	}
	else if ( [self isKindOfClass:[NSData class]] )
	{
		NSData * data = (NSData *)self;
		return [[NSString alloc] initWithBytes:data.bytes length:data.length encoding:NSUTF8StringEncoding];
	}
	else
	{
		return [NSString stringWithFormat:@"%@", self];
	}
}

- (NSDate *)asNSDate
{
	if ( [self isKindOfClass:[NSDate class]] )
	{
		return (NSDate *)self;
	}
	else if ( [self isKindOfClass:[NSString class]] )
	{
		NSDate * date = nil;
        
		if ( nil == date )
		{
			NSString * format = @"yyyy-MM-dd HH:mm:ss z";
			NSDateFormatter * formatter = [NSObject __uxy_dateFormatterTemp];
			[formatter setDateFormat:format];
			[formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            
			date = [formatter dateFromString:(NSString *)self];
		}
        
		if ( nil == date )
		{
			NSString * format = @"yyyy/MM/dd HH:mm:ss z";
			NSDateFormatter * formatter = [NSObject __uxy_dateFormatterTemp];
			[formatter setDateFormat:format];
			[formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
			
			date = [formatter dateFromString:(NSString *)self];
		}
        
		if ( nil == date )
		{
			NSString * format = @"yyyy-MM-dd HH:mm:ss";
			NSDateFormatter * formatter = [NSObject __uxy_dateFormatterTemp];
			[formatter setDateFormat:format];
			[formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
			
			date = [formatter dateFromString:(NSString *)self];
		}
        
		if ( nil == date )
		{
			NSString * format = @"yyyy/MM/dd HH:mm:ss";
			NSDateFormatter * formatter = [NSObject __uxy_dateFormatterTemp];
			[formatter setDateFormat:format];
			[formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
			
			date = [formatter dateFromString:(NSString *)self];
		}
        
		return date;
        
        //		NSTimeZone * local = [NSTimeZone localTimeZone];
        //		return [NSDate dateWithTimeInterval:(3600 + [local secondsFromGMT])
        //								  sinceDate:[dateFormatter dateFromString:text]];
	}
	else
	{
		return [NSDate dateWithTimeIntervalSince1970:[self asNSNumber].doubleValue];
	}
	
	return nil;
}

- (NSData *)asNSData
{
	if ( [self isKindOfClass:[NSString class]] )
	{
		return [(NSString *)self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
	}
	else if ( [self isKindOfClass:[NSData class]] )
	{
		return (NSData *)self;
	}
    
	return nil;
}

- (NSArray *)asNSArray
{
	if ( [self isKindOfClass:[NSArray class]] )
	{
		return (NSArray *)self;
	}
	else
	{
		return [NSArray arrayWithObject:self];
	}
}
/*
- (NSArray *)asNSArrayWithClass:(Class)clazz
{
	if ( [self isKindOfClass:[NSArray class]] )
	{
		NSMutableArray * results = [NSMutableArray array];
        
		for ( NSObject * elem in (NSArray *)self )
		{
			if ( [elem isKindOfClass:[NSDictionary class]] )
			{
				NSObject * obj = [[self class] objectFromDictionary:elem];
				[results addObject:obj];
			}
		}
		
		return results;
	}
    
	return nil;
}
*/
- (NSMutableArray *)asNSMutableArray
{
	if ( [self isKindOfClass:[NSMutableArray class]] )
	{
		return (NSMutableArray *)self;
	}
	
	return nil;
}
/*
- (NSMutableArray *)asNSMutableArrayWithClass:(Class)clazz
{
	NSArray * array = [self asNSArrayWithClass:clazz];
	if ( nil == array )
		return nil;
    
	return [NSMutableArray arrayWithArray:array];
}
*/
- (NSDictionary *)asNSDictionary
{
	if ( [self isKindOfClass:[NSDictionary class]] )
	{
		return (NSDictionary *)self;
	}
    
	return nil;
}

- (NSMutableDictionary *)asNSMutableDictionary
{
	if ( [self isKindOfClass:[NSMutableDictionary class]] )
	{
		return (NSMutableDictionary *)self;
	}
	
	NSDictionary * dict = [self asNSDictionary];
	if ( nil == dict )
		return nil;
    
	return [NSMutableDictionary dictionaryWithDictionary:dict];
}

#pragma mark - message box
/*
- (UIAlertView *)showMessage:(BOOL)isShow title:(NSString *)aTitle message:(NSString *)aMessage cancelButtonTitle:(NSString *)aCancel otherButtonTitles:(NSString *)otherTitles, ... NS_REQUIRES_NIL_TERMINATION
 {
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:aTitle message:aMessage delegate:nil cancelButtonTitle:aCancel otherButtonTitles:nil];
    
    va_list args;
    va_start(args, otherTitles);
    if (otherTitles)
    {
        [alter addButtonWithTitle:otherTitles];
        NSString *otherString;
        while ((otherString = va_arg(args, NSString *)))
        {
            [alter addButtonWithTitle:otherString];
        }
    }
    va_end(args);
    
    if (isShow)
        [alter show];
    
    return alter;
}
*/

#pragma mark- copy
- (id)deepCopy1
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self]];
}

#pragma mark - private
+ (NSDateFormatter *)__uxy_dateFormatterTemp
{
    NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *dateFormatter = threadDictionary[@"uxy_dateFormatterTemp"];
    if(!dateFormatter)
    {
        @synchronized(self)
        {
            if(!dateFormatter)
            {
                dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                threadDictionary[@"uxy_dateFormatterTemp"] = dateFormatter;
            }
        }
    }
    
    return dateFormatter;
}
@end

@implementation NSObject (XY_associated)
- (id)uxy_getAssociatedObjectForKey:(const char *)key
{
    const char * propName = key;
    id currValue = objc_getAssociatedObject( self, propName );
    return currValue;
}

- (id)uxy_copyAssociatedObject:(id)obj forKey:(const char *)key
{
    const char * propName = key;
    id oldValue = objc_getAssociatedObject( self, propName );
    objc_setAssociatedObject( self, propName, obj, OBJC_ASSOCIATION_COPY );
    return oldValue;
}

- (id)uxy_retainAssociatedObject:(id)obj forKey:(const char *)key;
{
    const char * propName = key;
    id oldValue = objc_getAssociatedObject( self, propName );
    objc_setAssociatedObject( self, propName, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
    return oldValue;
}

- (id)uxy_assignAssociatedObject:(id)obj forKey:(const char *)key
{
    const char * propName = key;
    id oldValue = objc_getAssociatedObject( self, propName );
    objc_setAssociatedObject( self, propName, obj, OBJC_ASSOCIATION_ASSIGN );
    return oldValue;
}

- (void)uxy_removeAssociatedObjectForKey:(const char *)key
{
    const char * propName = key;
    objc_setAssociatedObject( self, propName, nil, OBJC_ASSOCIATION_ASSIGN );
}

- (void)uxy_removeAllAssociatedObjects
{
    objc_removeAssociatedObjects( self );
}

@end





