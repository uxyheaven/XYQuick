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

/// 对象的属性列表的字典
@property (nonatomic, strong) NSMutableDictionary *objectProperties;

/// 对象的属性别名列表的字典
@property (nonatomic, strong) NSMutableDictionary *propertyNicknames;

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

- (instancetype)init
{
    self = [super init];
    if (self) {
        _objectProperties  = [@{} mutableCopy];
        _propertyNicknames = [@{} mutableCopy];
    }
    return self;
}

- (NSMutableDictionary *)__propertyNicknamesOfClass:(Class)classType
{
    NSString *key = [NSString stringWithFormat:@"n_%@", classType];
    return self.propertyNicknames[key] ?: ({ self.propertyNicknames[key] = [@{} mutableCopy]; self.propertyNicknames[key]; });
}


- (NSDictionary *)__objectPropertiesOfClass:(Class)classType
{
    NSString *key = [NSString stringWithFormat:@"p_%@", classType];
    NSDictionary *propertyNames = self.objectProperties[key];
    if (!propertyNames)
    {
        NSMutableArray *array = [@[] mutableCopy];
        unsigned int outCount;
        unsigned int i;
        objc_property_t *properties = class_copyPropertyList(classType, &outCount);
        for (i = 0; i < outCount; i++)
        {
            objc_property_t property      = properties[i];
            NSString        *propertyName = [NSString stringWithCString:property_getName(property) encoding:4];
            [array addObject:propertyName];
        }
        free(properties);
        
        if ([classType conformsToProtocol:@protocol(NSObject)])
        {
            [array removeObjectsInArray:kNSObjectProtocolProperties];
        }
        
        propertyNames = [@{} mutableCopy];
        for (NSString *name in array)
        {
            NSString *className = [self __classNameOfproperty:name inClassType:classType];
            className = className ?: @"";
            [propertyNames setValue:className forKey:name];
        }
        
        propertyNames = [propertyNames copy];
    }
    
    return propertyNames;
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

+ (void)__uxy_swizzleInstanceMethodWithClass:(Class)clazz originalSel:(SEL)original replacementSel:(SEL)replacement
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
        return nil;
    
    NSDictionary *properties = [[ XYJSONParser_2 sharedInstance] __objectPropertiesOfClass:classType];
    id model = [[classType alloc] init];
    
    [properties enumerateKeysAndObjectsUsingBlock:^(NSString *propertyName, NSString *className, BOOL *stop) {
        id value = [JSONObject valueForKeyPath:propertyName];
        
        if (!value)
        {
            // 取不到就试试别名
            NSMutableDictionary *dic = [[XYJSONParser_2 sharedInstance] __propertyNicknamesOfClass:classType];
            NSArray *nicknames = dic[propertyName];
            for (NSString *nicename in nicknames)
            {
                value = [JSONObject valueForKeyPath:nicename];
                if (value)
                    break;
            }
        }
        
        if ([value isKindOfClass:[NSArray class]])
        {
            Class clazz = NSClassFromString(className);
            if (clazz)
            {
                NSArray *array = [self objectByClass:clazz withJSONObject:value];
                if (array.count)
                {
                    [model setValue:array forKey:propertyName];
                }
            }
            else
            {
                [model setValue:[JSONObject valueForKeyPath:propertyName] forKey:propertyName];
            }
            
            return ;
        }
        
        if ([value isKindOfClass:[NSDictionary class]])
        {
            Class otherClass = NSClassFromString(className);
            if (otherClass)
            {
                id object = [self objectByClass:otherClass withJSONObject:value];
                if (object)
                {
                    [model setValue:object forKeyPath:propertyName];
                }
            }
            else
            {
                [model setValue:value forKey:propertyName];
            }
            
            return;
        }
        
        if (![value isKindOfClass:[NSNull class]] && value != nil)
        {
            [model setValue:value forKey:propertyName];
        }
        
        return;
    }];
    
    return model;
}

- (NSString *)__classNameOfproperty:(NSString *)propertyName inClassType:(Class)classType
{
    objc_property_t property = class_getProperty(classType, [propertyName UTF8String]);
    NSString *typeName = property ? [NSString stringWithUTF8String:(property_getAttributes(property))] : nil;
    if (!typeName)
        return nil;
    
    NSRange range = [typeName rangeOfString:@","];
    if (range.location == NSNotFound)
        return nil;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(?<=<).*?(?=>)" options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *results = [regex matchesInString:typeName options:NSMatchingReportCompletion range:NSMakeRange(0,typeName.length)];
    for (NSTextCheckingResult *result in results)
    {
        NSString *protocolName = [typeName substringWithRange:result.range];
        if (protocol_conformsToProtocol(NSProtocolFromString(protocolName), @protocol(XYJSONAutoBinding))
            && NSClassFromString(protocolName))
        {
            return protocolName;
        }
    }
    
    // 普通自定义对象符合自动绑定协议的
    if ([NSClassFromString(typeName) conformsToProtocol:@protocol(XYJSONAutoBinding)])
    {
        return typeName;
    }
    
    return nil;
}

@end


#pragma mark - NSObject (XYJSON_2)

@implementation NSObject (XYJSON_2)

+ (BOOL)uxy_hasSuperProperties
{
    return NO;
}

+ (void)uxy_addNickname:(NSString *)nicename forProperty:(NSString *)property
{
    NSMutableDictionary *dic = [[XYJSONParser_2 sharedInstance] __propertyNicknamesOfClass:self];
    NSMutableArray *array = dic[property];
    array = array ?: [@[] mutableCopy];
    [array addObject:nicename];
    
    dic[property] = array;
}

- (NSString *)uxy_JSONString
{
    return [self.__uxy_JSONObject uxy_JSONString];
}

- (NSDictionary *)uxy_JSONDictionary
{
    return self.__uxy_JSONObject;
}
#pragma mark - 
- (id)__uxy_JSONObject
{
    if ([self isKindOfClass:[NSString class]])
    {
        return [(NSString *)self uxy_JSONObject];
    }
    
    if ([self isKindOfClass:[NSArray class]] || [self isKindOfClass:[NSDictionary class]])
    {
        return nil;
    }
    
    NSDictionary *properties = [[ XYJSONParser_2 sharedInstance] __objectPropertiesOfClass:[self class]];

    NSMutableDictionary *vo = [@{} mutableCopy];
    
    [properties enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *className, BOOL *stop) {
        if (className.length > 0)
        {
            id sub = [self valueForKeyPath:key];
            if ([sub isKindOfClass:[NSArray class]])
            {
                NSMutableArray *mArray = [@[] mutableCopy];
                [sub enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [mArray addObject:[obj __uxy_JSONObject]];
                }];
                vo[key] = [mArray copy];
                return ;
            }
            
            vo[key] = [sub __uxy_JSONObject];
        }
        else
        {
            vo[key] =  [self valueForKeyPath:key];
        }
    }];
    
    return [vo copy];
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
    if (error != nil)
    {
        NSLog(@"<# [ ERROR ] #>%@\n%@", error, [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding]);
    }
#endif
    
    if (error != nil)
        return nil;
    
    if ([result isKindOfClass:[NSDictionary class]] && keyPath)
    {
        return [result valueForKeyPath:keyPath];
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
        if (error != nil)
        {
            NSLog(@"<# [ ERROR ] #>%@\n%@", error, self);
        }
        
    }
#endif
    
    return nil;
}

@end