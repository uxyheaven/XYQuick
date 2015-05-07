//
//  XYJSONHelper.m
//  JoinShow
//
//  Created by Heaven on 14-9-9.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//


#import "XYJSONHelper.h"

#define kNSObjectProtocolProperties @[@"hash", @"superclass", @"description", @"debugDescription"]

#pragma mark - interface

#pragma mark - static
static void XY_swizzleInstanceMethod(Class c, SEL original, SEL replacement);


#pragma mark - NSObject (XYProperties)
@interface NSObject (XYProperties)

const char *property_getTypeString(objc_property_t property);
// 根据传入的class返回属性集合
- (NSArray *)xyPropertiesOfClass:(Class)aClass;

+ (NSString *)propertyConformsToProtocol:(Protocol *)protocol propertyName:(NSString *)propertyName;
@end

#pragma mark - NSObject (XYJSONHelper_helper)
@interface NSObject (XYJSONHelper_helper)
+ (NSDateFormatter *)jsonDateFormatter;
@end

#pragma mark - implementation

#pragma mark - XYJSONParser
@implementation XYJSONParser
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

#pragma mark - NSObject (XYJSONHelper)
@implementation NSObject (XYJSONHelper)

static NSMutableDictionary *XY_JSON_OBJECT_KEYDICTS = nil;

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
        NSArray *properties = [self xyPropertiesOfClass:[self class]];
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
        
        if ([self conformsToProtocol:@protocol(NSObject)])
        {
            [dictionary removeObjectsForKeys:kNSObjectProtocolProperties];
        }
        
        [XY_JSON_OBJECT_KEYDICTS setObject:dictionary forKey:YYObjectKey];
    }
    return dictionary;
}

+ (void)bindXYJSONKey:(NSString *)jsonKey toProperty:(NSString *)property
{
    NSMutableDictionary *dic= [self __XYJSONKeyDict];
    [dic removeObjectForKey:property];
    [dic setObject:property forKey:jsonKey];
}

+ (void)removeXYJSONKeyWithProperty:(NSString *)property
{
    NSMutableDictionary *dic = [self __XYJSONKeyDict];
    [dic removeObjectForKey:property];
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
            return jsonData;
    }
#ifdef DEBUG
    else
    {
        NSError *error;
        [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];
        if (error != nil) NSLog(@"<# [ ERROR ] #>%@", error);
    }
#endif
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
                NSDateFormatter * formatter = [NSObject jsonDateFormatter];
                value = [formatter stringFromDate:value];
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
    // NSLog(@"%@ undefinedKey %@", self.class, key);
#endif
    return nil;
}

- (void)XY_setValue:(id)value forUndefinedKey:(NSString *)key
{
#ifdef DEBUG
    // NSLog(@"%@ undefinedKey %@ and value is %@", self.class, key, value);
#endif
}

- (NSArray *)toModels:(Class)modelClass
{
    return nil;
}

- (NSArray *)toModels:(Class)modelClass forKey:(NSString *)key
{
    return nil;
}

- (id)toModel:(Class)modelClass
{
    return nil;
}

- (id)toModel:(Class)modelClass forKey:(NSString *)key
{
    return nil;
}

@end


#pragma mark - NSObject (Properties)
@implementation NSObject (Properties)
- (NSArray *)xyPropertiesOfClass:(Class)aClass
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
@end

#pragma mark - NSObject (XYJSONHelper_helper)
@implementation NSObject (XYJSONHelper_helper)
+ (NSDateFormatter *)jsonDateFormatter
{
    NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *dateFormatter = threadDictionary[@"jsonDateFormatter"];
    
    if(!dateFormatter)
    {
        @synchronized(self)
        {
            if(!dateFormatter)
            {
                dateFormatter            = [[NSDateFormatter alloc] init];
                dateFormatter.timeZone   = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
                dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
                threadDictionary[@"jsonDateFormatter"] = dateFormatter;
            }
        }
    }
    
    return dateFormatter;
}
@end

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
    return [self.toXYData JSONValue];
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
    
    NSDictionary *dic = [modelClass XYJSONKeyDict];
    id model          = [NSData objectForModelClass:modelClass fromDict:XYJSONObject withJSONKeyDict:dic];
    
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
    
    id XYJSONObject   = [self XYJSONObjectForKey:key];
    if (XYJSONObject == nil)
        return nil;
    
    NSDictionary *dic = [modelClass XYJSONKeyDict];
    if ([XYJSONObject isKindOfClass:[NSArray class]])
    {
        NSMutableArray *models = [[NSMutableArray alloc] initWithCapacity:[XYJSONObject count]];
        [XYJSONObject enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            id model = [NSData objectForModelClass:modelClass fromDict:obj withJSONKeyDict:dic];
            if (model)
            {
                [models addObject:model];
            }
        }];
        
        return models;
    }
    else if ([XYJSONObject isKindOfClass:[NSDictionary class]])
    {
        return [NSData objectForModelClass:modelClass fromDict:XYJSONObject withJSONKeyDict:dic];
    }
    
    return nil;
}

- (id)JSONValue{
    NSError *error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:self options:Json_string_options error:&error];
    
#ifdef DEBUG
    if (error != nil) NSLog(@"%@", error);
#endif
    
    if (error != nil)
        return nil;
    
    return result;
}

+ (id)objectsForModelClass:(Class)modelClass fromArray:(NSArray *)array
{
    NSMutableArray *models = [[NSMutableArray alloc] initWithCapacity:array.count];
    NSDictionary   *dic    = [modelClass XYJSONKeyDict];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id model = [self objectForModelClass:modelClass fromDict:obj withJSONKeyDict:dic];
        if (model)
        {
            [models addObject:model];
        }
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
    
#ifdef DEBUG
    if (error != nil) NSLog(@"<# [ ERROR ] #>%@", error);
#endif
    
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

- (id)valueForJsonKey:(NSString *)key
{
    id rootJsonObj = [self JSONValue];
    if ([rootJsonObj isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dict = (NSDictionary *) rootJsonObj;
        return [dict valueForKeyPath:key];
    }
    return nil;
}

- (NSDictionary *)dictForJsonKeys:(NSArray *)keys
{
    id rootJsonObj = [self JSONValue];
    if ([rootJsonObj isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dict = (NSDictionary *) rootJsonObj;
        NSMutableDictionary *jsonDict = [NSMutableDictionary dictionary];
        [keys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
            id jsonValue = [dict valueForKeyPath:key];
            if (jsonValue)
            {
                [jsonDict setObject:jsonValue forKey:key];
            }
        }];
        return jsonDict;
    }
    return nil;
}

- (void)parseToObjectWithParsers:(NSArray *)parsers
{
    id rootJsonObj = [self JSONValue];
    if ([rootJsonObj isKindOfClass:[NSDictionary class]])
    {
        [parsers enumerateObjectsUsingBlock:^(XYJSONParser *parser, NSUInteger idx, BOOL *stop) {
            id obj = [rootJsonObj objectForKey:parser.key];
            id result = nil;
            //如果没有clazz，则说明不是Model，直接原样返回
            if (parser.clazz)
            {
                if (parser.single)
                {
                    result = [obj toModel:parser.clazz];
                }
                else
                {
                    if ([obj isKindOfClass:[NSDictionary class]])
                    {
                        result = [[(NSDictionary *)obj XYJSONString] toModel:parser.clazz];
                    }
                    else
                    {
                        result = [obj toModels:parser.clazz];
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

- (NSArray *)toModels:(Class)modelClass
{
    if ([self isKindOfClass:[NSArray class]] && self.count > 0)
    {
        NSDictionary *dic      = [modelClass XYJSONKeyDict];
        NSMutableArray *models = [[NSMutableArray alloc] initWithCapacity:[self count]];
        [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            id model = [NSData objectForModelClass:modelClass fromDict:obj withJSONKeyDict:dic];
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