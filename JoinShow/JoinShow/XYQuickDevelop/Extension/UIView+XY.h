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


@interface UIView (XY)

// 增加手势
-(void) addTapGestureWithTarget:(id)target action:(SEL)action;
-(void) addTapGestureWithBlock:(void(^)(void))aBlock;

-(void) removeTapGesture;

// 增加背景阴影
-(void) addShadeWithTarget:(id)target action:(SEL)action color:(UIColor *)aColor alpha:(float)aAlpha;
-(void) addShadeWithBlock:(void(^)(void))aBlock color:(UIColor *)aColor alpha:(float)aAlpha;
// 增加毛玻璃背景
-(void) addBlurWithTarget:(id)target action:(SEL)action;
-(void) addBlurWithTarget:(id)target action:(SEL)action level:(int)lv;
-(void) addBlurWithBlock:(void(^)(void))aBlock;
-(void) addBlurWithBlock:(void(^)(void))aBlock level:(int)lv;

-(void) removeShade;
-(UIView *) shadeView;

// 设置背景
-(void) setBg:(NSString *)str;

// 活动指示器
-(UIActivityIndicatorView *) addActivityIndicatorView;
-(void) removeActivityIndicatorView;

// 截屏
-(UIImage *) snapshot;

// 旋转 1:顺时针180度
-(void) setRotate:(float)f;


-(void) bindDataWithDic:(NSDictionary *)dic;

// 子类需要重新此方法
//+(void) setupDataBind:(NSMutableDictionary *)dic;

@end









