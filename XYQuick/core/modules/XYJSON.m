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

#import "XYJSON.h"

#define kNSObjectProtocolProperties @[@"hash", @"superclass", @"description", @"debugDescription"]

static void __uxy_swizzleInstanceMethod(Class c, SEL original, SEL replacement);


#pragma mark - XYJSONParser_2

@interface XYJSONParser_2 : NSObject

@property (nonatomic, strong) NSMutableDictionary *allJSONKeyProperties;

+ (id)objectByClass:(Class)classType withJSONObject:(id)JSONObject;

@end

@implementation XYJSONParser_2

static dispatch_once_t __singletonToken;
static id __singleton__;
+ (instancetype)sharedInstance
{
    dispatch_once( &__singletonToken, ^{ __singleton__ = [[self alloc] init]; } );
    return __singleton__;
}

- (NSMutableDictionary *)JSONKeyPropertiesOfClass:(Class)classType
{
    NSString *key = [NSString stringWithFormat:@"%@", classType];
    NSMutableDictionary *dic = self.allJSONKeyProperties[key];
    if (!dic)
    {
        dic = [@{} mutableCopy];
        if ([classType uxy_hasSuperProperties] && ![[classType superclass] isMemberOfClass:[NSObject class]])
        {
            [dic setValuesForKeysWithDictionary:[[classType superclass] uxy_JSONKeyProperties]];
        }
       // [XYJSONParser_2 __swizzleInstanceMethodWithClass:classType originalSel:@selector(valueForUndefinedKey:) replacementSel:@selector(__uxy_valueForUndefinedKey:)];
       // [XYJSONParser_2 __swizzleInstanceMethodWithClass:classType originalSel:@selector(setValue:forUndefinedKey:) replacementSel:@selector(__uxy_setValue:forUndefinedKey:)];
        
        NSArray *properties = [self __propertiesOfClass:classType];
        [properties enumerateObjectsUsingBlock:^(NSString *propertyName, NSUInteger idx, BOOL *stop) {
            NSString *typeName = [self propertyConformsToProtocol:@protocol(XYJSONAutoBinding) propertyName:propertyName classType:classType];
            typeName = typeName ?: propertyName;
            
            [dic setObject:typeName forKey:propertyName];
        }];
        
        if ([self conformsToProtocol:@protocol(NSObject)])
        {
            [dic removeObjectsForKeys:kNSObjectProtocolProperties];
        }
        
        self.allJSONKeyProperties[key] = dic;
    }
    
    return dic;
}

- (NSArray *)__propertiesOfClass:(Class)classType
{
    NSMutableArray  *propertyNames = [[NSMutableArray alloc] init];
    id              obj            = objc_getClass([NSStringFromClass(classType) cStringUsingEncoding:4]);
    unsigned int    outCount, i;
    objc_property_t *properties    = class_copyPropertyList(obj, &outCount);
    for (i = 0; i < outCount; i++)
    {
        objc_property_t property      = properties[i];
        NSString        *propertyName = [NSString stringWithCString:property_getName(property) encoding:4];
        [propertyNames addObject:propertyName];
    }
    free(properties);
    
    return propertyNames;
}

- (NSMutableDictionary *)allJSONKeyProperties
{
    return _allJSONKeyProperties ?: ({ _allJSONKeyProperties = [@{} mutableCopy], _allJSONKeyProperties; });
}

- (NSString *)propertyConformsToProtocol:(Protocol *)protocol propertyName:(NSString *)propertyName classType:(Class)classType
{
    objc_property_t property = class_getProperty(classType, [propertyName UTF8String]);
    NSString *typeName = property ? [NSString stringWithUTF8String:(property_getAttributes(property))] : nil;
    if (!typeName) return nil;
    
    NSRange range = [typeName rangeOfString:@","];
    if (range.location == NSNotFound) return nil;
    
    typeName = [typeName substringToIndex:range.location];
    typeName = [typeName stringByReplacingOccurrencesOfString:@"T@" withString:@""];
    typeName = [typeName stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    // NSArray对象符合自动绑定协议的
    range = [typeName rangeOfString:@"Array"];
    if (range.location != NSNotFound)
    {
        // todo, array对象里有多个协议
        NSRange beginRange = [typeName rangeOfString:@"<"];
        NSRange endRange   = [typeName rangeOfString:@">"];
        if (beginRange.location != NSNotFound && endRange.location != NSNotFound)
        {
            NSString *protocalName = [typeName substringWithRange:NSMakeRange(beginRange.location + beginRange.length, endRange.location - beginRange.location - 1)];
            if (NSClassFromString(protocalName))
            {
                return protocalName;
            }
        }
    }
    
    // 普通对象符合自动绑定协议的
    if ([NSClassFromString(typeName) conformsToProtocol:protocol])
    {
        return typeName;
    }
    
    return nil;
}

+ (id)objectByClass:(Class)classType withJSONObject:(id)JSONObject
{
    if ([JSONObject isKindOfClass:[NSArray class]])
    {
        NSMutableArray *models = [@[] mutableCopy];
        [JSONObject enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            id model = [XYJSONParser_2 objectByClass:classType withJSONObject:obj];
            if (!model)
                return ;
            
            [models addObject:model];
        }];
        
        return models;
    }
    else if ([JSONObject isKindOfClass:[NSDictionary class]])
    {
        return [XYJSONParser_2 __objectByClass:classType withJSONObject:JSONObject];
    }
    
    return nil;
}


+ (void)__swizzleInstanceMethodWithClass:(Class)clazz originalSel:(SEL)original replacementSel:(SEL)replacement
{
    Method a = class_getInstanceMethod(clazz, original);
    Method b = class_getInstanceMethod(clazz, replacement);
    if (class_addMethod(clazz, original, method_getImplementation(b), method_getTypeEncoding(b)))
    {
        class_replaceMethod(clazz, replacement, method_getImplementation(a), method_getTypeEncoding(a));
    }
    else
    {
        method_exchangeImplementations(a, b);
    }
}

+ (Class)__classForString:(NSString *)string valueKey:(NSString **)key
{
    if (string.length == 0)
        return nil;
    
    if ([string rangeOfString:@"."].length == 0)
        return NSClassFromString(string);
    
    NSArray *strings = [string componentsSeparatedByString:@"."];
    if (strings.count < 2)
        return nil;
    
    *key = strings.firstObject;
    return NSClassFromString(strings.lastObject);
}

+ (id)__objectByClass:(Class)classType withJSONObject:(id)JSONObject
{
    if (!classType)
        return nil;
    
    if (![JSONObject isKindOfClass:[NSDictionary class]])
    {
        return nil;
    }
    
    NSDictionary *properties = [[ XYJSONParser_2 sharedInstance] JSONKeyPropertiesOfClass:classType];
    
    id model = [[classType alloc] init];
    
    [properties enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        id value = [JSONObject valueForKeyPath:key];
        
        if ([value isKindOfClass:[NSArray class]])
        {
            NSString *valueKey = nil;
            Class clazz = [self __classForString:obj valueKey:&valueKey];
            if (clazz)
            {
                NSArray *array = [self objectByClass:clazz withJSONObject:value];
                if (array.count)
                {
                    key = valueKey ?: key;
                    [model setValue:array forKey:key];
                }
            }
            else
            {
                [model setValue:[JSONObject valueForKeyPath:key] forKey:obj];
            }
            
            return ;
        }
        
        if ([value isKindOfClass:[NSDictionary class]])
        {
            NSString *valueKey = nil;
            Class otherClass = [self __classForString:obj valueKey:&valueKey];
            if (otherClass)
            {
                id object = [self objectByClass:otherClass withJSONObject:value];
                if (object)
                {
                    key = valueKey ?: key;
                    [model setValue:object forKeyPath:key];
                }
            }
            else
            {
                [model setValue:value forKey:obj];
            }
            
            return;
        }
        
        
        if (![value isKindOfClass:[NSNull class]] && value != nil)
        {
            [model setValue:value forKey:obj];
        }
        
        return;
    }];
    
    return model;

}
@end


#pragma mark - NSObject (XYJSON_2)

@implementation NSObject (XYJSON_2)

+ (BOOL)uxy_hasSuperProperties
{
    return NO;
}

+ (NSDictionary *)uxy_JSONKeyProperties
{
    return [[XYJSONParser_2 sharedInstance] JSONKeyPropertiesOfClass:self];
}
+ (void)uxy_bindJSONKey:(NSString *)JSONKey toProperty:(NSString *)property
{
    NSMutableDictionary *dic = [[XYJSONParser_2 sharedInstance] JSONKeyPropertiesOfClass:[self class]];
    [dic removeObjectForKey:property];
    [dic setObject:property forKey:JSONKey];
}

+ (void)uxy_removeJSONKeyWithProperty:(NSString *)property
{
    NSMutableDictionary *dic = [[XYJSONParser_2 sharedInstance] JSONKeyPropertiesOfClass:[self class]];
    [dic removeObjectForKey:property];
}

@end


#pragma mark - NSData (XYJSON_2)

@implementation NSData (XYJSON_2)

static const char * XYJSON_keepJSONObjectCache = "XYJSON_keepJSONObjectCache";
- (void)setUxy_keepJSONObjectCache:(BOOL)uxy_keepJSONObjectCache
{
    objc_setAssociatedObject(self, XYJSON_keepJSONObjectCache, @(uxy_keepJSONObjectCache), OBJC_ASSOCIATION_ASSIGN);
    if (!uxy_keepJSONObjectCache)
    {
        self.uxy_JSONObjectCache = nil;
    }
}
- (BOOL)uxy_keepJSONObjectCache
{
    return [objc_getAssociatedObject(self, XYJSON_keepJSONObjectCache) boolValue];
}

static const char * XYJSON_JSONObjectCache = "XYJSON_JSONObjectCache";
- (void)setUxy_JSONObjectCache:(id)uxy_JSONObjectCache
{
    objc_setAssociatedObject(self, XYJSON_JSONObjectCache, uxy_JSONObjectCache, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (id)uxy_JSONObjectCache
{
    return objc_getAssociatedObject(self, XYJSON_JSONObjectCache);
}

- (NSString *)uxy_JSONString
{
    return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
}

- (id)uxy_JSONObject
{
    if (!self.uxy_keepJSONObjectCache)
    {
       return [self uxy_JSONObjectForKeyPath:nil];
    }
    
    if (!self.uxy_JSONObjectCache)
    {
        self.uxy_JSONObjectCache = [self uxy_JSONObjectForKeyPath:nil];
    }

    return self.uxy_JSONObjectCache;
}

- (id)uxy_JSONObjectByClass:(Class)classType
{
    return [self uxy_JSONObjectByClass:classType forKeyPath:nil];
}


- (id)uxy_JSONObjectByClass:(Class)classType forKeyPath:(NSString *)keyPath
{
    if (classType == nil)
        return nil;
    
    id JSONValue = [self uxy_JSONObjectForKeyPath:keyPath];
    
    if (JSONValue == nil)
        return nil;
    
    return [XYJSONParser_2 objectByClass:classType withJSONObject:JSONValue];
}

- (id)uxy_JSONObjectForKeyPath:(NSString *)keyPath
{
    NSError *error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:self options:JSON_string_options error:&error];
    
#ifdef DEBUG
    if (error != nil) NSLog(@"%@", error);
#endif
    
    if (error != nil)
        return nil;
    
    if ([result isKindOfClass:[NSDictionary class]] && keyPath)
    {
        return result[keyPath];
    }
    
    return result;
}

@end

#pragma mark - NString (XYJSON_2)

@implementation NSString (XYJSON_2)

static const char * XYJSON_keepJSONObjectCache2 = "XYJSON_keepJSONObjectCache2";
- (void)setUxy_keepJSONObjectCache:(BOOL)uxy_keepJSONObjectCache
{
    objc_setAssociatedObject(self, XYJSON_keepJSONObjectCache2, @(uxy_keepJSONObjectCache), OBJC_ASSOCIATION_ASSIGN);
    if (!uxy_keepJSONObjectCache)
    {
        self.uxy_JSONObjectCache = nil;
    }
}
- (BOOL)uxy_keepJSONObjectCache
{
    return [objc_getAssociatedObject(self, XYJSON_keepJSONObjectCache2) boolValue];
}

static const char * XYJSON_JSONObjectCache2 = "XYJSON_JSONObjectCache2";
- (void)setUxy_JSONObjectCache:(id)uxy_JSONObjectCache
{
    objc_setAssociatedObject(self, XYJSON_JSONObjectCache2, uxy_JSONObjectCache, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (id)uxy_JSONObjectCache
{
    return objc_getAssociatedObject(self, XYJSON_JSONObjectCache2);
}

- (id)uxy_JSONObject
{
    if (!self.uxy_keepJSONObjectCache)
    {
        return [[self dataUsingEncoding:NSUTF8StringEncoding] uxy_JSONObjectForKeyPath:nil];
    }
    
    if (!self.uxy_JSONObjectCache)
    {
        self.uxy_JSONObjectCache = [[self dataUsingEncoding:NSUTF8StringEncoding] uxy_JSONObjectForKeyPath:nil];
    }
    
    return self.uxy_JSONObjectCache;
}

- (id)uxy_JSONObjectByClass:(Class)classType
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] uxy_JSONObjectByClass:classType];
}

- (id)uxy_JSONObjectByClass:(Class)classType forKeyPath:(NSString *)keyPath
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] uxy_JSONObjectByClass:classType forKeyPath:keyPath];
}

@end


#pragma mark - NSDictionary (XYJSON_2)
@implementation NSDictionary (XYJSON_2)

- (NSString *)uxy_JSONString
{
    NSData *JSONData = self.uxy_JSONData;
    
    return JSONData ? [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding] : nil;
}

- (NSData *)uxy_JSONData
{
    if ([NSJSONSerialization isValidJSONObject:self])
    {
        NSError *error;
        NSData  *JSONData = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];
        if (!error)
            return JSONData;
    }
#ifdef DEBUG
    else
    {
        NSError *error;
        [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];
        if (error != nil) NSLog(@"<# [ ERROR ] #>%@", error);
    }
#endif
    
    return nil;
}

- (id)uxy_JSONObjectByClass:(Class)classType
{
    
}
- (id)uxy_JSONObjectByClass:(Class)classType forKeyPath:(NSString *)keyPath
{
    
}

@end


/*
#pragma mark -
#pragma mark - NSObject (__XYJSON)
@interface NSObject (__XYJSON)

const char *__uxy_property_getTypeString(objc_property_t property);
// 返回属性列表
- (NSArray *)__uxy_JSONPropertiesOfClass:(Class)classType;
// 返回符合协议的属性
+ (NSString *)__uxy_propertyConformsToProtocol:(Protocol *)protocol propertyName:(NSString *)propertyName;

+ (NSDateFormatter *)__uxy_JSONDateFormatter;

@end

#pragma mark - NSDictionary (__XYJSON)
@interface NSDictionary (__XYJSON)
- (id)__uxy_objectForKey:(id)key;
@end

#pragma mark - XYJSONParser
@implementation XYJSONParser

- (instancetype)initWithKey:(NSString *)key clazz:(Class)clazz
{
    self = [super init];
    if (self)
    {
        self.key    = key;
        self.clazz  = clazz;
    }
    return self;
}

+ (instancetype)objectWithKey:(NSString *)key clazz:(Class)clazz
{
    return [[self alloc] initWithKey:key clazz:clazz];
}


- (id)smartResult
{
    if ([_result isKindOfClass:[NSArray class]])
    {
        NSArray *array = (NSArray *) _result;
        if (array.count == 1)
        {
            return array.firstObject;
        }
    }
    return _result;
}
@end

#pragma mark - NSObject (XYJSON)
@implementation NSObject (XYJSON)

// 待重构
static NSMutableDictionary *XY_JSON_OBJECT_KEYDICTS = nil;

+ (BOOL)uxy_hasSuperProperties
{
    return NO;
}

+ (NSDictionary *)uxy_JSONKeyProperties
{
    return [self __uxy_JSONKeyProperties];
}

+ (NSMutableDictionary *)__uxy_JSONKeyProperties
{
    if (!XY_JSON_OBJECT_KEYDICTS)
    {
        XY_JSON_OBJECT_KEYDICTS = [[NSMutableDictionary alloc] init];
    }
    
    NSString *objectKey = [NSString stringWithFormat:@"XY_JSON_%@", NSStringFromClass([self class])];
    NSMutableDictionary *dictionary = [XY_JSON_OBJECT_KEYDICTS __uxy_objectForKey:objectKey];
    if (!dictionary)
    {
        dictionary = [[NSMutableDictionary alloc] init];
        if ([self uxy_hasSuperProperties] && ![[self superclass] isMemberOfClass:[NSObject class]])
        {
            [dictionary setValuesForKeysWithDictionary:[[self superclass] uxy_JSONKeyProperties]];
        }
        
        __uxy_swizzleInstanceMethod(self, @selector(valueForUndefinedKey:), @selector(__uxy_valueForUndefinedKey:));
        __uxy_swizzleInstanceMethod(self, @selector(setValue:forUndefinedKey:), @selector(__uxy_setValue:forUndefinedKey:));
        
        NSArray *properties = [self __uxy_JSONPropertiesOfClass:[self class]];
        [properties enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *typeName = [self __uxy_propertyConformsToProtocol:@protocol(XYJSONAutoBinding) propertyName:obj];
            if (typeName)
            {
                [dictionary setObject:typeName forKey:obj];
            }
            else
            {
                [dictionary setObject:obj forKey:obj];
            }
        }];
        
        if ([self conformsToProtocol:@protocol(NSObject)])
        {
            [dictionary removeObjectsForKeys:kNSObjectProtocolProperties];
        }
        
        [XY_JSON_OBJECT_KEYDICTS setObject:dictionary forKey:objectKey];
    }
    
    return dictionary;
}

+ (void)uxy_bindJSONKey:(NSString *)JSONKey toProperty:(NSString *)property
{
    NSMutableDictionary *dic = [self __uxy_JSONKeyProperties];
    [dic removeObjectForKey:property];
    [dic setObject:property forKey:JSONKey];
}

+ (void)uxy_removeJSONKeyWithProperty:(NSString *)property
{
    NSMutableDictionary *dic = [self __uxy_JSONKeyProperties];
    [dic removeObjectForKey:property];
}

- (NSString *)uxy_JSONString
{
    return self.uxy_JSONDictionary.uxy_JSONString;
}

- (NSData *)uxy_JSONData
{
    if ([NSJSONSerialization isValidJSONObject:self])
    {
        NSError *error;
        NSData  *JSONData = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];
        if (!error) return JSONData;
    }
#ifdef DEBUG
    else
    {
        NSError *error;
        [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];
        if (error != nil) NSLog(@"<# [ ERROR ] #>%@", error);
    }
#endif
    return self.uxy_JSONDictionary.uxy_JSONData;
}


// 应该比较脆弱，不支持太复杂的对象。
- (NSDictionary *)uxy_JSONDictionary
{
    if ([self isKindOfClass:[NSString class]])
    {
        return [(NSString *)self uxy_JSONValue];
    }
    
    NSDictionary        *keyDict  = [self.class uxy_JSONKeyProperties];
    NSMutableDictionary *JSONDict = [[NSMutableDictionary alloc] initWithCapacity:keyDict.count];
    [keyDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        id value         = nil;
        id originalValue = [self valueForKey:key];
        if (NSClassFromString(obj))
        {
            if ([originalValue isKindOfClass:[NSArray class]])
            {
                value = [[originalValue uxy_JSONData] uxy_JSONString];
                //value = @{key : [[originalValue uxy_JSONData] uxy_JSONString]};
            }
            else
            {
                value = [originalValue uxy_JSONDictionary];
            }
        }
        else
        {
            value = [self valueForKey:obj];
        }
        if (value)
        {
            if ([value isKindOfClass:[NSDate class]]) {
                NSDateFormatter * formatter = [NSObject __uxy_JSONDateFormatter];
                value = [formatter stringFromDate:value];
            }
            [JSONDict setValue:value forKey:key];
        }
    }];
    return JSONDict;
}

// 待重构
static void __uxy_swizzleInstanceMethod(Class c, SEL original, SEL replacement)
{
    Method a = class_getInstanceMethod(c, original);
    Method b = class_getInstanceMethod(c, replacement);
    if (class_addMethod(c, original, method_getImplementation(b), method_getTypeEncoding(b)))
    {
        class_replaceMethod(c, replacement, method_getImplementation(a), method_getTypeEncoding(a));
    }
    else
    {
        method_exchangeImplementations(a, b);
    }
}

- (id)__uxy_valueForUndefinedKey:(NSString *)key
{
#ifdef DEBUG
    // NSLog(@"%@ undefinedKey %@", self.class, key);
#endif
    return nil;
}

- (void)__uxy_setValue:(id)value forUndefinedKey:(NSString *)key
{
#ifdef DEBUG
    // NSLog(@"%@ undefinedKey %@ and value is %@", self.class, key, value);
#endif
}

- (NSArray *)uxy_toModels:(Class)classType
{
    return nil;
}

- (NSArray *)uxy_toModels:(Class)classType forKey:(NSString *)key
{
    return nil;
}

- (id)uxy_toModel:(Class)classType
{
    return nil;
}

- (id)uxy_toModel:(Class)classType forKey:(NSString *)key
{
    return nil;
}

@end


#pragma mark - NSObject (Properties)
@implementation NSObject (Properties)
- (NSArray *)__uxy_JSONPropertiesOfClass:(Class)classType
{
    NSMutableArray  *propertyNames = [[NSMutableArray alloc] init];
    id              obj            = objc_getClass([NSStringFromClass(classType) cStringUsingEncoding:4]);
    unsigned int    outCount, i;
    objc_property_t *properties    = class_copyPropertyList(obj, &outCount);
    for (i = 0; i < outCount; i++)
    {
        objc_property_t property      = properties[i];
        NSString        *propertyName = [NSString stringWithCString:property_getName(property) encoding:4];
        [propertyNames addObject:propertyName];
    }
    free(properties);
    
    return propertyNames;
}

+ (NSString *)__uxy_propertyConformsToProtocol:(Protocol *)protocol propertyName:(NSString *)propertyName
{
    NSString *typeName = [self __uxy_typeOfPropertyNamed:propertyName];
    if (!typeName) return nil;
    
    typeName = [typeName stringByReplacingOccurrencesOfString:@"T@" withString:@""];
    typeName = [typeName stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    // nsarray对象符合自动绑定协议的
    NSRange range = [typeName rangeOfString:@"Array"];
    if (range.location != NSNotFound)
    {
        // todo, array对象里有多个协议
        NSRange beginRange = [typeName rangeOfString:@"<"];
        NSRange endRange   = [typeName rangeOfString:@">"];
        if (beginRange.location != NSNotFound && endRange.location != NSNotFound)
        {
            NSString *protocalName = [typeName substringWithRange:NSMakeRange(beginRange.location + beginRange.length, endRange.location - beginRange.location - 1)];
            if (NSClassFromString(protocalName))
            {
                return protocalName;
            }
        }
    }
    
    // 普通对象符合自动绑定协议的
    if ([NSClassFromString(typeName) conformsToProtocol:protocol])
    {
        return typeName;
    }
    
    return nil;
}

+ (NSString *)__uxy_typeOfPropertyNamed:(NSString *)name
{
    objc_property_t property = class_getProperty(self, [name UTF8String]);
    return property ? [NSString stringWithUTF8String:(__uxy_property_getTypeString(property))] : nil;
}
@end

#pragma mark - NSObject (XYJSON_helper)
@implementation NSObject (XYJSON_helper)
+ (NSDateFormatter *)__uxy_JSONDateFormatter
{
    NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *dateFormatter = threadDictionary[@"__uxy_JSONDateFormatter"];
    
    if(!dateFormatter)
    {
        @synchronized(self)
        {
            if(!dateFormatter)
            {
                dateFormatter            = [[NSDateFormatter alloc] init];
                dateFormatter.timeZone   = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
                dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
                threadDictionary[@"__uxy_JSONDateFormatter"] = dateFormatter;
            }
        }
    }
    
    return dateFormatter;
}
@end

const char *__uxy_property_getTypeString(objc_property_t property)
{
    const char *attrs = property_getAttributes(property);
    if (attrs == NULL )
        return (NULL);
    
    static char buffer[256];
    const char *e = strchr(attrs, ',');
    if (e == NULL )
        return (NULL);
    
    int len = (int)(e - attrs);
    memcpy( buffer, attrs, len );
    buffer[len] = '\0';
    
    return (buffer);
}

#pragma mark - NSString (XYJSON)
@implementation NSString (XYJSON)
- (id)uxy_toModel:(Class)classType
{
    return [self.__uxy_toData uxy_toModel:classType];
}

- (id)uxy_toModel:(Class)classType forKey:(NSString *)JSONKey
{
    return [self.__uxy_toData uxy_toModel:classType forKey:JSONKey];
}

- (NSArray *)uxy_toModels:(Class)classType
{
    return [self.__uxy_toData uxy_toModels:classType];
}

- (NSArray *)uxy_toModels:(Class)classType forKey:(NSString *)JSONKey
{
    return [self.__uxy_toData uxy_toModels:classType forKey:JSONKey];
}



- (id)uxy_JSONValue
{
    return self.__uxy_toData.uxy_JSONValue;
}

- (void)uxy_parseToObjectWithParsers:(NSArray *)parsers
{
    [self.__uxy_toData uxy_parseToObjectWithParsers:parsers];
}
#pragma mark - private
- (NSData *)__uxy_toData
{
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}
@end

#pragma mark - NSDictionary (XYJSON)
@implementation NSDictionary (XYJSON)
- (NSString *)uxy_JSONString
{
    NSData *JSONData = self.uxy_JSONData;

    return JSONData ? [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding] : nil;
}

- (id)__uxy_objectForKey:(id)key
{
    return key ? [self objectForKey:key] : nil;
}
@end


#pragma mark - NSData (XYJSON)
@implementation NSData (XYJSON)

- (id)uxy_toModel:(Class)classType
{
    return [self uxy_toModel:classType forKey:nil];
}

- (id)uxy_toModel:(Class)classType forKey:(NSString *)key
{
    if (classType == nil)
        return nil;
    
    id JSONValue = [self __uxy_JSONValueForKey:key];
    if (JSONValue == nil)
        return nil;
    
    NSDictionary *dic = [classType uxy_JSONKeyProperties];
    id model          = [NSData __uxy_objectForClassType:classType fromDict:JSONValue withJSONKeyProperties:dic];
    
    return model;
}

- (NSArray *)uxy_toModels:(Class)classType
{
    return [self uxy_toModels:classType forKey:nil];
}

- (NSArray *)uxy_toModels:(Class)classType forKey:(NSString *)key
{
    if (classType == nil)
        return nil;
    
    id JSONValue = [self __uxy_JSONValueForKey:key];
    if (JSONValue == nil)
        return nil;
    
    NSDictionary *dic = [classType uxy_JSONKeyProperties];
    if ([JSONValue isKindOfClass:[NSArray class]])
    {
        NSMutableArray *models = [[NSMutableArray alloc] initWithCapacity:[JSONValue count]];
        [JSONValue enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            id model = [NSData __uxy_objectForClassType:classType fromDict:obj withJSONKeyProperties:dic];
            if (!model)
                return ;
            
            [models addObject:model];
        }];
        
        return models;
    }
    else if ([JSONValue isKindOfClass:[NSDictionary class]])
    {
        return [NSData __uxy_objectForClassType:classType fromDict:JSONValue withJSONKeyProperties:dic];
    }
    
    return nil;
}

- (id)uxy_JSONValue
{
    NSError *error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:self options:JSON_string_options error:&error];
    
#ifdef DEBUG
    if (error != nil) NSLog(@"%@", error);
#endif
    
    if (error != nil)
        return nil;
    
    return result;
}

+ (id)__uxy_objectsForClassType:(Class)classType fromArray:(NSArray *)array
{
    NSMutableArray *models = [[NSMutableArray alloc] initWithCapacity:array.count];
    NSDictionary *dic      = [classType uxy_JSONKeyProperties];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id model = [self __uxy_objectForClassType:classType fromDict:obj withJSONKeyProperties:dic];
        if (model)
        {
            [models addObject:model];
        }
    }];
    return models;
}

+ (id)__uxy_objectForClassType:(Class)classType
                      fromDict:(NSDictionary *)dict
 withJSONKeyProperties:(NSDictionary *)uxy_JSONKeyProperties
{
    if (![dict isKindOfClass:[NSDictionary class]])
    {
        return nil;
    }
    if (![uxy_JSONKeyProperties isKindOfClass:[NSDictionary class]])
    {
        return nil;
    }
    if (!classType)
    {
        return nil;
    }
    
    id model = [[classType alloc] init];
    
    [uxy_JSONKeyProperties enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([[dict valueForKeyPath:key] isKindOfClass:[NSArray class]])
        {
            if ([self __uxy_classForString:obj valueKey:nil])
            {
                NSString *valueKey = nil;
                NSArray *array = [self __uxy_objectsForClassType:[self __uxy_classForString:obj valueKey:&valueKey] fromArray:[dict valueForKeyPath:key]];
                if (array.count)
                {
                    if (valueKey)
                    {
                        key = valueKey;
                    }
                    [model setValue:array forKey:key];
                }
            }
            else
            {
                [model setValue:[dict valueForKeyPath:key] forKey:obj];
            }
            
            return ;
        }
        
        if ([[dict valueForKeyPath:key] isKindOfClass:[NSDictionary class]])
        {
            NSString *valueKey = nil;
            Class otherClass = [self __uxy_classForString:obj valueKey:&valueKey];
            if (otherClass)
            {
                id object = [self __uxy_objectForClassType:otherClass fromDict:[dict valueForKeyPath:key] withJSONKeyProperties:[otherClass uxy_JSONKeyProperties]];
                if (object)
                {
                    if (valueKey)
                    {
                        key = valueKey;
                    }
                    [model setValue:object forKeyPath:key];
                }
            }
            else
            {
                [model setValue:[dict valueForKeyPath:key] forKey:obj];
            }
            
            return;
        }
        
        id value = [dict valueForKeyPath:key];
        if (![value isKindOfClass:[NSNull class]] && value != nil)
        {
            [model setValue:value forKey:obj];
        }
        
        return;
    }];
    
    return model;
}

- (NSString *)uxy_JSONString
{
    return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
}

- (id)__uxy_JSONValueForKey:(NSString *)key
{
    id JSONValue = [self uxy_JSONValue];
    
    if (key && [JSONValue isKindOfClass:[NSDictionary class]])
    {
        return [JSONValue valueForKeyPath:key];
    }
    
    return JSONValue;
}

+ (Class)__uxy_classForString:(NSString *)string valueKey:(NSString **)key
{
    if (string.length == 0)
        return nil;
    
    if ([string rangeOfString:@"."].length == 0)
        return NSClassFromString(string);
    
    NSArray *strings = [string componentsSeparatedByString:@"."];
    if (strings.count < 2)
        return nil;
    
    *key = strings.firstObject;
    return NSClassFromString(strings.lastObject);
}

- (id)uxy_JSONValueForKeyPath:(NSString *)key
{
    id JSONValue = [self uxy_JSONValue];
    if (![JSONValue isKindOfClass:[NSDictionary class]])
        return nil;
    
    NSDictionary *dic = (NSDictionary *)JSONValue;
    return [dic valueForKeyPath:key];
}

- (NSDictionary *)uxy_dictionaryForKeyPaths:(NSArray *)keys
{
    id JSONValue = [self uxy_JSONValue];
    if (![JSONValue isKindOfClass:[NSDictionary class]])
        return nil;
    
    NSDictionary *dic = (NSDictionary *)JSONValue;
    NSMutableDictionary *JSONDic = [NSMutableDictionary dictionary];
    [keys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        id JSONValue = [dic valueForKeyPath:key];
        if (!JSONValue)
            return ;
        
        [JSONDic setObject:JSONValue forKey:key];
    }];
    
    return [JSONDic copy];
}

- (void)uxy_parseToObjectWithParsers:(NSArray *)parsers
{
    id JSONValue = [self uxy_JSONValue];
    if (![JSONValue isKindOfClass:[NSDictionary class]])
        return;
    
    [parsers enumerateObjectsUsingBlock:^(XYJSONParser *parser, NSUInteger idx, BOOL *stop) {
        id obj = [JSONValue objectForKey:parser.key];
        
        if (obj == nil)
            return;
        
        NSDictionary *dic = [parser.clazz uxy_JSONKeyProperties];
        
        if ([obj isKindOfClass:[NSArray class]])
        {
            NSMutableArray *models = [[NSMutableArray alloc] initWithCapacity:[JSONValue count]];
            [obj enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                id model = [NSData __uxy_objectForClassType:parser.clazz fromDict:obj withJSONKeyProperties:dic];
                if (!model)
                    return ;
                
                [models addObject:model];
            }];
            
            parser.result = models;
            return;
        }
        
        if ([obj isKindOfClass:[NSDictionary class]])
        {
            parser.result = [NSData __uxy_objectForClassType:parser.clazz fromDict:obj withJSONKeyProperties:dic];
            return;
        }
    }];
}

@end


#pragma mark - NSArray (XYJSON)
@implementation NSArray (XYJSON)

- (NSString *)uxy_JSONString
{
    return self.uxy_JSONData.uxy_JSONString;
}

//  循环集合将每个对象转为字典，得到字典集合，然后转为JSONData
- (NSData *)uxy_JSONData
{
    NSMutableArray *JSONDictionaries = [[NSMutableArray alloc] init];
    [self enumerateObjectsUsingBlock:^(NSObject *obj, NSUInteger idx, BOOL *stop) {
        [JSONDictionaries addObject:obj.uxy_JSONDictionary];
    }];
    
    if (![NSJSONSerialization isValidJSONObject:JSONDictionaries])
    {
#ifdef DEBUG
        NSError *error;
        [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];
        if (error != nil) NSLog(@"<# [ ERROR ] #>%@", error);
#endif
        return nil;
    }

    NSError *error;
    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:JSONDictionaries options:kNilOptions error:&error];

    return JSONData;
}

- (NSArray *)uxy_toModels:(Class)classType
{
    if (self.count == 0)
        return nil;
    
    NSDictionary *dic      = [classType uxy_JSONKeyProperties];
    NSMutableArray *models = [[NSMutableArray alloc] initWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id model = [NSData __uxy_objectForClassType:classType fromDict:obj withJSONKeyProperties:dic];
        if (!model)
            return ;

        [models addObject:model];
    }];
    return models;
}
@end
*/

