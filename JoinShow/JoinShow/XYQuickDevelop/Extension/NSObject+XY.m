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
-(void) myDealloc;
@end

@implementation NSObject (XY)

@dynamic attributeList;
@dynamic tempObject;
@dynamic cellHeight;

+(void)load{
#if (1 == __XY_HOOK_DEALLOC__)
    [NSObject hookDealloc];
#endif
}
#pragma mark - hook
/*
+(void) hookDealloc{
    static BOOL __swizzled = NO;
	if ( NO == __swizzled )
	{
        Method method = XY_swizzleInstanceMethod([NSObject class], @selector(dealloc), @selector(myDealloc));
        __dealloc = (void *)method_getImplementation( method );
        
        __swizzled = YES;
	}
}
-(void) myDealloc{
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


#pragma mark - NSNotificationCenter
-(void) registerMessage:(NSString*)aMsg selector:(SEL)aSel source:(id)source{
    if (aMsg == nil || aSel == nil) return;
    [self unregisterMessage:aMsg];
    
    if ([self respondsToSelector:aSel]){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:aSel name:aMsg object:source];
        return;
    }
}
-(void) unregisterMessage:(NSString*)aMsg{
    if (aMsg == nil) return;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:aMsg object:nil];
}
-(void) unregisterAllMessage{
   [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void) sendMessage:(NSString *)aMsg userInfo:(NSDictionary *)userInfo{
    if (aMsg == nil) return;
    [[NSNotificationCenter defaultCenter] postNotificationName:aMsg object:self userInfo:userInfo];
}

#pragma mark - property
-(NSArray *) attributeList{
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
-(int) cellHeight{
    NSNumber *number = objc_getAssociatedObject(self, UITableViewCell_key_rowHeight);
    if (number == nil) {
        return -1;
    }
    
    return [number intValue];
}

-(void) setCellHeight:(int)aHeight{
    objc_setAssociatedObject(self, UITableViewCell_key_rowHeight, @(aHeight), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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
-(UIAlertView *) showMessage:(BOOL)isShow title:(NSString *)aTitle message:(NSString *)aMessage cancelButtonTitle:(NSString *)aCancel otherButtonTitles:(NSString *)otherTitles, ... NS_REQUIRES_NIL_TERMINATION{
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
    
    if (isShow) [alter show];
    
    return alter;
}

#pragma mark- Object
-(id) tempObject{
    id object = objc_getAssociatedObject(self, NSObject_key_tempObject);
    
    return object;
}

-(void) setTempObject:(id)tempObject{
    objc_setAssociatedObject(self, NSObject_key_tempObject, tempObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void) receiveObject:(void(^)(id object))aBlock
{
    [self receiveObject:aBlock withIdentifier:@"sendObject"];
}
-(void) sendObject:(id)anObject
{
    [self sendObject:anObject withIdentifier:@"sendObject"];
}

-(void) receiveObject:(void(^)(id object))aBlock withIdentifier:(NSString *)identifier
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

-(void) sendObject:(id)anObject withIdentifier:(NSString *)identifier
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
-(void) handlerDefaultEventWithBlock:(id)block
{
    [self handlerEventWithBlock:block withIdentifier:@"EventBlock"];
}


-(id) blockForDefaultEvent
{
    return [self blockForEventWithIdentifier:@"EventBlock"];
}

-(void)handlerEventWithBlock:(id)aBlock withIdentifier:(NSString *)identifier
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

-(id)blockForEventWithIdentifier:(NSString *)identifier
{
    NSAssert(identifier != nil, @"identifier can't be nil.");
    NSDictionary *dic = objc_getAssociatedObject(self, NSObject_key_EventBlockDic);
    if(dic == nil) return nil;
    return [dic objectForKey:identifier];
}

@end



#pragma mark- category AutoCoding
#pragma GCC diagnostic ignored "-Wgnu"


static NSString *const AutocodingException = @"AutocodingException";


@implementation NSObject (AutoCoding)

+ (BOOL)supportsSecureCoding
{
    return YES;
}

+ (instancetype)objectWithContentsOfFile:(NSString *)filePath
{
    //load the file
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    //attempt to deserialise data as a plist
    id object = nil;
    if (data)
    {
        NSPropertyListFormat format;
        object = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:&format error:NULL];
        
		//success?
		if (object)
		{
			//check if object is an NSCoded unarchive
			if ([object respondsToSelector:@selector(objectForKey:)] && [(NSDictionary *)object objectForKey:@"$archiver"])
			{
				object = [NSKeyedUnarchiver unarchiveObjectWithData:data];
			}
		}
		else
		{
			//return raw data
			object = data;
		}
    }
    
	//return object
	return object;
}

- (BOOL)writeToFile:(NSString *)filePath atomically:(BOOL)useAuxiliaryFile
{
    //note: NSData, NSDictionary and NSArray already implement this method
    //and do not save using NSCoding, however the objectWithContentsOfFile
    //method will correctly recover these objects anyway
    
    //archive object
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    return [data writeToFile:filePath atomically:useAuxiliaryFile];
}

+ (NSDictionary *)codableProperties
{
    //deprecated
    SEL deprecatedSelector = NSSelectorFromString(@"codableKeys");
    if ([self respondsToSelector:deprecatedSelector] || [self instancesRespondToSelector:deprecatedSelector])
    {
        NSLog(@"AutoCoding Warning: codableKeys method is no longer supported. Use codableProperties instead.");
    }
    deprecatedSelector = NSSelectorFromString(@"uncodableKeys");
    if ([self respondsToSelector:deprecatedSelector] || [self instancesRespondToSelector:deprecatedSelector])
    {
        NSLog(@"AutoCoding Warning: uncodableKeys method is no longer supported. Use ivars, or synthesize your properties using non-KVC-compliant names to avoid coding them instead.");
    }
    deprecatedSelector = NSSelectorFromString(@"uncodableProperties");
    NSArray *uncodableProperties = nil;
    if ([self respondsToSelector:deprecatedSelector] || [self instancesRespondToSelector:deprecatedSelector])
    {
        uncodableProperties = [self valueForKey:@"uncodableProperties"];
        NSLog(@"AutoCoding Warning: uncodableProperties method is no longer supported. Use ivars, or synthesize your properties using non-KVC-compliant names to avoid coding them instead.");
    }
    
    unsigned int propertyCount;
    __autoreleasing NSMutableDictionary *codableProperties = [NSMutableDictionary dictionary];
    objc_property_t *properties = class_copyPropertyList(self, &propertyCount);
    for (unsigned int i = 0; i < propertyCount; i++)
    {
        //get property name
        objc_property_t property = properties[i];
        const char *propertyName = property_getName(property);
        __autoreleasing NSString *key = @(propertyName);
        
        //check if codable
        if (![uncodableProperties containsObject:key])
        {
            //get property type
            Class propertyClass = nil;
            char *typeEncoding = property_copyAttributeValue(property, "T");
            switch (typeEncoding[0])
            {
                case '@':
                {
                    if (strlen(typeEncoding) >= 3)
                    {
                        char *className = strndup(typeEncoding + 2, strlen(typeEncoding) - 3);
                        __autoreleasing NSString *name = @(className);
                        NSRange range = [name rangeOfString:@"<"];
                        if (range.location != NSNotFound)
                        {
                            name = [name substringToIndex:range.location];
                        }
                        propertyClass = NSClassFromString(name) ?: [NSObject class];
                        free(className);
                    }
                    break;
                }
                case 'c':
                case 'i':
                case 's':
                case 'l':
                case 'q':
                case 'C':
                case 'I':
                case 'S':
                case 'L':
                case 'Q':
                case 'f':
                case 'd':
                case 'B':
                {
                    propertyClass = [NSNumber class];
                    break;
                }
                case '{':
                {
                    propertyClass = [NSValue class];
                    break;
                }
            }
            free(typeEncoding);
            
            if (propertyClass)
            {
                //check if there is a backing ivar
                char *ivar = property_copyAttributeValue(property, "V");
                if (ivar)
                {
                    //check if ivar has KVC-compliant name
                    __autoreleasing NSString *ivarName = @(ivar);
                    if ([ivarName isEqualToString:key] || [ivarName isEqualToString:[@"_" stringByAppendingString:key]])
                    {
                        //no setter, but setValue:forKey: will still work
                        codableProperties[key] = propertyClass;
                    }
                    free(ivar);
                }
                else
                {
                    //check if property is dynamic and readwrite
                    char *dynamic = property_copyAttributeValue(property, "D");
                    char *readonly = property_copyAttributeValue(property, "R");
                    if (dynamic && !readonly)
                    {
                        //no ivar, but setValue:forKey: will still work
                        codableProperties[key] = propertyClass;
                    }
                    free(dynamic);
                    free(readonly);
                }
            }
        }
    }
    
    free(properties);
    return codableProperties;
}

- (NSDictionary *)codableProperties
{
    __autoreleasing NSDictionary *codableProperties = objc_getAssociatedObject([self class], _cmd);
    if (!codableProperties)
    {
        codableProperties = [NSMutableDictionary dictionary];
        Class subclass = [self class];
        while (subclass != [NSObject class])
        {
            [(NSMutableDictionary *)codableProperties addEntriesFromDictionary:[subclass codableProperties]];
            subclass = [subclass superclass];
        }
        codableProperties = [NSDictionary dictionaryWithDictionary:codableProperties];
        
        //make the association atomically so that we don't need to bother with an @synchronize
        objc_setAssociatedObject([self class], _cmd, codableProperties, OBJC_ASSOCIATION_RETAIN);
    }
    return codableProperties;
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (__unsafe_unretained NSString *key in [self codableProperties])
    {
        id value = [self valueForKey:key];
        if (value) dict[key] = value;
    }
    return dict;
}

- (void)setWithCoder:(NSCoder *)aDecoder
{
    BOOL secureAvailable = [aDecoder respondsToSelector:@selector(decodeObjectOfClass:forKey:)];
    BOOL secureSupported = [[self class] supportsSecureCoding];
    NSDictionary *properties = [self codableProperties];
    for (NSString *key in properties)
    {
        id object = nil;
        Class propertyClass = properties[key];
        if (secureAvailable)
        {
            object = [aDecoder decodeObjectOfClass:propertyClass forKey:key];
        }
        else
        {
            object = [aDecoder decodeObjectForKey:key];
        }
        if (object)
        {
            if (secureSupported && ![object isKindOfClass:propertyClass])
            {
                [NSException raise:AutocodingException format:@"Expected '%@' to be a %@, but was actually a %@", key, propertyClass, [object class]];
            }
            [self setValue:object forKey:key];
        }
    }
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    [self setWithCoder:aDecoder];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    for (NSString *key in [self codableProperties])
    {
        id object = [self valueForKey:key];
        if (object) [aCoder encodeObject:object forKey:key];
    }
}

@end






