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

#import "XYFlyweightTransmit.h"
#import "XYQuick_Predefine.h"

#pragma mark - UXYFlyweightTransmit
#define NSObject_key_flyweightData	"UXY.NSObject.flyweightData"
#define NSObject_key_objectDic	"UXY.NSObject.objectDic"
#define NSObject_key_eventBlockDic	"UXY.NSObject.eventBlockDic"

@implementation NSObject (UXYFlyweightTransmit)

- (id)uxy_flyweightData
{
    return objc_getAssociatedObject(self, NSObject_key_flyweightData);
}

- (void)setUxy_flyweightData:(id)flyweightData
{
    [self willChangeValueForKey:@"uxy_flyweightData"];
    objc_setAssociatedObject(self, NSObject_key_flyweightData, flyweightData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"uxy_flyweightData"];
}


- (void)uxy_receiveObject:(void(^)(id object))aBlock withIdentifier:(NSString *)identifier
{
    NSString *key = identifier ?: @"uxy_sendObject";
    NSMutableDictionary *dic = objc_getAssociatedObject(self, NSObject_key_objectDic);
    if(dic == nil)
    {
        dic = [NSMutableDictionary dictionaryWithCapacity:4];
        objc_setAssociatedObject(self, NSObject_key_objectDic, dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    [dic setObject:[aBlock copy] forKey:key];
}

- (void)uxy_sendObject:(id)anObject withIdentifier:(NSString *)identifier
{
    NSString *key = identifier ?: @"uxy_sendObject";
    NSDictionary *dic = objc_getAssociatedObject(self, NSObject_key_objectDic);
    if(dic == nil)
    {
        return;
    }
    
    void(^aBlock)(id anObject) = [dic objectForKey:key];
    aBlock(anObject);
}

- (void)uxy_handlerEventWithBlock:(id)aBlock withIdentifier:(NSString *)identifier
{
    NSString *key = identifier ?: @"uxy_handlerEvent";
    NSMutableDictionary *dic = objc_getAssociatedObject(self, NSObject_key_eventBlockDic);
    if(dic == nil)
    {
        dic = [NSMutableDictionary dictionaryWithCapacity:4];
        objc_setAssociatedObject(self, NSObject_key_eventBlockDic, dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    [dic setObject:[aBlock copy] forKey:key];
}

- (id)uxy_blockForEventWithIdentifier:(NSString *)identifier
{
    NSString *key = identifier ?: @"uxy_handlerEvent";
    NSDictionary *dic = objc_getAssociatedObject(self, NSObject_key_eventBlockDic);
    if(dic == nil)
        return nil;
    
    return [dic objectForKey:key];
}

@end;