//
//  XYObserve.m
//  JoinShow
//
//  Created by Heaven on 13-11-6.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import "XYObserve.h"
#import "XYPrecompile.h"

@interface XYObserve ()
@property (nonatomic, assign) id target;
@property (nonatomic) SEL selector;
@property (nonatomic, assign) id observedObject;
@property (nonatomic, copy) NSString* keyPath;
@end

@implementation XYObserve

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
    NSLogDD
    self.keyPath = nil;
    id strongObservedObject = self.observedObject;
    if (strongObservedObject) {
        [strongObservedObject removeObserver:self forKeyPath:self.keyPath];
    }
    [super dealloc];
}
@end

@implementation XYObserveHelper

DEF_SINGLETON(XYObserveHelper)

- (id)init
{
    self = [super init];
    if (self) {
        _observers = [[NSMutableDictionary alloc] initWithCapacity:16];
    }
    return self;
}

@end

@implementation NSObject (XYObserveHelper)

-(void) observeWithObject:(id)object keyPath:(NSString*)keyPath selector:(SEL)selector observeKey:(NSString *)key{
    [self observeWithObject:object keyPath:keyPath target:self selector:selector observeKey:key];
}
-(void) observeWithObject:(id)object keyPath:(NSString*)keyPath target:(id)target selector:(SEL)selector observeKey:(NSString *)key{
    XYObserve *ob = [XYObserve observerWithObject:object keyPath:keyPath target:target selector:selector];
  //  NSString *key = [NSString stringWithFormat:@"%@_%@_%@", NSStringFromClass([object class]), keyPath, NSStringFromClass([object class])];
    
    [[XYObserveHelper sharedInstance].observers setObject:ob forKey:key];
}
-(void) removeObserverWithKey:(NSString *)key{
    [[XYObserveHelper sharedInstance].observers removeObjectForKey:key];
}
-(void) removeAllObserver{
    [[XYObserveHelper sharedInstance].observers removeAllObjects];
}
@end

                                                            
                                                            
                                                            
                                                            
                                                            
                                                            
                                                            
