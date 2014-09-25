//
//  XYJSONHelper.m
//  JoinShow
//
//  Created by Heaven on 14-9-9.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//


#import "XYJSONHelper.h"


static void XY_swizzleInstanceMethod(Class c, SEL original, SEL replacement);

@interface NSObject (XYProperties)

const char *property_getTypeString(objc_property_t property);
// 根据传入的class返回属性集合
- (NSArray *)yyPropertiesOfClass:(Class)aClass;

+ (NSString *)propertyConformsToProtocol:(Protocol *)protocol propertyName:(NSString *)propertyName;
@end

#pragma mark - NSObject (XYJSONHelper)
@implementation NSObject (XYJSONHelper)

static NSMutableDictionary *XY_JSON_OBJECT_KEYDICTS = nil;
static NSDateFormatter *XY_JSON_OBJECT_NSDateFormatter = nil;


+ (BOOL)hasSuperProperties
{
    return NO;
}

+ (NSDictionary *)XYJSONKeyDict
{
    return [self __XYJSONKeyDict];
}


+ (NSMutableDictionary *)__XYJSONKeyDict
{
    if (!XY_JSON_OBJECT_KEYDICTS)
    {
        XY_JSON_OBJECT_KEYDICTS = [[NSMutableDictionary alloc] init];
    }
    
    NSString *YYObjectKey           = [NSString stringWithFormat:@"XY_JSON_%@", NSStringFromClass([self class])];
    NSMutableDictionary *dictionary = [XY_JSON_OBJECT_KEYDICTS __objectForKey:YYObjectKey];
    if (!dictionary)
    {
        dictionary          = [[NSMutableDictionary alloc] init];
        if ([self hasSuperProperties] && ![[self superclass] isMemberOfClass:[NSObject class]])
        {
            [dictionary setValuesForKeysWithDictionary:[[self superclass] XYJSONKeyDict]];
        }

        XY_swizzleInstanceMethod(self, @selector(valueForUndefinedKey:), @selector(XY_valueForUndefinedKey:));
        XY_swizzleInstanceMethod(self, @selector(setValue:forUndefinedKey:), @selector(XY_setValue:forUndefinedKey:));
        NSArray *properties = [self yyPropertiesOfClass:[self class]];
        [properties enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *typeName = [self propertyConformsToProtocol:@protocol(XYJSONHelperProtocol) propertyName:obj];
            if (typeName)
            {
                [dictionary setObject:typeName forKey:obj];
            }
            else
            {
                [dictionary setObject:obj forKey:obj];
            }
        }];
        [XY_JSON_OBJECT_KEYDICTS setObject:dictionary forKey:YYObjectKey];
    }
    return dictionary;
}

+ (void)bindXYJSONKey:(NSString *)jsonKey toProperty:(NSString *)property
{
    NSMutableDictionary *dictionary = [self __XYJSONKeyDict];
    [dictionary removeObjectForKey:property];
    [dictionary setObject:property forKey:jsonKey];
}

+ (void)removeXYJSONKeyWithProperty:(NSString *)property
{
    NSMutableDictionary *dictionary = [self __XYJSONKeyDict];
    [dictionary removeObjectForKey:property];
}

- (NSString *)XYJSONString
{
    return [self XYJSONDictionary].XYJSONString;
}

- (NSData *)XYJSONData
{
    if ([NSJSONSerialization isValidJSONObject:self])
    {
        NSError *error;
        NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];
        if (!error)
        {
            return jsonData;
        }
    }
    return self.XYJSONDictionary.XYJSONData;
}


// 应该比较脆弱，不支持太复杂的对象。
- (NSDictionary *)XYJSONDictionary
{
    NSDictionary        *keyDict  = [self.class XYJSONKeyDict];
    NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc] initWithCapacity:keyDict.count];
    [keyDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        id value         = nil;
        id originalValue = [self valueForKey:key];
        if (NSClassFromString(obj))
        {
            if ([originalValue isKindOfClass:[NSArray class]])
            {
                value = [[originalValue XYJSONData] XYJSONString];
                //value = @{key : [[originalValue XYJSONData] XYJSONString]};
            }
            else
            {
                value = [originalValue XYJSONDictionary];
            }
        }
        else
        {
            value = [self valueForKey:obj];
        }
        if (value)
        {
            if ([value isKindOfClass:[NSDate class]]) {
                if (!XY_JSON_OBJECT_NSDateFormatter) {
                    XY_JSON_OBJECT_NSDateFormatter = [[NSDateFormatter alloc] init];
                    [XY_JSON_OBJECT_NSDateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
                    [XY_JSON_OBJECT_NSDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
                }
                value = [XY_JSON_OBJECT_NSDateFormatter stringFromDate:value];
            }
            [jsonDict setValue:value forKey:key];
        }
    }];
    return jsonDict;
}

static void XY_swizzleInstanceMethod(Class c, SEL original, SEL replacement) {
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

- (id)XY_valueForUndefinedKey:(NSString *)key
{
#ifdef DEBUG
    NSLog(@"%@ undefinedKey %@", self.class, key);
#endif
    return nil;
}

- (void)XY_setValue:(id)value forUndefinedKey:(NSString *)key
{
#ifdef DEBUG
    NSLog(@"%@ undefinedKey %@ and value is %@", self.class, key, value);
#endif
}

@end


#pragma mark - NSObject (YYProperties)
@implementation NSObject (YYProperties)
- (NSArray *)yyPropertiesOfClass:(Class)aClass
{
    NSMutableArray  *propertyNames = [[NSMutableArray alloc] init];
    id              obj            = objc_getClass([NSStringFromClass(aClass) cStringUsingEncoding:4]);
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

+ (NSString *)propertyConformsToProtocol:(Protocol *)protocol propertyName:(NSString *)propertyName
{
    NSString *typeName = [self typeOfPropertyNamed:propertyName];
    if ([typeName isKindOfClass:[NSString class]])
    {
        typeName      = [typeName stringByReplacingOccurrencesOfString:@"T@" withString:@""];
        typeName      = [typeName stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        NSRange range = [typeName rangeOfString:@"Array"];
        if (range.location != NSNotFound)
        {
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
    }
    NSObject *obj      = [NSClassFromString(typeName) new];
    if ([obj conformsToProtocol:protocol])
    {
        return typeName;
    }
    return nil;
}

+ (NSString *)typeOfPropertyNamed:(NSString *)name
{
    objc_property_t property = class_getProperty(self, [name UTF8String]);
    if (property == NULL)
    {
        return (NULL);
    }
    return [NSString stringWithUTF8String:(property_getTypeString(property))];
}

const char *property_getTypeString(objc_property_t property) {
    const char *attrs = property_getAttributes(property);
    if (attrs == NULL )
        return (NULL);
    
    static char buffer[256];
    const char  *e    = strchr(attrs, ',');
    if (e == NULL )
        return (NULL);
    
    int len = (int) (e - attrs);
    memcpy( buffer, attrs, len );
    buffer[len] = '\0';
    
    return (buffer);
}

@end

#pragma mark - NSString (XYJSONHelper)
@implementation NSString (XYJSONHelper)
- (id)toModel:(Class)modelClass
{
    return [self.toXYData toModel:modelClass];
}

- (id)toModel:(Class)modelClass forKey:(NSString *)jsonKey
{
    return [self.toXYData toModel:modelClass forKey:jsonKey];
}

- (NSArray *)toModels:(Class)modelClass
{
    return [self.toXYData toModels:modelClass];
}

- (NSArray *)toModels:(Class)modelClass forKey:(NSString *)jsonKey
{
    return [self.toXYData toModels:modelClass forKey:jsonKey];
}

- (NSData *)toXYData
{
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

- (id)JSONValue{
    NSError *error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:self.toXYData options:Json_string_options error:&error];
    if (error != nil)
        return nil;
    
    return result;
}
@end

#pragma mark - NSDictionary (XYJSONHelper)
@implementation NSDictionary (XYJSONHelper)
- (NSString *)XYJSONString
{
    NSData *jsonData = self.XYJSONData;
    if (jsonData)
    {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return nil;
}

- (id)__objectForKey:(id)key
{
    if (key)
    {
        return [self objectForKey:key];
    }
    return nil;
}


@end


#pragma mark - NSData (XYJSONHelper)
@implementation NSData (XYJSONHelper)

- (id)toModel:(Class)modelClass
{
    return [self toModel:modelClass forKey:nil];
}

- (id)toModel:(Class)modelClass forKey:(NSString *)key
{
    if (modelClass == nil)
        return nil;
    
    id XYJSONObject = [self XYJSONObjectForKey:key];
    if (XYJSONObject == nil)
        return nil;
    
    NSDictionary *XYJSONKeyDict = [modelClass XYJSONKeyDict];
    id model                    = [NSData objectForModelClass:modelClass fromDict:XYJSONObject withJSONKeyDict:XYJSONKeyDict];
    
    return model;
}

- (NSArray *)toModels:(Class)modelClass
{
    return [self toModels:modelClass forKey:nil];
}

- (NSArray *)toModels:(Class)modelClass forKey:(NSString *)key
{
    if (modelClass == nil)
        return nil;
    
    id XYJSONObject = [self XYJSONObjectForKey:key];
    if (XYJSONObject == nil)
        return nil;
    
    NSDictionary *XYJSONKeyDict = [modelClass XYJSONKeyDict];
    if ([XYJSONObject isKindOfClass:[NSArray class]])
    {
        NSMutableArray *models = [[NSMutableArray alloc] initWithCapacity:[XYJSONObject count]];
        [XYJSONObject enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            id model = [NSData objectForModelClass:modelClass fromDict:obj withJSONKeyDict:XYJSONKeyDict];
            [models addObject:model];
        }];
        
        return models;
    }
    else if ([XYJSONObject isKindOfClass:[NSDictionary class]])
    {
        return [NSData objectForModelClass:modelClass fromDict:XYJSONObject withJSONKeyDict:XYJSONKeyDict];
    }
    
    return nil;
}

+ (id)objectsForModelClass:(Class)modelClass fromArray:(NSArray *)array
{
    NSMutableArray *models        = [[NSMutableArray alloc] initWithCapacity:array.count];
    NSDictionary   *XYJSONKeyDict = [modelClass XYJSONKeyDict];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [models addObject:[self objectForModelClass:modelClass fromDict:obj withJSONKeyDict:XYJSONKeyDict]];
    }];
    return models;
}

+ (id)objectForModelClass:(Class)modelClass fromDict:(NSDictionary *)dict withJSONKeyDict:(NSDictionary *)XYJSONKeyDict
{
    if (![dict isKindOfClass:[NSDictionary class]])
    {
        return nil;
    }
    if (![XYJSONKeyDict isKindOfClass:[NSDictionary class]])
    {
        return nil;
    }
    if (!modelClass)
    {
        return nil;
    }
    
    id model = [[modelClass alloc] init];
    [XYJSONKeyDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([[dict valueForKeyPath:key] isKindOfClass:[NSArray class]])
        {
            if ([self classForString:obj valueKey:nil])
            {
                NSString *valueKey = nil;
                NSArray *array = [self objectsForModelClass:[self classForString:obj valueKey:&valueKey] fromArray:[dict valueForKeyPath:key]];
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
            Class otherClass = [self classForString:obj valueKey:&valueKey];
            if (otherClass)
            {
                id object = [self objectForModelClass:otherClass fromDict:[dict valueForKeyPath:key] withJSONKeyDict:[otherClass XYJSONKeyDict]];
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

- (NSString *)XYJSONString
{
    return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
}


- (id)XYJSONObject
{
    NSError *error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:self options:Json_string_options error:&error];
    if (error != nil)
        return nil;
    
    return result;
}

- (id)XYJSONObjectForKey:(NSString *)key
{
    if (key && [[self XYJSONObject] isKindOfClass:[NSDictionary class]])
    {
        return [[self XYJSONObject] valueForKeyPath:key];
    }
    else
    {
        return [self XYJSONObject];
    }
}

+ (Class)classForString:(NSString *)string valueKey:(NSString **)key
{
    if (string.length>0)
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

@end


#pragma mark - NSArray (XYJSONHelper)
@implementation NSArray (XYJSONHelper)

- (NSString *)XYJSONString
{
    return self.XYJSONData.XYJSONString;
}

//  循环集合将每个对象转为字典，得到字典集合，然后转为jsonData
- (NSData *)XYJSONData
{
    NSMutableArray *jsonDictionaries = [[NSMutableArray alloc] init];
    [self enumerateObjectsUsingBlock:^(NSObject *obj, NSUInteger idx, BOOL *stop) {
        [jsonDictionaries addObject:obj.XYJSONDictionary];
    }];
    if ([NSJSONSerialization isValidJSONObject:jsonDictionaries])
    {
        NSError *error;
        NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionaries options:kNilOptions error:&error];
        if (!error)
        {
            return jsonData;
        }
    }
    return nil;
}

@end