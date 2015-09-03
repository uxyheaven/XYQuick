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

#import "XYQuick_Predefine.h"
#pragma mark -

@interface NSObject (XY)

#pragma mark - property
// 属性列表
@property (nonatomic, readonly, strong) NSArray *uxy_attributeList;

#pragma mark - conversion
- (NSInteger)uxy_asInteger;     // NSNumber, NSNull, NSString, NSString, NSDate
- (float)uxy_asFloat;           // NSNumber, NSNull, NSString, NSString, NSDate
- (BOOL)uxy_asBool;             // NSNumber, NSNull, NSString, NSString, NSDate

- (NSNumber *)uxy_asNSNumber;   // NSNumber, NSNull, NSString, NSString, NSDate
- (NSString *)uxy_asNSString;   // NSString, NSNull, NSData
- (NSDate *)uxy_asNSDate;       // NSDate, NSString,
- (NSData *)uxy_asNSData;       // NSData, NSString
- (NSArray *)uxy_asNSArray;     // NSArray, NSObject

#pragma mark- copy
- (id)uxy_deepCopy1; // 基于NSKeyArchive
@end


#pragma mark- XY_associated
#define uxy_property_strong( __type, __name) \
        property (nonatomic, strong, setter=set__##__name:, getter=__##__name) __type __name;

#define uxy_def_property_strong( __type, __name) \
        - (__type)__##__name   \
        { return [self uxy_getAssociatedObjectForKey:#__name]; }   \
        - (void)set__##__name:(id)__##__name   \
        { [self uxy_setRetainAssociatedObject:(id)__##__name forKey:#__name]; }

#define uxy_property_weak( __type, __name) \
        property (nonatomic, weak, setter=set__##__name:, getter=__##__name) __type __name;

#define uxy_def_property_weak( __type, __name) \
        - (__type)__##__name   \
        { return [self uxy_getAssociatedObjectForKey:#__name]; }   \
        - (void)set__##__name:(id)__##__name   \
        { [self uxy_setAssignAssociatedObject:(id)__##__name forKey:#__name]; }


#define uxy_property_copy( __type, __name) \
        property (nonatomic, copy, setter=set__##__name:, getter=__##__name) __type __name;

#define uxy_def_property_copy( __type, __name) \
        - (__type)__##__name   \
        { return [self uxy_getAssociatedObjectForKey:#__name]; }   \
        - (void)set__##__name:(id)__##__name   \
        { [self uxy_setCopyAssociatedObject:(id)__##__name forKey:#__name]; }

#define uxy_property_retain( __type, __name) \
        property (nonatomic, retain, setter=set__##__name:, getter=__##__name) __type __name;

#define uxy_def_property_retain( __type, __name) \
        - (__type)__##__name   \
        { return [self uxy_getAssociatedObjectForKey:#__name]; }   \
        - (void)set__##__name:(id)__##__name   \
        { [self uxy_setRetainAssociatedObject:(id)__##__name forKey:#__name]; }

#define uxy_property_assign( __type, __name) \
        property (nonatomic, assign, setter=set__##__name:, getter=__##__name) __type __name;

#define uxy_def_property_assign( __type, __name) \
        - (__type)__##__name   \
        { return [self uxy_getAssociatedObjectForKey:#__name]; }   \
        - (void)set__##__name:(id)__##__name   \
        { [self uxy_setAssignAssociatedObject:(id)__##__name forKey:#__name]; }

#define uxy_property_basicDataType( __type, __name) \
        property (nonatomic, assign, setter=set__##__name:, getter=__##__name) __type __name;

#define uxy_def_property_basicDataType( __type, __name) \
        - (__type)__##__name   \
        {   \
            NSNumber *number = [self uxy_getAssociatedObjectForKey:#__name];    \
            return metamacro_concat(metamacro_concat(__uxy_, __type), _value)( number ); \
        }   \
        - (void)set__##__name:(__type)__##__name   \
        { \
            NSNumber *number = @(__##__name);\
            [self uxy_setRetainAssociatedObject:number forKey:#__name];     \
        }

#define __uxy_int_value( __nubmer ) [__nubmer intValue]
#define __uxy_char_value( __nubmer ) [__nubmer charValue]
#define __uxy_short_value( __nubmer ) [__nubmer shortValue]
#define __uxy_long_value( __nubmer ) [__nubmer longValue]
#define __uxy_float_value( __nubmer ) [__nubmer floatValue]
#define __uxy_double_value( __nubmer ) [__nubmer doubleValue]
#define __uxy_BOOL_value( __nubmer ) [__nubmer boolValue]
#define __uxy_NSInteger_value( __nubmer ) [__nubmer integerValue]
#define __uxy_NSUInteger_value( __nubmer ) [__nubmer unsignedIntegerValue]
#define __uxy_NSTimeInterval_value( __nubmer ) [__nubmer doubleValue]

// 关联对象OBJC_ASSOCIATION_ASSIGN策略不支持引用计数为0的弱引用
@interface NSObject (XY_associated)
- (id)uxy_getAssociatedObjectForKey:(const char *)key;
- (void)uxy_setCopyAssociatedObject:(id)obj forKey:(const char *)key;
- (void)uxy_setRetainAssociatedObject:(id)obj forKey:(const char *)key;
- (void)uxy_setAssignAssociatedObject:(id)obj forKey:(const char *)key;
- (void)uxy_removeAssociatedObjectForKey:(const char *)key;
- (void)uxy_removeAllAssociatedObjects;
@end


