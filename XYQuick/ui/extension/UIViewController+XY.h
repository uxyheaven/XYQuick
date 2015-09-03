//
//  __  __          ____           _          _
//  \ \/ / /\_/\   /___ \  _   _  (_)   ___  | | __
//   \  /  \_ _/  //  / / | | | | | |  / __| | |/ /
//   /  \   / \  / \_/ /  | |_| | | | | (__  |   <
//  /_/\_\  \_/  \___,_\   \__,_| |_|  \___| |_|\_\
//
//  Copyright (C) Heaven.
//
//	https://github.com/uxyheaven/XYQuick
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.
//

#import "XYQuick_Predefine.h"
#pragma mark -

typedef void(^UIViewController_block_void) (void);
typedef void(^UIViewController_block_view) (UIView *view);

@interface UIViewController (XY)

@property (nonatomic, strong) id uxy_parameters; // 参数

// 导航
- (void)uxy_pushVC:(NSString *)vcName;
- (void)uxy_pushVC:(NSString *)vcName object:(id)object;
- (void)uxy_popVC;

// 模态 带导航控制器
- (void)uxy_modalVC:(NSString *)vcName withNavigationVC:(NSString *)navName;
- (void)uxy_modalVC:(NSString *)vcName withNavigationVC:(NSString *)navName object:(id)object succeed:(UIViewController_block_void)block;
- (void)uxy_dismissModalVC;
- (void)uxy_dismissModalVCWithSucceed:(UIViewController_block_void)block;

#define UserGuide_tag 30912

/**
 * @brief 显示用户引导图
 * @param imgName 图片名称,默认用无图片缓存方式加载, UIImageView tag == UserGuide_tag
 * @param key 引导图的key,默认每个key只显示一次
 * @param frameString 引导图的位置, full 全屏, center 居中, frame : @"{{0,0},{100,100}}", center : @"{{100,100}}"
 * @param block 点击背景执行的方法, 默认是淡出
 * @return 返回底层的蒙板view
 */
- (id)uxy_showUserGuideViewWithImage:(NSString *)imgName
                                 key:(NSString *)key
                          alwaysShow:(BOOL)isAlwaysShow
                               frame:(NSString *)frameString
                          tapExecute:(UIViewController_block_view)block;


@end

@protocol XYSwitchControllerProtocol <NSObject>

- (id)initWithObject:(id)object;

@end