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
@interface XYRepositoryInterface : NSObject
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

#pragma mark - 聚合
@interface Aggregate : NSObject
@property (nonatomic, copy, readonly) NSString *key;
@property (nonatomic, strong) id root;  // you can observe this object. if you dont this object owner, dont change it? 如果你不是这个对象的持有者,最好不要改变他本身
@end


#pragma mark -
// 资源库
@interface XYRepository : NSObject

@property (nonatomic, copy, readonly) NSString *domain;

/*
#pragma mark - 注册相关
// 注册一个数据标识
- (void)registerDataAtIdentifier:(NSString *)identifier receiver:(id <XYRepositoryProtocol>)receiver;
- (void)registerDataAtIdentifier:(NSString *)identifier receiverClassName:(NSString *)className;

#pragma mark - 获取相关
// 获取数据
- (XYRepositoryEvent *)invocationDataIndentifier:(NSString *)identifier
                                  completedBlock:(XYRepositoryCompletedBlock)block;
*/

+ (instancetype)repositoryWithDomain:(NSString *)domain;

- (Aggregate *)aggregateForKey:(NSString *)key;
- (void)setAnAggregateRoot:(id)root forKey:(NSString *)key;
- (void)removeAggregateForKey:(NSString *)key;

@end
