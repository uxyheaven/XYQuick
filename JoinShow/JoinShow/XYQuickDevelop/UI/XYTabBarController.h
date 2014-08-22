//
//  XYBaseTabBarController.h
//  JoinShow
//
//  Created by Heaven on 14-4-25.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#pragma mark -todo 待优化
#import "XYBaseClass.h"
#import "XYTabBar.h"

#pragma mark-
#pragma mark- XYTabBarController

@protocol XYTabBarControllerDelegate;

@interface XYTabBarController : XYBaseViewController<XYTabBarDelegate>

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
-(id) initWithViewControllers:(NSArray *)vcs items:(NSArray *)items;

// 可以重载这个方法, 自定义item的位置和图片文字尺寸
- (void)setupItem:(UIButton *)item index:(NSInteger)index;
// 重载这个方式, 自定义animatedView的位置
- (void)resetAnimatedView:(UIImageView *)animatedView index:(NSInteger)index;
// 重载这个方法设置TabBar透明前和透明后的content尺寸
- (void)setTabBarTransparent:(BOOL)b;

@end

#pragma mark-
#pragma mark- XYTabBarControllerProtocol
@protocol XYTabBarControllerProtocol <NSObject>
@optional
-(BOOL) tabBarController:(XYTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController;
- (void)tabBarController:(XYTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;
@end

#pragma mark-
#pragma mark- XYTabBarController()
@interface UIViewController (XYTabBarController)
@property(nonatomic, weak, readonly) XYTabBarController *xyTabBarController;
@end


