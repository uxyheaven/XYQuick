//
//  XYRepository.h
//
//  Created by heaven on 15/4/29.
//  Copyright (c) 2015年 heaven. All rights reserved.
//

#import "XYQuick_Predefine.h"

@class XYRepositoryInterface;
@class XYRepositoryEvent;

@protocol XYRepositoryProtocol <NSObject>
- (void)XYRepositoryWithDataIdentifier:(NSString *)identifier event:(XYRepositoryEvent *)event;
@end


typedef void(^XYRepositoryCompletedBlock)(XYRepositoryEvent *event);

// 模块合作接口
@interface XYRepositoryInterface :NSObject
@property (nonatomic, weak) id receiver;
@property (nonatomic, assign) Class receiverClass;
@property (nonatomic, copy) NSString *identifier;
@end

// 模块合作事件
@interface XYRepositoryEvent : NSObject

// Request
@property (nonatomic, strong) XYRepositoryInterface *interface;
@property (nonatomic, copy) XYRepositoryCompletedBlock completedBlock;   // 完成后的回调

// Response
@property (nonatomic, assign) BOOL isAsync;     // 是否异步
@property (nonatomic, strong) id data;          // 数据
@property (nonatomic, strong) NSError *error;   // 错误信息

@end

// 资源库
@interface XYRepository : NSObject __AS_SINGLETON

#pragma mark- 注册相关
// 注册一个数据标识
- (void)registerDataIdentifier:(NSString *)identifier receiver:(id <XYRepositoryProtocol>)receiver;
- (void)registerDataIdentifier:(NSString *)identifier receiverClassName:(NSString *)className;

#pragma mark- 获取相关
// 获取数据
- (XYRepositoryEvent *)invocationDataIndentifier:(NSString *)identifier
                                  completedBlock:(XYRepositoryCompletedBlock)block;

@end
