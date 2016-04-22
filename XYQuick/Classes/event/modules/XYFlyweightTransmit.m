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

#pragma mark - UXYFlyweightTransmit

@implementation NSObject (UXYFlyweightTransmit)

uxy_staticConstString(NSObject_key_flyweightData)
- (id)uxy_flyweightData
{
    return objc_getAssociatedObject(self, NSObject_key_flyweightData);
}

- (void)setUxy_flyweightData:(id)uxy_flyweightData
{
    [self willChangeValueForKey:@"uxy_flyweightData"];
    objc_setAssociatedObject(self, NSObject_key_flyweightData, uxy_flyweightData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"uxy_flyweightData"];
}

uxy_staticConstString(NSObject_key_objectDic)
- (void)uxy_receiveObject:(void(^)(id object))aBlock withIdentifier:(NSString *)identifier
{
    NSMutableDictionary *dic = objc_getAssociatedObject(self, NSObject_key_objectDic) ?: ({
        NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithCapacity:4];
        objc_setAssociatedObject(self, NSObject_key_objectDic, tmpDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        tmpDic;
    });
    
    dic[identifier ?: @"uxy_sendObject"] = [aBlock copy];
}

- (void)uxy_sendObject:(id)anObject withIdentifier:(NSString *)identifier
{
    NSDictionary *dic = objc_getAssociatedObject(self, NSObject_key_objectDic);
    if (dic == nil) return;
    
    void(^aBlock)(id anObject) = dic[identifier ?: @"uxy_sendObject"];
    aBlock(anObject);
}

uxy_staticConstString(NSObject_key_eventBlockDic)
- (void)uxy_handlerEventWithBlock:(id)aBlock withIdentifier:(NSString *)identifier
{
    NSMutableDictionary *dic = objc_getAssociatedObject(self, NSObject_key_eventBlockDic) ?: ({
        NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithCapacity:4];
        objc_setAssociatedObject(self, NSObject_key_eventBlockDic, tmpDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        tmpDic;
    });
    
    dic[identifier ?: @"uxy_handlerEvent"] = [aBlock copy];
}

- (id)uxy_blockForEventWithIdentifier:(NSString *)identifier
{
    NSDictionary *dic = objc_getAssociatedObject(self, NSObject_key_eventBlockDic);
    if(dic == nil) return nil;
    
    return dic[identifier ?: @"uxy_handlerEvent"];
}

@end;