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

#import <Foundation/Foundation.h>

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
#define uxy_property_as_associated_strong( __type, __name) \
        @property (nonatomic, strong, setter=set__##__name:, getter=__##__name) __type __name;

#define uxy_property_def_associated_strong( __type, __name) \
        - (__type)__##__name   \
        { return [self uxy_getAssociatedObjectForKey:#__name]; }   \
        - (void)set__##__name:(id)__##__name   \
        { [self uxy_retainAssociatedObject:__##__name forKey:#__name]; }

#define uxy_property_as_associated_weak( __type, __name) \
        @property (nonatomic, weak, setter=set__##__name:, getter=__##__name) __type __name;

#define uxy_property_def_associated_weak( __type, __name) \
        - (__type)__##__name   \
        { return [self uxy_getAssociatedObjectForKey:#__name]; }   \
        - (void)set__##__name:(id)__##__name   \
        { [self uxy_retainAssociatedObject:__##__name forKey:#__name]; }


#define uxy_property_as_associated_copy( __type, __name) \
        @property (nonatomic, copy, setter=set__##__name:, getter=__##__name) __type __name;

#define uxy_property_def_associated_copy( __type, __name) \
        - (__type)__##__name   \
        { return [self uxy_copyAssociatedObject:#__name]; }   \
        - (void)set__##__name:(id)__##__name   \
        { [self uxy_copyAssociatedObject:__##__name forKey:#__name]; }

#define uxy_property_as_associated_retain( __type, __name) \
        @property (nonatomic, retain, setter=set__##__name:, getter=__##__name) __type __name;

#define uxy_property_def_associated_retain( __type, __name) \
        - (__type)__##__name   \
        { return [self uxy_retainAssociatedObject:#__name]; }   \
        - (void)set__##__name:(id)__##__name   \
        { [self uxy_retainAssociatedObject:__##__name forKey:#__name]; }

#define uxy_property_as_associated_assign( __type, __name) \
        @property (nonatomic, assign, setter=set__##__name:, getter=__##__name) __type __name;

#define uxy_property_def_associated_assign( __type, __name) \
        - (__type)__##__name   \
        { return [self uxy_getAssociatedObjectForKey:#__name]; }   \
        - (void)set__##__name:(id)__##__name   \
        { [self uxy_assignAssociatedObject:__##__name forKey:#__name]; }

@interface NSObject (XY_associated)
- (id)uxy_getAssociatedObjectForKey:(const char *)key;
- (id)uxy_copyAssociatedObject:(id)obj forKey:(const char *)key;
- (id)uxy_retainAssociatedObject:(id)obj forKey:(const char *)key;
- (id)uxy_assignAssociatedObject:(id)obj forKey:(const char *)key;
- (void)uxy_removeAssociatedObjectForKey:(const char *)key;
- (void)uxy_removeAllAssociatedObjects;
@end


