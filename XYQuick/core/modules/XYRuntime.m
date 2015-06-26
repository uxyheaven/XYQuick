//
//  XYRuntime.m
//  JoinShow
//
//  Created by Heaven on 14/11/13.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import "XYRuntime.h"

@implementation XYRuntime

+ (void)swizzleInstanceMethodWithClass:(Class)clazz originalSel:(SEL)original replacementSel:(SEL)replacement
{
    Method a = class_getInstanceMethod(clazz, original);
    Method b = class_getInstanceMethod(clazz, replacement);
    // class_addMethod 为该类增加一个新方法
    if (class_addMethod(clazz, original, method_getImplementation(b), method_getTypeEncoding(b)))
    {
        // 替换类方法的实现指针
        class_replaceMethod(clazz, replacement, method_getImplementation(a), method_getTypeEncoding(a));
    }
    else
    {
        // 交换2个方法的实现指针
        method_exchangeImplementations(a, b);
    }
}
@end


@implementation NSObject(uxyRuntime)

+ (NSArray *)uxy_subClasses
{
    NSMutableArray *results = [[NSMutableArray alloc] init];
    
    for ( NSString *className in [self __loadedClassNames] )
    {
        Class classType = NSClassFromString( className );
        if ( classType == self )
            continue;
        
        if ( NO == [classType isSubclassOfClass:self] )
            continue;
        
        [results addObject:[classType description]];
    }
    
    return results;
}

+ (NSArray *)uxy_methods
{
    NSMutableArray *methodNames = [[NSMutableArray alloc] init];
    
    Class thisClass = self;
    
    while ( NULL != thisClass )
    {
        unsigned int methodCount = 0;
        Method *methodList = class_copyMethodList( thisClass, &methodCount );
        
        for ( unsigned int i = 0; i < methodCount; ++i )
        {
            SEL selector = method_getName( methodList[i] );
            if ( selector )
            {
                const char * cstrName = sel_getName(selector);
                if ( NULL == cstrName )
                    continue;
                
                NSString * selectorName = [NSString stringWithUTF8String:cstrName];
                if ( NULL == selectorName )
                    continue;
                
                [methodNames addObject:selectorName];
            }
        }
        
        free( methodList );
        
        thisClass = class_getSuperclass( thisClass );
        if ( thisClass == [NSObject class] )
        {
            break;
        }
    }
    
    return methodNames;
}

+ (NSArray *)uxy_methodsUntilClass:(Class)baseClass
{
    NSMutableArray * methodNames = [[NSMutableArray alloc] init];
    
    Class thisClass = self;
    
    baseClass = baseClass ?: [NSObject class];
    
    while ( NULL != thisClass )
    {
        unsigned int	methodCount = 0;
        Method *		methodList = class_copyMethodList( thisClass, &methodCount );
        
        for ( unsigned int i = 0; i < methodCount; ++i )
        {
            SEL selector = method_getName( methodList[i] );
            if ( selector )
            {
                const char * cstrName = sel_getName(selector);
                if ( NULL == cstrName )
                    continue;
                
                NSString * selectorName = [NSString stringWithUTF8String:cstrName];
                if ( NULL == selectorName )
                    continue;
                
                [methodNames addObject:selectorName];
            }
        }
        
        free( methodList );
        
        thisClass = class_getSuperclass( thisClass );
        
        if ( nil == thisClass || baseClass == thisClass )
        {
            break;
        }
    }
    
    return methodNames;
}

+ (NSArray *)uxy_methodsWithPrefix:(NSString *)prefix
{
    return [self uxy_methodsWithPrefix:prefix untilClass:[self superclass]];
}

+ (NSArray *)uxy_methodsWithPrefix:(NSString *)prefix untilClass:(Class)baseClass
{
    NSArray * methods = [self uxy_methodsUntilClass:baseClass];
    
    if ( nil == methods || 0 == methods.count )
    {
        return nil;
    }
    
    if ( nil == prefix )
    {
        return methods;
    }
    
    NSMutableArray * result = [[NSMutableArray alloc] init];
    
    for ( NSString * selectorName in methods )
    {
        if ( NO == [selectorName hasPrefix:prefix] )
        {
            continue;
        }
        
        [result addObject:selectorName];
    }
    
    [result sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    
    return result;
}

#pragma mark -
+ (NSArray *)uxy_properties
{
    return [self uxy_propertiesUntilClass:[self superclass]];
}

+ (NSArray *)uxy_propertiesUntilClass:(Class)baseClass
{
    NSMutableArray * propertyNames = [[NSMutableArray alloc] init];
    
    Class thisClass = self;
    
    baseClass = baseClass ?: [NSObject class];
    
    while ( NULL != thisClass )
    {
        unsigned int		propertyCount = 0;
        objc_property_t *	propertyList = class_copyPropertyList( thisClass, &propertyCount );
        
        for ( unsigned int i = 0; i < propertyCount; ++i )
        {
            const char * cstrName = property_getName( propertyList[i] );
            if ( NULL == cstrName )
                continue;
            
            NSString * propName = [NSString stringWithUTF8String:cstrName];
            if ( NULL == propName )
                continue;
            
            [propertyNames addObject:propName];
        }
        
        free( propertyList );
        
        thisClass = class_getSuperclass( thisClass );
        
        if ( nil == thisClass || baseClass == thisClass )
        {
            break;
        }
    }
    
    return propertyNames;
}

+ (NSArray *)uxy_propertiesWithPrefix:(NSString *)prefix
{
    return [self uxy_propertiesWithPrefix:prefix untilClass:[self superclass]];
}

+ (NSArray *)uxy_propertiesWithPrefix:(NSString *)prefix untilClass:(Class)baseClass
{
    NSArray * properties = [self uxy_propertiesUntilClass:baseClass];
    
    if ( nil == properties || 0 == properties.count )
    {
        return nil;
    }
    
    if ( nil == prefix )
    {
        return properties;
    }
    
    NSMutableArray * result = [[NSMutableArray alloc] init];
    
    for ( NSString * propName in properties )
    {
        if ( NO == [propName hasPrefix:prefix] )
        {
            continue;
        }
        
        [result addObject:propName];
    }
    
    [result sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    
    return result;
}

#pragma mark -
+ (NSArray *)uxy_classesWithProtocol:(NSString *)protocolName
{
    NSMutableArray *results = [[NSMutableArray alloc] init];
    Protocol * protocol = NSProtocolFromString(protocolName);
    for ( NSString *className in [self __loadedClassNames] )
    {
        Class classType = NSClassFromString( className );
        if ( classType == self )
            continue;
        
        if ( NO == [classType conformsToProtocol:protocol] )
            continue;
        
        [results addObject:[classType description]];
    }
    
    return results;
}

#pragma mark -
+ (void *)uxy_replaceSelector:(SEL)sel1 withSelector:(SEL)sel2
{
    Method method  = class_getInstanceMethod( self, sel1 );

    IMP implement  = (IMP)method_getImplementation( method );
    IMP implement2 = class_getMethodImplementation( self, sel2 );
    
    method_setImplementation( method, implement2 );
    
    return (void *)implement;
}

#pragma mark - private
+ (NSArray *)__loadedClassNames
{
    static dispatch_once_t once;
    static NSMutableArray *classNames;
    
    dispatch_once( &once, ^
    {
        unsigned int classesCount = 0;
        
        classNames     = [[NSMutableArray alloc] init];
        Class *classes = objc_copyClassList( &classesCount );
        
        for ( unsigned int i = 0; i < classesCount; ++i )
        {
            Class classType = classes[i];
            
            if ( class_isMetaClass( classType ) )
                continue;
            
            Class superClass = class_getSuperclass( classType );
            
            if ( nil == superClass )
                continue;
            
            [classNames addObject:[NSString stringWithUTF8String:class_getName(classType)]];
        }
        
        [classNames sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj1 compare:obj2];
        }];
        
        free( classes );
    });
    
    return classNames;
}

@end