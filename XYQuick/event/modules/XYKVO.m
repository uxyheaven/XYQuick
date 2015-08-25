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

#import "XYKVO.h"
#import "XYQuick_Predefine.h"
#import "NSObject+XY.h"

void (*XYKVO_action2)(id, SEL, id, id) = (void (*)(id, SEL, id, id))objc_msgSend;
void (*XYKVO_action3)(id, SEL, id, id, id) = (void (*)(id, SEL, id, id, id))objc_msgSend;

typedef enum {
    XYKVOType_new = 1,         // 参数只有new
    XYKVOType_new_old,         // 参数有new,old
}XYKVOType;

#pragma mark - XYKVO
@interface XYKVO ()

@property (nonatomic, assign) XYKVOType type;      // 观察者的类型

@property (nonatomic, weak) id target;                  // 被观察的对象的值改变时后的响应方法所在的对象
@property (nonatomic, assign) SEL selector;             // 被观察的对象的值改变时后的响应方法
@property (nonatomic, copy) XYKVO_block_new_old block;        // 值改变时执行的block

@property (nonatomic, assign) id sourceObject;         // 被观察的对象
@property (nonatomic, copy) NSString *keyPath;        // 被观察的对象的keyPath

- (instancetype)initWithSourceObject:(id)sourceObject keyPath:(NSString*)keyPath target:(id)target selector:(SEL)selector type:(XYKVOType)type;

- (instancetype)initWithSourceObject:(id)sourceObject keyPath:(NSString*)keyPath block:(XYKVO_block_new_old)block;

@end

@implementation XYKVO

- (instancetype)initWithSourceObject:(id)sourceObject keyPath:(NSString*)keyPath target:(id)target selector:(SEL)selector type:(XYKVOType)type
{
    self = [super init];
    if (self)
    {
        _target       = target;
        _selector     = selector;
        _sourceObject = sourceObject;
        _keyPath      = keyPath;
        _type         = type;
        NSKeyValueObservingOptions options = (_type == XYKVOType_new) ? NSKeyValueObservingOptionNew : (NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld);
        [_sourceObject addObserver:self forKeyPath:keyPath options:options context:nil];
    }
    
    return self; 
}

- (instancetype)initWithSourceObject:(id)sourceObject keyPath:(NSString*)keyPath block:(XYKVO_block_new_old)block
{
    self = [super init];
    if (self)
    {
        _sourceObject = sourceObject;
        _keyPath      = keyPath;
        _block        = block;
        [_sourceObject addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
    
    return self;
}
- (void)dealloc
{
    //NSLogD(@"%@", _keyPath);
    if (_sourceObject)
        [_sourceObject removeObserver:self forKeyPath:_keyPath];
}

#pragma mark NSKeyValueObserving
- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context
{
    if (_block)
    {
        _block(change[NSKeyValueChangeNewKey], change[NSKeyValueChangeOldKey]);
        return;
    }
    
    if (_type == XYKVOType_new)
    {
        XYKVO_action2(_target, _selector, _sourceObject, change[NSKeyValueChangeNewKey]);
    }
    else if (_type == XYKVOType_new_old)
    {
        XYKVO_action3(_target, _selector, _sourceObject, change[NSKeyValueChangeNewKey] , change[NSKeyValueChangeOldKey]);
    }
}

@end

#pragma mark - NSObject (XYKVOPrivate)
@interface NSObject (XYKVOPrivate)

- (void)observeWithObject:(id)sourceObject keyPath:(NSString*)keyPath target:(id)target selector:(SEL)selector type:(XYKVOType)type;

@end

@implementation NSObject (XYKVO)

uxy_staticConstString(NSObject_observers)

- (id)uxy_observers
{
    id object = [self uxy_getAssociatedObjectForKey:NSObject_observers];
    
    if (nil == object)
    {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:4];
        [self uxy_retainAssociatedObject:dic forKey:NSObject_observers];
        return dic;
    }
    
    return object;
}

- (void)uxy_observeWithObject:(id)object property:(NSString*)property
{
    SEL aSel = nil;
    
    aSel = NSSelectorFromString([NSString stringWithFormat:@"__uxy_handleKVO_%@_in:new:", property]);
    if ([self respondsToSelector:aSel])
    {
        [self observeWithObject:object
                        keyPath:property
                         target:self
                       selector:aSel
                           type:XYKVOType_new];
        return;
    }
    
    aSel = NSSelectorFromString([NSString stringWithFormat:@"__uxy_handleKVO_%@_in:new:old:", property]);
    if ([self respondsToSelector:aSel])
    {
        [self observeWithObject:object
                        keyPath:property
                         target:self
                       selector:aSel
                           type:XYKVOType_new_old];
        return;
    }
}

- (void)uxy_observeWithObject:(id)object property:(NSString*)property block:(XYKVO_block_new_old)block{
    [self observeWithObject:object keyPath:property block:block];
}

- (void)observeWithObject:(id)object keyPath:(NSString*)keyPath target:(id)target selector:(SEL)selector type:(XYKVOType)type
{
    NSAssert([target respondsToSelector:selector], @"selector 必须存在");
    NSAssert(keyPath.length > 0, @"property 必须存在");
    NSAssert(object, @"被观察的对象object 必须存在");
    
    XYKVO *ob = [[XYKVO alloc] initWithSourceObject:object keyPath:keyPath target:target selector:selector type:type];

    NSString *key = [NSString stringWithFormat:@"%@_%@", object, keyPath];
    [self.uxy_observers setObject:ob forKey:key];
}

- (void)observeWithObject:(id)object keyPath:(NSString*)keyPath block:(XYKVO_block_new_old)block
{
    NSAssert(block, @"block 必须存在");
    
    XYKVO *ob = [[XYKVO alloc] initWithSourceObject:object keyPath:keyPath block:block];
    
    NSString *key = [NSString stringWithFormat:@"%@_%@", object, keyPath];
    [self.uxy_observers setObject:ob forKey:key];
}

- (void)uxy_removeObserverWithObject:(id)object property:(NSString *)property
{
    NSString *key = [NSString stringWithFormat:@"%@_%@", object, property];
    [self.uxy_observers removeObjectForKey:key];
}

- (void)uxy_removeObserverWithObject:(id)object
{
    NSString *prefix = [NSString stringWithFormat:@"%@", object];
    [self.uxy_observers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([key hasPrefix:prefix])
        {
            [self.uxy_observers removeObjectForKey:key];
        }
    }];
}

- (void)uxy_removeAllObserver
{
    [self.uxy_observers removeAllObjects];
}

@end

                                                            

                                                            
                                                            
                                                            
                                                            
                                                            
