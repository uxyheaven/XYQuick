//
//  XYNotification.h
//  JoinShow
//
//  Created by Heaven on 14-6-3.
//  Copyright (c) 2014年 Heaven. All rights reserved.
// NSNotification 的封装

#import <Foundation/Foundation.h>
#import "XYPredefine.h"

#pragma mark - #define
#define NOTIFICATION_NAME( __name )					__TEXT( __name )

#define	ON_NOTIFICATION_1_( __name, __notification )     \
    - (void)__name##NotificationHandle:(NSNotification *)__notification

#undef	NSObject_notifications
#define NSObject_notifications	"NSObject.XYNotification.notifications"

typedef void(^XYNotification_block)(NSNotification *notification);

#pragma mark - XYNotification
@interface XYNotification : NSObject

@end

#pragma mark - NSObject (XYNotification)
// 注意这里 self 自己可能是被观察者; 也可能 self 持有了观察者, 在self 销毁的时候, 取消所有的观察
@interface NSObject (XYNotification)

@property (nonatomic, readonly, strong) NSMutableDictionary *notifications;

- (void)registerNotification:(NSString *)name;
- (void)registerNotification:(NSString *)name block:(XYNotification_block)block;

- (void)unregisterNotification:(NSString*)name;
- (void)unregisterAllNotification;

- (void)postNotification:(NSString *)name userInfo:(id)userInfo;

@end