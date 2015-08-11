//
//  XYSignal.h
//  JoinShow
//
//  Created by heaven on 15/2/28.
//  Copyright (c) 2015年 Heaven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYQuick_Predefine.h"

#define uxy_handleSignal( __signal, __name ) \
        - (void)__uxy_handleSignal_n_##__name:(XYSignal *)__signal


#pragma mark -
// 声明 定义
#define uxy_as_signal( __name )     \
        extern NSString *const __name;
#define uxy_def_signal( __name )    \
        NSString *const __name = uxy_macro_string(__name);

#pragma mark -

#pragma mark - XYSignalTarget
@protocol XYSignalTarget
@property (nonatomic, weak) id uxy_nextSignalHandler;
@property (nonatomic, weak, readonly) id uxy_defaultNextSignalHandler;
@end

#pragma mark - Request && Response
@interface XYSignal : NSObject

// Request
@property (nonatomic, assign) BOOL isDead;  // 是否结束
@property (nonatomic, assign) BOOL isReach;      // 是否触达最后的Handler

@property (nonatomic, weak) id<XYSignalTarget> sender;          // 发送者

@property (nonatomic, assign) NSInteger jump;       // 跳转次数
@property (nonatomic, copy) NSString *name;     // 名字
@property (nonatomic, strong) id userInfo;        // 请求的参数

// Response
@property (nonatomic, strong) id response;       // 返回值

@end


#pragma mark- UXYSignalHandler

@interface NSObject (UXYSignalHandler)

- (XYSignal *)uxy_sendSignalWithName:(NSString *)name userInfo:(id)userInfo;
- (XYSignal *)uxy_sendSignalWithName:(NSString *)name userInfo:(id)userInfo sender:(id)sender;

@end

@interface UIView (UXYSignalHandler)<XYSignalTarget>
@end

@interface UIViewController (UXYSignalHandler)<XYSignalTarget>
@end

#pragma mark - XYSignalBus
// 暂时无用
/*
@interface XYSignalBus : NSObject
+ (instancetype)defaultBus;
@end
 */



