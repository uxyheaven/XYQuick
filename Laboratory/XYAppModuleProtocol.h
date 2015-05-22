//
//  XYAppModuleProtocol.h
//  JoinShow
//
//  Created by heaven on 14/12/19.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XYAppModuleProtocol <NSObject>

@property (nonatomic, copy, readonly) NSString *name;       // 名字
@property (nonatomic, copy, readonly) NSString *icon;       // 图标
@property (nonatomic, copy, readonly) NSString *rootViewControllerKey; // 模块的根viewcontroller的key

// 设置模块的viewController
- (void)setupViewControllers;

// 设置模块之间的数据交换
- (void)setupCooperatives;

@end
