//
//  XYTabBar.h
//  JoinShow
//
//  Created by Heaven on 14-4-25.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import "XYBaseView.h"
@protocol XYTabBarDelegate;

@interface XYTabBar : XYBaseView

#pragma mark- data
// 定义data


#pragma mark- view
// 定义view
@property (nonatomic, strong, readonly) NSMutableArray *items;            // 选项
@property (nonatomic, strong, readonly) UIImageView *backgroundView;      // 背景
@property (nonatomic, strong) UIImageView *animatedView;        // 选中item时的图片


#pragma mark - v对c
// 1 target-action

// 2 delegate(should, will, did)
@property (nonatomic, weak) id<XYTabBarDelegate> delegate;
// 3 dataSource(count, data at)
@property (nonatomic, weak) id dataSource;


#pragma mark- c直接调用
// Outlet
// item: @{@"normal" :img1, @"highlighted" :img2, @"selected" :img3, @"disabled":img4, @"text": text}
- (id) initWithFrame:(CGRect)frame items:(NSArray *)items;
- (void)selectTabAtIndex:(NSInteger)index;
- (void)setBackgroundImage:(UIImage *)img;

//- (void)removeTabAtIndex:(NSInteger)index;
//- (void)insertTabWithImageDic:(NSDictionary *)dict atIndex:(NSUInteger)index;

// 在这里设置item的位置和图片文字尺寸
- (void)setupItem:(UIButton *)item index:(NSInteger)index;
// 在这里设置animatedView的位置
- (void)resetAnimatedView:(UIImageView *)animatedView index:(NSInteger)index;

@end

@protocol XYTabBarDelegate<NSObject>
@optional
- (BOOL)tabBar:(XYTabBar *)tabBar shouldSelectIndex:(NSInteger)index;
- (void)tabBar:(XYTabBar *)tabBar didSelectIndex:(NSInteger)index;
- (void)tabBar:(XYTabBar *)tabBar animatedView:(UIImageView *)animatedView item:(UIButton *)item index:(NSInteger)index;
@end
