//
//  XYObserve.h
//  JoinShow
//
//  Created by Heaven on 13-11-6.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//
//  kvo 的封装
#import <Foundation/Foundation.h>
#import "XYQuick_Predefine.h"

#pragma mark - #define
#define KVO_NAME( __name )					uxy_macro_string( __name )

#define uxy_handleKVO( __property, __sourceObject, ...)            \
        metamacro_if_eq(1, metamacro_argcount(__VA_ARGS__))         \
        (__uxy_handleKVO_1(__property, __sourceObject, __VA_ARGS__))    \
        (__uxy_handleKVO_2(__property, __sourceObject, __VA_ARGS__))


#define __uxy_handleKVO_1( __property, __sourceObject, __newValue) \
        - (void)__uxy_handleKVO_##__property##_in:(id)sourceObject new:(id)newValue

#define __uxy_handleKVO_2( __property, __sourceObject, __newValue, __oldValue ) \
        - (void)__uxy_handleKVO_##__property##_in:(id)sourceObject new:(id)newValue old:(id)oldValue

typedef void(^XYObserver_block_new_old)(id newValue, id oldValue);

#pragma mark - XYObserver
@interface XYObserver : NSObject

@end

#pragma mark - NSObject (XYObserve)

// 注意这里是 self 持有了观察者, 在 self 销毁的时候, 取消所有的观察
@interface NSObject (XYObserver)

@property (nonatomic, readonly, strong) NSMutableDictionary *observers;

/**
 * api parameters 说明
 *
 * sourceObject 被观察的对象
 * keyPath 被观察的属性keypath
 * target 默认是self
 * block selector, block二选一
 */
- (void)observeWithObject:(id)sourceObject property:(NSString*)property;
- (void)observeWithObject:(id)sourceObject property:(NSString*)property block:(XYObserver_block_new_old)block;

- (void)removeObserverWithObject:(id)sourceObject property:(NSString *)property;
- (void)removeObserverWithObject:(id)sourceObject;
- (void)removeAllObserver;

@end



