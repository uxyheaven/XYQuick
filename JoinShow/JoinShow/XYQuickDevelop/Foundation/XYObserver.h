//
//  XYObserve.h
//  JoinShow
//
//  Created by Heaven on 13-11-6.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//
// kvo 的封装
#import "XYPrecompile.h"

#pragma mark - #define
#define KVO_NAME( __name )					__TEXT( __name )

#define	ON_KVO_1_( __property, __sourceObject, __newValue )     \
    - (void)__property##In:(id)sourceObject new:(id)newValue
#define	ON_KVO_2_( __property, __sourceObject, __newValue, __oldValue )     \
    - (void)__property##In:(id)sourceObject new:(id)newValue old:(id)oldValue

#undef	NSObject_observers
#define NSObject_observers	"NSObject.XYObserve.observers"

typedef enum {
    XYObserverType_new = 1,         // 参数只有new
    XYObserverType_new_old,         // 参数有new,old
}XYObserverType;

typedef void(^XYObserver_block_new_old)(id newValue, id oldValue);


#pragma mark - XYObserver
@interface XYObserver : NSObject

@end

#pragma mark - NSObject (XYObserve)
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



