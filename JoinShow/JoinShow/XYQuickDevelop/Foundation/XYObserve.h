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


#define XYObserve_new (NSKeyValueObservingOptionNew)
#define XYObserve_newAndNew (NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)

#pragma mark - XYObserve
@interface XYObserve : NSObject

@end

#pragma mark - NSObject (XYObserveHelper)
@interface NSObject (XYObserveHelper)

@property (nonatomic, readonly, strong) NSMutableDictionary *observers;

// default: selector = @selector(propertyChanged:) or @selector(propertyChanged:Old:), key = property, target = self
-(void) observeWithObject:(id)object property:(NSString*)property;

-(void) observeWithObject:(id)object keyPath:(NSString*)keyPath target:(id)target selector:(SEL)selector observeKey:(NSString *)key options:(NSKeyValueObservingOptions)options;

-(void) removeObserverWithKey:(NSString *)key;
-(void) removeAllObserver;

@end



