//
//  UIView+XY.h
//  TWP_SkyBookShelf
//
//  Created by Heaven on 13-7-31.
//
//

#define UIView_shadeTag 26601
#define UIView_activityIndicatorViewTag 26602

#define UIView_animation_instant 0.15

#import "XYUI.h"
#import "XYFoundation.h"
#import "XYPrecompile.h"

typedef void(^UIViewCategoryNormalBlock)(UIView *view);
typedef void(^UIViewCategoryAnimationBlock)(void);
@interface UIView (XY)

// 增加手势
- (void)addTapGestureWithTarget:(id)target action:(SEL)action;
- (void)addTapGestureWithBlock:(UIViewCategoryNormalBlock)aBlock;
- (void)removeTapGesture;

- (void)addLongPressGestureWithBlock:(UIViewCategoryNormalBlock)aBlock;
- (void)removeLongPressGesture;

// 增加背景阴影
- (void)addShadeWithTarget:(id)target action:(SEL)action color:(UIColor *)aColor alpha:(float)aAlpha;
- (void)addShadeWithBlock:(UIViewCategoryNormalBlock)aBlock color:(UIColor *)aColor alpha:(float)aAlpha;
// 增加毛玻璃背景
- (void)addBlurWithTarget:(id)target action:(SEL)action;
- (void)addBlurWithTarget:(id)target action:(SEL)action level:(int)lv;
- (void)addBlurWithBlock:(UIViewCategoryNormalBlock)aBlock;
- (void)addBlurWithBlock:(UIViewCategoryNormalBlock)aBlock level:(int)lv;

- (void)removeShade;
- (UIView *)shadeView;

// 设置背景
- (instancetype)bg:(NSString *)str;

// 旋转 1.0:顺时针180度
- (instancetype)rotate:(CGFloat)angle;

// 圆形
- (instancetype)rounded;
// 圆角矩形, corners:一个矩形的四个角。
- (instancetype)roundedRectWith:(CGFloat)radius;
- (instancetype)roundedRectWith:(CGFloat)radius byRoundingCorners:(UIRectCorner)corners;

// 边框大小,颜色
- (instancetype)borderWidth:(CGFloat)width color:(UIColor *)color;

// 活动指示器
- (UIActivityIndicatorView *)activityIndicatorViewShow;
- (void)activityIndicatorViewHidden;

// 截屏
- (UIImage *)snapshot;

// 淡出,然后移除
- (void)removeFromSuperviewWithCrossfade;

- (void)removeAllSubviews;
- (void)removeSubviewWithTag:(NSInteger)tag;
- (void)removeSubviewExceptTag:(NSInteger)tag;


#pragma mark -todo attribute
- (void)showDataWithDic:(NSDictionary *)dic;

// 子类需要重新此方法
//+ (void)setupDataBind:(NSMutableDictionary *)dic;

#pragma mark - animation
// 淡入淡出
- (void)animationCrossfadeWithDuration:(NSTimeInterval)duration;
- (void)animationCrossfadeWithDuration:(NSTimeInterval)duration completion:(UIViewCategoryAnimationBlock)completion;

/** 立方体翻转
 *kCATransitionFromRight, kCATransitionFromLeft, kCATransitionFromTop, kCATransitionFromBottom
 */
- (void)animationCubeWithDuration:(NSTimeInterval)duration direction:(NSString *)direction;
- (void)animationCubeWithDuration:(NSTimeInterval)duration direction:(NSString *)direction completion:(UIViewCategoryAnimationBlock)completion;

/** 翻转
 *kCATransitionFromRight, kCATransitionFromLeft, kCATransitionFromTop, kCATransitionFromBottom
 */
- (void)animationOglFlipWithDuration:(NSTimeInterval)duration direction:(NSString *)direction;
- (void)animationOglFlipWithDuration:(NSTimeInterval)duration direction:(NSString *)direction completion:(UIViewCategoryAnimationBlock)completion;

/** 覆盖
 *kCATransitionFromRight, kCATransitionFromLeft, kCATransitionFromTop, kCATransitionFromBottom
 */
- (void)animationMoveInWithDuration:(NSTimeInterval)duration direction:(NSString *)direction;
- (void)animationMoveInWithDuration:(NSTimeInterval)duration direction:(NSString *)direction completion:(UIViewCategoryAnimationBlock)completion;

// 抖动
- (void)animationShake;

// 返回所在的vc
- (UIViewController *)currentViewController;

@end






