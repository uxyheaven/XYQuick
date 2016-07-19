//
//  __  __          ____           _          _
//  \ \/ / /\_/\   /___ \  _   _  (_)   ___  | | __
//   \  /  \_ _/  //  / / | | | | | |  / __| | |/ /
//   /  \   / \  / \_/ /  | |_| | | | | (__  |   <
//  /_/\_\  \_/  \___,_\   \__,_| |_|  \___| |_|\_\
// //
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
#import "XYTabBar.h"
#pragma mark -


#pragma mark-
#pragma mark- XYTabBarController

@protocol XYTabBarControllerDelegate;

@interface XYTabBarController : UIViewController<XYTabBarDelegate>

#pragma mark- model
// 定义model
@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, weak, readonly) UIViewController *selectedViewController;
@property (nonatomic, strong, readonly) NSArray *viewControllers;

@property (nonatomic, assign) CGRect tabBarFrame;   // the default height is 49 at bottom.
@property (nonatomic, assign) CGRect contentFrame;  // the default frame is self.view.bounds without tabBarFrame


#pragma mark- view
// 定义view
@property (nonatomic, strong, readonly) XYTabBar *tabBar;
@property (nonatomic, strong, readonly) UIView *contentView; // 子视图控制器显示的view

@property (nonatomic, weak) id<XYTabBarControllerDelegate> delegate;


// item: @{@"normal" :img1, @"highlighted" :img2, @"selected" :img3, @"disabled":img4, @"text": text}
- (id)initWithViewControllers:(NSArray *)vcs items:(NSArray *)items;

// 可以重载这个方法, 自定义item的位置和图片文字尺寸
- (void)setupItem:(UIButton *)item index:(NSInteger)index;
// 重载这个方式, 自定义animatedView的位置
- (void)resetAnimatedView:(UIImageView *)animatedView index:(NSInteger)index;
// 重载这个方法设置TabBar透明前和透明后的content尺寸
//- (void)setTabBarTransparent:(BOOL)b;

@end

#pragma mark-
#pragma mark- XYTabBarControllerProtocol
@protocol XYTabBarControllerProtocol <NSObject>
@optional
- (BOOL)tabBarController:(XYTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController;
- (void)tabBarController:(XYTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;
@end

#pragma mark-
#pragma mark- XYTabBarController()
@interface UIViewController (XYTabBarController)
@property(nonatomic, weak, readonly) XYTabBarController *xyTabBarController;
@end


