//
//  XYBaseService.h
//  JoinShow
//
//  Created by Heaven on 14-9-12.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    XYServiceState_uninitialized = 0,       // 未初始化
    XYServiceState_ready,                   // 准备好
    XYServiceState_run,                     // 运行
    XYServiceState_stop,                    // 停止
    XYServiceState_pause,                   // 暂停
}XYServiceState;

@interface XYBaseService : NSObject

// 数据
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign, readonly) XYServiceState state;


@property (nonatomic, strong, readonly) NSMutableDictionary *dic;

// 初始化
+ (id)service;

// 状态相关接口
- (void) start;
- (void) stop;
- (void) pause;
//- (void) resume;

//- (void) refreshData;

@end
