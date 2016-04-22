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

#import "XYQuick_Predefine.h"
#pragma mark -

#pragma mark - #define

// 声明一个notification name
#define uxy_def_notification_name( __name )                      uxy_staticConstString( __name )

// 响应一个 notification
#define uxy_handleNotification( __name, __notification ) \
        - (void)__uxy_handleNotification_##__name:(NSNotification *)__notification

typedef void(^XYNotification_block)(NSNotification *notification);

#pragma mark - XYNotification
@interface XYNotification : NSObject

@end

#pragma mark - NSObject (XYNotification)
// 注意这里 self 自己可能是被观察者; 也可能 self 持有了观察者, 在self 销毁的时候, 取消所有的观察
@interface NSObject (XYNotification)

@property (nonatomic, readonly, strong) NSMutableDictionary *uxy_notifications;

- (void)uxy_registerNotification:(const char *)name;
- (void)uxy_registerNotification:(const char *)name block:(XYNotification_block)block;

- (void)uxy_unregisterNotification:(const char *)name;
- (void)uxy_unregisterAllNotification;

- (void)uxy_postNotification:(const char *)name userInfo:(id)userInfo;

@end