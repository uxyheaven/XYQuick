//
//  XYNotification.h
//  JoinShow
//
//  Created by Heaven on 14-6-3.
//  Copyright (c) 2014年 Heaven. All rights reserved.
// NSNotification 的封装

#import <Foundation/Foundation.h>


#define	ON_NOTIFICATION_1_( __name )     -(void) __name##NotificationHandle:(NSNotification *)notification


#undef	NSObject_notifications
#define NSObject_notifications	"NSObject.XYNotification.notifications"

typedef void(^XYNotification_block)(NSNotification *notification);

#pragma mark - XYNotification
@interface XYNotification : NSObject

@end

#pragma mark - NSObject (XYNotification)
@interface NSObject (XYNotification)

@property (nonatomic, readonly, strong) NSMutableDictionary *notifications;

-(void) registerNotification:(NSString *)name;
-(void) registerNotification:(NSString *)name block:(XYNotification_block)block;

-(void) unregisterNotification:(NSString*)name;
-(void) unregisterAllNotification;

-(void) postNotification:(NSString *)name userInfo:(id)userInfo;

@end