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

typedef void(^XYKVO_block_new_old)(id newValue, id oldValue);

#pragma mark - XYKVO
@interface XYKVO : NSObject

@end

#pragma mark - NSObject (XYObserve)

// 注意这里是 self 持有了观察者, 在 self 销毁的时候, 取消所有的观察
@interface NSObject (XYKVO)

@property (nonatomic, readonly, strong) NSMutableDictionary *uxy_observers;

/**
 * api parameters 说明
 *
 * sourceObject 被观察的对象
 * keyPath 被观察的属性keypath
 * target 默认是self
 * block selector, block二选一
 */
- (void)uxy_observeWithObject:(id)sourceObject property:(NSString*)property;
- (void)uxy_observeWithObject:(id)sourceObject property:(NSString*)property block:(XYKVO_block_new_old)block;

- (void)uxy_removeObserverWithObject:(id)sourceObject property:(NSString *)property;
- (void)uxy_removeObserverWithObject:(id)sourceObject;
- (void)uxy_removeAllObserver;

@end



