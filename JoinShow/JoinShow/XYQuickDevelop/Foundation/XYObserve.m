//
//  XYObserve.m
//  JoinShow
//
//  Created by Heaven on 13-11-6.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import "XYObserve.h"
#import "XYPrecompile.h"

static NSMutableDictionary *XY_OBSERVERS = nil;

@interface XYObserve ()
@property (nonatomic, assign) id target;
@property (nonatomic) SEL selector;
@property (nonatomic, assign) id observedObject;
@property (nonatomic, copy) NSString* keyPath;
@end

@implementation XYObserve

+(void)load{
    XY_OBSERVERS = [[NSMutableDictionary alloc] initWithCapacity:8];
}

+(instancetype) observerWithObject:(id)object
                           keyPath:(NSString *)keyPath
                            target:(id)target
                          selector:(SEL)selector{
    return [[[XYObserve alloc] initWithObject:object keyPath:keyPath target:target selector:selector] autorelease];
}

-(id) initWithObject:(id)object keyPath:(NSString*)keyPath target:(id)target selector:(SEL)selector
{
    self = [super init];
    if (self) {
        self.target = target;
        self.selector = selector;
        self.observedObject = object;
        self.keyPath = keyPath;
        [object addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:self];
    } 
    return self; 
}

-(void) observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context
{
    if (context == self) {
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
    [super dealloc];
}
@end

@implementation NSObject (XYObserveHelper)

-(void) observeWithObject:(id)object keyPath:(NSString*)keyPath selector:(SEL)selector observeKey:(NSString *)key{
    [self observeWithObject:object keyPath:keyPath target:self selector:selector observeKey:key];
}
-(void) observeWithObject:(id)object keyPath:(NSString*)keyPath target:(id)target selector:(SEL)selector observeKey:(NSString *)key{
    XYObserve *ob = [XYObserve observerWithObject:object keyPath:keyPath target:target selector:selector];
  //  NSString *key = [NSString stringWithFormat:@"%@_%@_%@", NSStringFromClass([object class]), keyPath, NSStringFromClass([object class])];
    if (key && ob) {
        [XY_OBSERVERS setObject:ob forKey:key];
    }
}
-(void) removeObserverWithKey:(NSString *)key{
    if (key) {
        [XY_OBSERVERS removeObjectForKey:key];
    }
}
-(void) removeAllObserver{
    [XY_OBSERVERS removeAllObjects];
}
@end

                                                            
                                                            
                                                            
                                                            
                                                            
                                                            
                                                            
