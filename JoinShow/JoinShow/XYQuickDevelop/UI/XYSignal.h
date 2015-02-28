//
//  XYSignal.h
//  JoinShow
//
//  Created by heaven on 15/2/28.
//  Copyright (c) 2015年 Heaven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYSignal : NSObject

@end

@interface UXYSignalResponse : NSObject

@property (nonatomic, strong) id returnValue;       // 返回值

@end

@interface UXYSignalRequest : NSObject

@property (nonatomic, assign) BOOL isDead;  // 是否结束
@property (nonatomic, assign) BOOL isReach;      // 是否触达最后的Handler

@property (nonatomic, weak) id source;      // 来源
@property (nonatomic, assign) NSInteger jump;       // 跳转次数
@property (nonatomic, copy) NSString *name;     // 名字
@property (nonatomic, strong) id parameters;        // 参数

@property (nonatomic, copy) NSMutableString *callPath;    // 调用路径

@end

#pragma mark- UXYSignalHandler

@interface NSObject (UXYSignalHandler)

@property (nonatomic, weak) id uxy_nextSignalHandler;

- (id)uxy_defaultNextSignalHandler;

// 处理任务
- (UXYSignalResponse *)uxy_signalExcute:(UXYSignalRequest *)request;

@end