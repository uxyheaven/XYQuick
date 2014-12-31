//
//  NSObject+XY.m
//  JoinShow
//
//  Created by Heaven on 13-7-31.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import "NSObject+XY.h"
#import "XYPrecompile.h"
#import "XYFoundation.h"
//#import "XYExtension.h"

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

#undef	NSObject_key_tempObject
#define NSObject_key_tempObject	"NSObject.tempObject"
#undef	NSObject_key_objectDic
#define NSObject_key_objectDic	"NSObject.objectDic"
#undef	NSObject_key_EventBlockDic
#define NSObject_key_EventBlockDic	"NSObject.eventBlockDic"

#undef	UITableViewCell_key_rowHeight
#define UITableViewCell_key_rowHeight	"UITableViewCell.rowHeight"


DUMMY_CLASS(NSObject_XY);

static void (*__dealloc)( id, SEL);

@interface NSObject(XYPrivate)
- (void)myDealloc;
@end

@implementation NSObject (XY)

@dynamic attributeList;
@dynamic tempObject;

#pragma mark - hook
/*
+ (void)hookDealloc{
    static BOOL __swizzled = NO;
	if ( NO == __swizzled )
	{
        Method method = XY_swizzleInstanceMethod([NSObject class], @selector(dealloc), @selector(myDealloc));
        __dealloc = (void *)method_getImplementation( method );
        
        __swizzled = YES;
	}
}
- (void)myDealloc{
        if ([self respondsToSelector:@selector(delegate)]
            && (![self isKindOfClass:[CAAnimation class]])) {
            //  [self performSelector:@selector(setDelegate:) withObject:nil];
            objc_msgSend(self, @selector(setDelegate:), nil);
        }
    
    // [[NSNotificationCenter defaultCenter] removeObserver:self];
    // 无用
    // [NSObject cancelPreviousPerformRequestsWithTarget:self];
    // [self removeAllObserver];
    
    if ( __dealloc ){
        __dealloc( self, _cmd );
    }
}
 */
#pragma mark - perform

#pragma mark - property
- (NSArray *)attributeList{
    NSUInteger			propertyCount = 0;
    objc_property_t     *properties = class_copyPropertyList( [self class], &propertyCount );
    NSMutableArray *    array = [[NSMutableArray alloc] init];
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
			NSDateFormatter * formatter = [XYCommon dateFormatterTemp];
			[formatter setDateFormat:format];
			[formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            
			date = [formatter dateFromString:(NSString *)self];
		}
        
		if ( nil == date )
		{
			NSString * format = @"yyyy/MM/dd HH:mm:ss z";
			NSDateFormatter * formatter = [XYCommon dateFormatterTemp];
			[formatter setDateFormat:format];
			[formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
			
			date = [formatter dateFromString:(NSString *)self];
		}
        
		if ( nil == date )
		{
			NSString * format = @"yyyy-MM-dd HH:mm:ss";
			NSDateFormatter * formatter = [XYCommon dateFormatterTemp];
			[formatter setDateFormat:format];
			[formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
			
			date = [formatter dateFromString:(NSString *)self];
		}
        
		if ( nil == date )
		{
			NSString * format = @"yyyy/MM/dd HH:mm:ss";
			NSDateFormatter * formatter = [XYCommon dateFormatterTemp];
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
- (UIAlertView *)showMessage:(BOOL)isShow title:(NSString *)aTitle message:(NSString *)aMessage cancelButtonTitle:(NSString *)aCancel otherButtonTitles:(NSString *)otherTitles, ... NS_REQUIRES_NIL_TERMINATION{
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

#pragma mark- Object
- (id)tempObject
{
    id object = objc_getAssociatedObject(self, NSObject_key_tempObject);
    
    return object;
}

- (void)setTempObject:(id)tempObject
{
    [self willChangeValueForKey:@"tempObject"];
    objc_setAssociatedObject(self, NSObject_key_tempObject, tempObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"tempObject"];
}

- (void)receiveObject:(void(^)(id object))aBlock
{
    [self receiveObject:aBlock withIdentifier:@"sendObject"];
}
- (void)sendObject:(id)anObject
{
    [self sendObject:anObject withIdentifier:@"sendObject"];
}

- (void)receiveObject:(void(^)(id object))aBlock withIdentifier:(NSString *)identifier
{
    NSAssert(identifier != nil, @"identifier can't be nil.");
    NSMutableDictionary *dic = objc_getAssociatedObject(self, NSObject_key_objectDic);
    if(dic == nil)
    {
        dic = [NSMutableDictionary dictionaryWithCapacity:4];
        objc_setAssociatedObject(self, NSObject_key_objectDic, dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    [dic setObject:[aBlock copy] forKey:identifier];
}

- (void)sendObject:(id)anObject withIdentifier:(NSString *)identifier
{
    NSAssert(identifier != nil, @"identifier can't be nil.");
    
    NSDictionary *dic = objc_getAssociatedObject(self, NSObject_key_objectDic);
    if(dic == nil)
    {
        return;
    }
    
    void(^aBlock)(id anObject) =  [dic objectForKey:identifier];
    aBlock(anObject);
}

#pragma mark- block
- (void)handlerDefaultEventWithBlock:(id)block
{
    [self handlerEventWithBlock:block withIdentifier:@"EventBlock"];
}


- (id)blockForDefaultEvent
{
    return [self blockForEventWithIdentifier:@"EventBlock"];
}

- (void)handlerEventWithBlock:(id)aBlock withIdentifier:(NSString *)identifier
{
    NSAssert(identifier != nil, @"identifier can't be nil.");
    NSMutableDictionary *dic = objc_getAssociatedObject(self, NSObject_key_EventBlockDic);
    if(dic == nil)
    {
        dic = [NSMutableDictionary dictionaryWithCapacity:4];
        objc_setAssociatedObject(self, NSObject_key_EventBlockDic, dic, OBJC_ASSOCIATION_RETAIN);
    }
    
    [dic setObject:[aBlock copy] forKey:identifier];
}

- (id)blockForEventWithIdentifier:(NSString *)identifier
{
    NSAssert(identifier != nil, @"identifier can't be nil.");
    NSDictionary *dic = objc_getAssociatedObject(self, NSObject_key_EventBlockDic);
    if(dic == nil)
        return nil;
    
    return [dic objectForKey:identifier];
}

#pragma mark- copy
- (id)deepCopy1
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self]];
}
@end









