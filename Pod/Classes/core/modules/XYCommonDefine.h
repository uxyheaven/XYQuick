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

/**************************************************************/
// delegate 委托
// arm64下失效,具体看https://developer.apple.com/library/ios/documentation/General/Conceptual/CocoaTouch64BitGuide/ConvertingYourAppto64-Bit/ConvertingYourAppto64-Bit.html

/*
#define DelegateSelf( __sel ) Delegate( __sel, self)

// delegate被注册KVO时,isa会变, 判断delegate被释放?
// arm64下面 objc_msgSend不能用__VA_ARGS__了
#define Delegate( __sel, ...) \
        if (_delegate && [_delegate respondsToSelector:__sel]) \
        { \
                __actionXY_return_void = (void (*)(id, SEL, ...)) objc_msgSend; \
                __actionXY_return_void(_delegate, __sel, ## __VA_ARGS__); \
        }
 */
/**************************************************************/
// block 安全self
#if __has_feature(objc_arc)
// arc
#define uxy_def_weakSelf    uxy_def_weakify(self)
#define uxy_def_strongSelf  uxy_def_strongify(self)

#define uxy_def_weakify( __object ) \
        __weak __typeof( __object) weak##_##__object = __object;
#define uxy_def_strongify( __object )   \
        __typeof__(__object) __object = weak##_##__object;
#else
// mrc
#define uxy_def_weakSelf     __block typeof(id) weakSelf = self;
#define uxy_def_strongSelf

#define uxy_def_weakify( __object )     \
        __block __typeof(__object) block##_##__object = __object;
#define uxy_def_strongify( __object )
#endif

/**************************************************************/
static __inline__ CGRect CGRectFromCGSize( CGSize size ) {
    return CGRectMake( 0, 0, size.width, size.height );
};

static __inline__ CGRect CGRectMakeWithCenterAndSize( CGPoint center, CGSize size ) {
    return CGRectMake( center.x - size.width * 0.5, center.y - size.height * 0.5, size.width, size.height );
};

static __inline__ CGRect CGRectMakeWithOriginAndSize( CGPoint origin, CGSize size ) {
    return CGRectMake( origin.x, origin.y, size.width, size.height );
};

static __inline__ CGPoint CGRectCenter( CGRect rect ) {
    return CGPointMake( CGRectGetMidX( rect ), CGRectGetMidY( rect ) );
};
/**************************************************************/
// arc mrc 兼容
#if __has_feature(objc_arc)
    #define UXY_AUTORELEASE(exp) exp
    #define UXY_RELEASE(exp) exp
    #define UXY_RETAIN(exp) exp
#else
    #define UXY_AUTORELEASE(exp) [exp autorelease]
    #define UXY_RELEASE(exp) [exp release]
    #define UXY_RETAIN(exp) [exp retain]
#endif

/**************************************************************/
// 方法定义
//void (*__actionXY)(id, SEL, ...) = (void (*)(id, SEL, ...))objc_msgSend;
//void (*__actionXY_return_void)(id, SEL, ...);
//id (*__actionXY_return_id)(id, SEL, ...);
/**************************************************************/
// 主线程下同步会造成死锁
#undef dispatch_main_sync_safe
#define dispatch_main_sync_safe(block)\
        if ([NSThread isMainThread]) {\
            block();\
        } else {\
            dispatch_sync(dispatch_get_main_queue(), block);\
        }

#undef dispatch_main_async_safe
#define dispatch_main_async_safe(block)\
        if ([NSThread isMainThread]) {\
            block();\
        } else {\
            dispatch_async(dispatch_get_main_queue(), block);\
        }
/**************************************************************/
// 限制循环的最大次数, 到了后就跳出
#define uxy_loop_lomit( __maxCount )    \
        { NSUInteger __xy_count; if (__xy_count++ > __maxCount) { break; } }

/**************************************************************/
#pragma mark -end