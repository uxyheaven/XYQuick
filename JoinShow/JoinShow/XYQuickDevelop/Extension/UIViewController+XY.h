//
//  UIViewController+XY.h
//  JoinShow
//
//  Created by Heaven on 14-4-24.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UIViewController_block_void) (void);
typedef void(^UIViewController_block_view) (UIView *view);

@interface UIViewController (XY)

@property (nonatomic, strong) id parameters; // 参数

// 导航
- (void)pushVC:(NSString *)vcName;
- (void)pushVC:(NSString *)vcName object:(id)object;
- (void)popVC;

// 模态 带导航控制器
- (void)modalVC:(NSString *)vcName withNavigationVC:(NSString *)navName;
- (void)modalVC:(NSString *)vcName withNavigationVC:(NSString *)navName object:(id)object succeed:(UIViewController_block_void)block;
- (void)dismissModalVC;
- (void)dismissModalVCWithSucceed:(UIViewController_block_void)block;

#define UserGuide_tag 30912

/**
 * @brief 显示用户引导图
 * @param imgName 图片名称,默认用无图片缓存方式加载, UIImageView tag == UserGuide_tag
 * @param key 引导图的key,默认每个key只显示一次
 * @param frameString 引导图的位置, full 全屏, center 居中, frame : @"{{0,0},{100,100}}", center : @"{{100,100}}"
 * @param block 点击背景执行的方法, 默认是淡出
 * @return 返回底层的蒙板view
 */
- (id)showUserGuideViewWithImage:(NSString *)imgName
                             key:(NSString *)key
                      alwaysShow:(BOOL)isAlwaysShow
                           frame:(NSString *)frameString
                      tapExecute:(UIViewController_block_view)block;

@end

@protocol XYSwitchControllerProtocol <NSObject>

-(id) initWithObject:(id)object;

@end