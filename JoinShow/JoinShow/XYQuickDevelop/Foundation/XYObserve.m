//
//  XYObserve.m
//  JoinShow
//
//  Created by Heaven on 13-11-6.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import "XYObserve.h"
#import "XYPrecompile.h"

#pragma mark - XYObserve
@interface XYObserve ()

//@property (nonatomic, assign) XYObserveType type;
@property (nonatomic, assign) NSKeyValueObservingOptions options;

@property (nonatomic, assign) id target;
@property (nonatomic) SEL selector;
@property (nonatomic, assign) id observedObject;
@property (nonatomic,  strong) NSString* keyPath;

@end

@implementation XYObserve

-(instancetype) initWithObject:(id)object keyPath:(NSString*)keyPath target:(id)target selector:(SEL)selector options:(NSKeyValueObservingOptions)options
{
    self = [super init];
    if (self) {
        self.target = target;
        self.selector = selector;
        self.observedObject = object;
        self.keyPath = keyPath;
        self.options = options;
        [object addObserver:self forKeyPath:keyPath options:options context:(__bridge void *)(self)];
    } 
    return self; 
}

-(void) observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context
{
    if (context == (__bridge void *)(self)) {
        id target = self.target;
        
        if (self.options == XYObserve_new) {
            [target performSelector:self.selector
                         withObject:[change objectForKey:@"new"]];
        }else if (self.options == XYObserve_newAndNew) {
            [target performSelector:self.selector
                         withObject:[change objectForKey:@"new"]
                         withObject:[change objectForKey:@"old"]];
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

#pragma mark - NSObject (XYObserveHelper)
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
    if ([self respondsToSelector:aSel]) {
        [self observeWithObject:object
                        keyPath:property
                         target:self
                       selector:aSel
                     observeKey:key
                        options:XYObserve_new];
        return;
    }
    
    aSel = NSSelectorFromString([NSString stringWithFormat:@"%@Changed:old:", property]);
    if ([self respondsToSelector:aSel]) {
        [self observeWithObject:object
                        keyPath:property
                         target:self selector:aSel
                     observeKey:key
                        options:XYObserve_newAndNew];
        return;
    }
}

-(void) observeWithObject:(id)object keyPath:(NSString*)keyPath target:(id)target selector:(SEL)selector observeKey:(NSString *)key options:(NSKeyValueObservingOptions)options{
    NSAssert([target respondsToSelector:selector], @"selector 必须存在");

    XYObserve *ob = [[XYObserve alloc] initWithObject:object keyPath:keyPath target:target selector:selector options:options];

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

                                                            
                                                            
                                                            
                                                            
                                                            
                                                            
                                                            
