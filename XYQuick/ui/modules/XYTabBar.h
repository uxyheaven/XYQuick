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

@protocol XYTabBarDelegate;

@interface XYTabBar : UIView

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
- (id)initWithFrame:(CGRect)frame items:(NSArray *)items;
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
