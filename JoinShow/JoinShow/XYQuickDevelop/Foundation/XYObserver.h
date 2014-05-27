//
//  XYObserve.h
//  JoinShow
//
//  Created by Heaven on 13-11-6.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//
// kvo 的封装
#import "XYPrecompile.h"

#undef	NSObject_observers
#define NSObject_observers	"NSObject.XYObserve.observers"

#define XYObserver_newAndNew (NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)

typedef enum {
    XYObserverType_new = 1,         // 参数只有new
    XYObserverType_new_old,         // 参数有new,old
    XYObserverType_self_new,        // 参数有self,new
    XYObserverType_self_new_old,    // 参数有self,new,old
}XYObserverType;

typedef void(^XYObserver_block_sourceObject_new_old)(id sourceObject, id newValue,id oldValue);


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
 
 * selector @selector(propertyNew:)
            @selector(propertyNew:old:)
            @selector(propertyIn:new:)
            @selector(propertyIn:new:old:)
 
 * type 根据selector自动赋值
 
 * block selector, block二选一
 */
-(void) observeWithObject:(id)sourceObject property:(NSString*)property;
-(void) observeWithObject:(id)sourceObject property:(NSString*)property block:(XYObserver_block_sourceObject_new_old)block;

-(void) removeObserverWithObject:(id)sourceObject property:(NSString *)property;
-(void) removeObserverWithObject:(id)sourceObject;
-(void) removeAllObserver;

@end



