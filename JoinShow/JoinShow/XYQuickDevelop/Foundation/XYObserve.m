//
//  XYObserve.m
//  JoinShow
//
//  Created by Heaven on 13-11-6.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import "XYObserve.h"
#import "XYPrecompile.h"

//static NSMutableDictionary *XY_OBSERVERS = nil;

@interface XYObserve ()
@property (nonatomic, assign) id target;
@property (nonatomic) SEL selector;
@property (nonatomic, assign) id observedObject;
@property (nonatomic,  strong) NSString* keyPath;
@end

@implementation XYObserve

+(void)load{
  //  XY_OBSERVERS = [[NSMutableDictionary alloc] initWithCapacity:8];
}

+(instancetype) observerWithObject:(id)object
                           keyPath:(NSString *)keyPath
                            target:(id)target
                          selector:(SEL)selector{
    return [[XYObserve alloc] initWithObject:object keyPath:keyPath target:target selector:selector];
}

-(instancetype) initWithObject:(id)object keyPath:(NSString*)keyPath target:(id)target selector:(SEL)selector
{
    self = [super init];
    if (self) {
        self.target = target;
        self.selector = selector;
        self.observedObject = object;
        self.keyPath = keyPath;
        [object addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:(__bridge void *)(self)];
    } 
    return self; 
}

-(void) observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context
{
    if (context == (__bridge void *)(self)) {
        id strongTarget = self.target;
        if ([strongTarget respondsToSelector:self.selector]) {
            [strongTarget performSelector:self.selector withObject:[change objectForKey:@"new"]];
        } 
    } 
}

-(void) dealloc
{
  //  NSLogDD
    id strongObservedObject = self.observedObject;
    if (strongObservedObject) {
        [strongObservedObject removeObserver:self forKeyPath:self.keyPath];
    }
    self.keyPath = nil;
}
@end

@implementation NSObject (XYObserveHelper)

@dynamic observers;

-(id) observers{
    id object = objc_getAssociatedObject(self, NSObject_observers);
    
    if (nil == object) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:8];
        objc_setAssociatedObject(self, NSObject_observers, dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return dic;
    }
    
    return object;
}

-(void) observeWithObject:(id)object property:(NSString*)property{
    NSString *key = property;
    SEL aSel = NSSelectorFromString([NSString stringWithFormat:@"%@Changed:", property]);
    [self observeWithObject:object keyPath:property target:self selector:aSel observeKey:key];
}
-(void) observeWithObject:(id)object keyPath:(NSString*)keyPath selector:(SEL)selector observeKey:(NSString *)key{
    [self observeWithObject:object keyPath:keyPath target:self selector:selector observeKey:key];
}
-(void) observeWithObject:(id)object keyPath:(NSString*)keyPath target:(id)target selector:(SEL)selector observeKey:(NSString *)key{
    NSAssert([target respondsToSelector:selector], @"selector 必须存在");
    
    XYObserve *ob = [XYObserve observerWithObject:object keyPath:keyPath target:target selector:selector];

    if (key && ob) {
        [self.observers setObject:ob forKey:key];
    }
}
-(void) removeObserverWithKey:(NSString *)key{
    if (key && self.observers) {
        [self.observers removeObjectForKey:key];
    }
}
-(void) removeAllObserver{
    if (self.observers) {
        [self.observers removeAllObjects];
    }
}
@end

                                                            
                                                            
                                                            
                                                            
                                                            
                                                            
                                                            
