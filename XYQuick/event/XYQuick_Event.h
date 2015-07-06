//
//  XYQuick_Event.h
//  JoinShow
//
//  Created by heaven on 15/5/6.
//  Copyright (c) 2015年 Heaven. All rights reserved.
//

#import <Foundation/Foundation.h>

// todo 统一event

// Modules
#import "XYSignal.h"                        // 责任链信号
#import "XYMulticastDelegate.h"             // 多路委托
#import "XYNotification.h"                  // Notification的封装
#import "XYObserver.h"                      // KVO的封装
#import "XYFlyweightTransmit.h"             // 轻量级的底层往高层传数据
// Extensions


@interface XYQuick_Event : NSObject

@end
