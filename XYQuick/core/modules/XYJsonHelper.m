//
//  XYJsonHelper.m
//  JoinShow
//
//  Created by Heaven on 14-9-9.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//


#import "XYJsonHelper.h"

#define kNSObjectProtocolProperties @[@"hash", @"superclass", @"description", @"debugDescription"]

#pragma mark - static
static void __uxy_swizzleInstanceMethod(Class c, SEL original, SEL replacement);

#pragma mark - NSObject (XYProperties)
@interface NSObject (XYProperties)

const char *property_getTypeString(objc_property_t property);
// 返回属性列表
- (NSArray *)__uxy_jsonPropertiesOfClass:(Class)classType;
// 返回符合协议的属性
+ (NSString *)__uxy_propertyConformsToProtocol:(Protocol *)protocol propertyName:(NSString *)propertyName;
@end

#pragma mark - NSObject (XYJsonHelper_helper)
@interface NSObject (XYJsonHelper_helper)
+ (NSDateFormatter *)__uxy_jsonDateFormatter;
@end
#pragma mark -
@interface NSDictionary (__XYJsonHelper)
- (id)__uxy_objectForKey:(id)key;
@end

#pragma mark - XYJsonParser
@implementation XYJsonParser
- (instancetype)initWithKey:(NSString *)key clazz:(Class)clazz single:(BOOL)single
{
    self = [super init];
    if (self)
    {
        self.key    = key;
        self.clazz  = clazz;
        self.single = single;
    }
    return self;
}

+ (instancetype)objectWithKey:(NSString *)key clazz:(Class)clazz single:(BOOL)single
{
    return [[self alloc] initWithKey:key clazz:clazz single:single];
}

+ (instancetype)objectWithKey:(NSString *)key clazz:(Class)clazz
{
    return [[self alloc] initWithKey:key clazz:clazz single:NO];
}

/**
 *   如果result是一个集合，并且只有一个元素，就直接返回集合中的元素。
 */
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

#pragma mark - NSObject (XYJsonHelper)
@implementation NSObject (XYJsonHelper)

// 待重构
static NSMutableDictionary *XY_JSON_OBJECT_KEYDICTS = nil;

+ (BOOL)uxy_hasSuperProperties
{
    return NO;
}

+ (NSDictionary *)uxy_jsonKeyPropertyDictionary
{
    return [self __uxy_jsonKeyPropertyDictionary];
}

+ (NSMutableDictionary *)__uxy_jsonKeyPropertyDictionary
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
            [dictionary setValuesForKeysWithDictionary:[[self superclass] uxy_jsonKeyPropertyDictionary]];
        }
        
        __uxy_swizzleInstanceMethod(self, @selector(valueForUndefinedKey:), @selector(__uxy_valueForUndefinedKey:));
        __uxy_swizzleInstanceMethod(self, @selector(setValue:forUndefinedKey:), @selector(__uxy_setValue:forUndefinedKey:));
        
        NSArray *properties = [self __uxy_jsonPropertiesOfClass:[self class]];
        [properties enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *typeName = [self __uxy_propertyConformsToProtocol:@protocol(XYJsonAutoBinding) propertyName:obj];
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

+ (void)uxy_bindJsonKey:(NSString *)jsonKey toProperty:(NSString *)property
{
    NSMutableDictionary *dic = [self __uxy_jsonKeyPropertyDictionary];
    [dic removeObjectForKey:property];
    [dic setObject:property forKey:jsonKey];
}

+ (void)uxy_removeJsonKeyWithProperty:(NSString *)property
{
    NSMutableDictionary *dic = [self __uxy_jsonKeyPropertyDictionary];
    [dic removeObjectForKey:property];
}

- (NSString *)uxy_jsonString
{
    return self.uxy_jsonDictionary.uxy_jsonString;
}

- (NSData *)uxy_jsonData
{
    if ([NSJSONSerialization isValidJSONObject:self])
    {
        NSError *error;
        NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];
        if (!error) return jsonData;
    }
#ifdef DEBUG
    else
    {
        NSError *error;
        [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];
        if (error != nil) NSLog(@"<# [ ERROR ] #>%@", error);
    }
#endif
    return self.uxy_jsonDictionary.uxy_jsonData;
}


// 应该比较脆弱，不支持太复杂的对象。
- (NSDictionary *)uxy_jsonDictionary
{
    NSDictionary        *keyDict  = [self.class uxy_jsonKeyPropertyDictionary];
    NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc] initWithCapacity:keyDict.count];
    [keyDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        id value         = nil;
        id originalValue = [self valueForKey:key];
        if (NSClassFromString(obj))
        {
            if ([originalValue isKindOfClass:[NSArray class]])
            {
                value = [[originalValue uxy_jsonData] uxy_jsonString];
                //value = @{key : [[originalValue uxy_jsonData] uxy_jsonString]};
            }
            else
            {
                value = [originalValue uxy_jsonDictionary];
            }
        }
        else
        {
            value = [self valueForKey:obj];
        }
        if (value)
        {
            if ([value isKindOfClass:[NSDate class]]) {
                NSDateFormatter * formatter = [NSObject __uxy_jsonDateFormatter];
                value = [formatter stringFromDate:value];
            }
            [jsonDict setValue:value forKey:key];
        }
    }];
    return jsonDict;
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
- (NSArray *)__uxy_jsonPropertiesOfClass:(Class)classType
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
    NSString *typeName = [self typeOfPropertyNamed:propertyName];
    if (!typeName) return nil;
    
    typeName      = [typeName stringByReplacingOccurrencesOfString:@"T@" withString:@""];
    typeName      = [typeName stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    NSRange range = [typeName rangeOfString:@"Array"];
    if (range.location != NSNotFound)
    {
        // nsarray对象符合自动绑定协议的
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
    
    if ([NSClassFromString(typeName) conformsToProtocol:protocol])
    {
        // 普通对象符合自动绑定协议的
        return typeName;
    }
    
    return nil;
}

+ (NSString *)typeOfPropertyNamed:(NSString *)name
{
    objc_property_t property = class_getProperty(self, [name UTF8String]);
    return property ? [NSString stringWithUTF8String:(property_getTypeString(property))] : nil;
}
@end

#pragma mark - NSObject (XYJsonHelper_helper)
@implementation NSObject (XYJsonHelper_helper)
+ (NSDateFormatter *)__uxy_jsonDateFormatter
{
    NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *dateFormatter = threadDictionary[@"__uxy_jsonDateFormatter"];
    
    if(!dateFormatter)
    {
        @synchronized(self)
        {
            if(!dateFormatter)
            {
                dateFormatter            = [[NSDateFormatter alloc] init];
                dateFormatter.timeZone   = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
                dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
                threadDictionary[@"__uxy_jsonDateFormatter"] = dateFormatter;
            }
        }
    }
    
    return dateFormatter;
}
@end

const char *property_getTypeString(objc_property_t property)
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

#pragma mark - NSString (XYJsonHelper)
@implementation NSString (XYJsonHelper)
- (id)uxy_toModel:(Class)classType
{
    return [self.__uxy_toData uxy_toModel:classType];
}

- (id)uxy_toModel:(Class)classType forKey:(NSString *)jsonKey
{
    return [self.__uxy_toData uxy_toModel:classType forKey:jsonKey];
}

- (NSArray *)uxy_toModels:(Class)classType
{
    return [self.__uxy_toData uxy_toModels:classType];
}

- (NSArray *)uxy_toModels:(Class)classType forKey:(NSString *)jsonKey
{
    return [self.__uxy_toData uxy_toModels:classType forKey:jsonKey];
}



- (id)uxy_jsonValue
{
    return self.__uxy_toData.uxy_jsonValue;
}

#pragma mark - private
- (NSData *)__uxy_toData
{
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}
@end

#pragma mark - NSDictionary (XYJsonHelper)
@implementation NSDictionary (XYJsonHelper)
- (NSString *)uxy_jsonString
{
    NSData *jsonData = self.uxy_jsonData;

    return jsonData ? [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] : nil;
}

- (id)__uxy_objectForKey:(id)key
{
    return key ? [self objectForKey:key] : nil;
}
@end


#pragma mark - NSData (XYJsonHelper)
@implementation NSData (XYJsonHelper)

- (id)uxy_toModel:(Class)classType
{
    return [self uxy_toModel:classType forKey:nil];
}

- (id)uxy_toModel:(Class)classType forKey:(NSString *)key
{
    if (classType == nil)
        return nil;
    
    id jsonValue = [self __uxy_jsonValueForKey:key];
    if (jsonValue == nil)
        return nil;
    
    NSDictionary *dic = [classType uxy_jsonKeyPropertyDictionary];
    id model          = [NSData objectForClassType:classType fromDict:jsonValue withJsonKeyPropertyDictionary:dic];
    
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
    
    id jsonValue = [self __uxy_jsonValueForKey:key];
    if (jsonValue == nil)
        return nil;
    
    NSDictionary *dic = [classType uxy_jsonKeyPropertyDictionary];
    if ([jsonValue isKindOfClass:[NSArray class]])
    {
        NSMutableArray *models = [[NSMutableArray alloc] initWithCapacity:[jsonValue count]];
        [jsonValue enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            id model = [NSData objectForClassType:classType fromDict:obj withJsonKeyPropertyDictionary:dic];
            if (model)
            {
                [models addObject:model];
            }
        }];
        
        return models;
    }
    else if ([jsonValue isKindOfClass:[NSDictionary class]])
    {
        return [NSData objectForClassType:classType fromDict:jsonValue withJsonKeyPropertyDictionary:dic];
    }
    
    return nil;
}

- (id)uxy_jsonValue
{
    NSError *error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:self options:Json_string_options error:&error];
    
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
    NSDictionary *dic      = [classType uxy_jsonKeyPropertyDictionary];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id model = [self objectForClassType:classType fromDict:obj withJsonKeyPropertyDictionary:dic];
        if (model)
        {
            [models addObject:model];
        }
    }];
    return models;
}

+ (id)objectForClassType:(Class)classType
                fromDict:(NSDictionary *)dict
         withJsonKeyPropertyDictionary:(NSDictionary *)uxy_jsonKeyPropertyDictionary
{
    if (![dict isKindOfClass:[NSDictionary class]])
    {
        return nil;
    }
    if (![uxy_jsonKeyPropertyDictionary isKindOfClass:[NSDictionary class]])
    {
        return nil;
    }
    if (!classType)
    {
        return nil;
    }
    
    id model = [[classType alloc] init];
    [uxy_jsonKeyPropertyDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
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
        }
        else if ([[dict valueForKeyPath:key] isKindOfClass:[NSDictionary class]])
        {
            NSString *valueKey = nil;
            Class otherClass = [self __uxy_classForString:obj valueKey:&valueKey];
            if (otherClass)
            {
                id object = [self objectForClassType:classType fromDict:[dict valueForKeyPath:key] withJsonKeyPropertyDictionary:[otherClass uxy_jsonKeyPropertyDictionary]];
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
        }
        else
        {
            id value = [dict valueForKeyPath:key];
            if (![value isKindOfClass:[NSNull class]] && value != nil)
            {
                [model setValue:value forKey:obj];
            }
        }
    }];
    return model;
}

- (NSString *)uxy_jsonString
{
    return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
}

- (id)__uxy_jsonValueForKey:(NSString *)key
{
    if (key && [[self uxy_jsonValue] isKindOfClass:[NSDictionary class]])
    {
        return [[self uxy_jsonValue] valueForKeyPath:key];
    }
    else
    {
        return [self uxy_jsonValue];
    }
}

+ (Class)__uxy_classForString:(NSString *)string valueKey:(NSString **)key
{
    if (string.length > 0)
    {
        if ([string rangeOfString:@"."].length>0)
        {
            NSArray *strings = [string componentsSeparatedByString:@"."];
            if (strings.count>1)
            {
                *key = strings.firstObject;
                return NSClassFromString(strings.lastObject);
            }
        }
        else
        {
            return NSClassFromString(string);
        }
    }
    return nil;
}

- (id)uxy_jsonValueForKeyPath:(NSString *)key
{
    id jsonValue = [self uxy_jsonValue];
    if ([jsonValue isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dic = (NSDictionary *)jsonValue;
        return [dic valueForKeyPath:key];
    }
    return nil;
}

- (NSDictionary *)uxy_dictionaryForKeyPaths:(NSArray *)keys
{
    id jsonValue = [self uxy_jsonValue];
    if ([jsonValue isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dic = (NSDictionary *)jsonValue;
        NSMutableDictionary *jsonDic = [NSMutableDictionary dictionary];
        [keys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
            id jsonValue = [dic valueForKeyPath:key];
            if (jsonValue)
            {
                [jsonDic setObject:jsonValue forKey:key];
            }
        }];
        return jsonDic;
    }
    return nil;
}

- (void)uxy_parseToObjectWithParsers:(NSArray *)parsers
{
    id jsonValue = [self uxy_jsonValue];
    if ([jsonValue isKindOfClass:[NSDictionary class]])
    {
        [parsers enumerateObjectsUsingBlock:^(XYJsonParser *parser, NSUInteger idx, BOOL *stop) {
            id obj = [jsonValue objectForKey:parser.key];
            id result = nil;
            //如果没有clazz，则说明不是Model，直接原样返回
            if (parser.clazz)
            {
                if (parser.single)
                {
                    result = [obj uxy_toModel:parser.clazz];
                }
                else
                {
                    if ([obj isKindOfClass:[NSDictionary class]])
                    {
                        result = [[(NSDictionary *)obj uxy_jsonString] uxy_toModel:parser.clazz];
                    }
                    else
                    {
                        result = [obj uxy_toModels:parser.clazz];
                    }
                }
            }
            else
            {
                result = obj;
            }
            parser.result = result;
        }];
    }
}

@end


#pragma mark - NSArray (XYJsonHelper)
@implementation NSArray (XYJsonHelper)

- (NSString *)uxy_jsonString
{
    return self.uxy_jsonData.uxy_jsonString;
}

//  循环集合将每个对象转为字典，得到字典集合，然后转为jsonData
- (NSData *)uxy_jsonData
{
    NSMutableArray *jsonDictionaries = [[NSMutableArray alloc] init];
    [self enumerateObjectsUsingBlock:^(NSObject *obj, NSUInteger idx, BOOL *stop) {
        [jsonDictionaries addObject:obj.uxy_jsonDictionary];
    }];
    if ([NSJSONSerialization isValidJSONObject:jsonDictionaries])
    {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionaries options:kNilOptions error:&error];
        if (!error)
        {
            return jsonData;
        }
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

- (NSArray *)uxy_toModels:(Class)classType
{
    if ([self isKindOfClass:[NSArray class]] && self.count > 0)
    {
        NSDictionary *dic      = [classType uxy_jsonKeyPropertyDictionary];
        NSMutableArray *models = [[NSMutableArray alloc] initWithCapacity:[self count]];
        [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            id model = [NSData objectForClassType:classType fromDict:obj withJsonKeyPropertyDictionary:dic];
            if (model)
            {
                [models addObject:model];
            }
        }];
        return models;
    }
    return nil;
}
@end