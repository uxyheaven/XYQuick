//
//  PopViewHelper.m
//  JoinShow
//
//  Created by Heaven on 13-11-1.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import "XYPopupViewHelper.h"
#import "XYExtension.h"
@interface XYPopupViewHelper ()

@property (nonatomic, assign) UIView    *popupVIew;
@property (nonatomic, copy) void (^dismissBlock)(UIView *aView);
@property (nonatomic, copy) void (^showAnimation)(UIView *aView);
@property (nonatomic, copy) void (^dismissAnimation)(UIView *aView);

@property (nonatomic, assign) PopupViewBGType    popupViewBGType;


@end

@implementation XYPopupViewHelper

DEF_SINGLETON(XYPopupViewHelper)

- (id)init
{
    self = [super init];
    if (self) {
        self.colorLump = [UIColor blackColor];
        self.colorLumpAlpha = 0.7;
        self.blurLevel = 10;
        self.showAnimation = ^(UIView *aView){
            aView.alpha = 0.2;
            aView.transform = CGAffineTransformMakeScale(0.77, 0.77);
            [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                aView.alpha = 1;
                aView.transform = CGAffineTransformIdentity;
            } completion:nil];
        };
        
        self.dismissAnimation = ^(UIView *aView){
            [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    aView.alpha = .2;
                    aView.transform = CGAffineTransformMakeScale(1.2, 1.2);
            } completion:^(BOOL finished) {
                if (finished) {
                    [aView removeFromSuperview];
                }
            }];
        };
    }
    return self;
}
-(void) popupView:(UIView* )aView
             type:(PopupViewBGType)aType
touchOutsideHidden:(BOOL)hidden
     dismissBlock:(void(^)(UIView *aView))dismissBlock{
    if (aView == nil) {
        return;
    }
    if (_popupVIew != nil) {
        [self dismissPopup];
    }
    self.dismissBlock = dismissBlock;
    
    UIViewController *vc = [XYCommon topMostController];
    
    _popupViewBGType = aType;
    id target = hidden ? self : nil;
    // 添加背景
    if (_popupViewBGType == PopupViewOption_none) {
        [vc.view addShadeWithTarget:target action:@selector(dismissPopup) color:[UIColor clearColor] alpha:1];
    }else if (_popupViewBGType == PopupViewOption_colorLump) {
        [vc.view addShadeWithTarget:target action:@selector(dismissPopup) color:self.colorLump alpha:self.colorLumpAlpha];
    }else if(_popupViewBGType == filePathOption_blur) {
        [vc.view addBlurWithTarget:target action:@selector(dismissPopup) level:self.blurLevel];
    }
    
    self.popupVIew = aView;
    [vc.view addSubview:_popupVIew];
    
    if (self.showAnimation) {
        self.showAnimation(_popupVIew);
    }

}
-(void) popupView:(UIView* )aView type:(PopupViewBGType)aType dismissBlock:(void(^)(UIView *aView))dismissBlock{
    [self popupView:aView type:aType touchOutsideHidden:YES dismissBlock:dismissBlock];
    }
-(void) dismissPopup{
    UIViewController *vc = [XYCommon topMostController];

    // 移除背景
    [vc.view removeShade];

    if (_dismissAnimation) {
        _dismissAnimation(_popupVIew);
    }
    
    if (_dismissBlock) {
        _dismissBlock(_popupVIew);
        self.dismissBlock = nil;
    }
    self.popupVIew = nil;
}
-(void) setShowAnimationBlock:(void(^)(UIView *aView))aBlock{
    self.showAnimation = aBlock;
    
}
-(void) setDismissAnimationBlock:(void(^)(UIView *aView))aBlock{
    self.dismissAnimation = aBlock;
}
@end

#pragma mark -UIView
@implementation UIView (XYPopupViewHelper)

-(void) popupWithtype:(PopupViewBGType)aType
   touchOutsideHidden:(BOOL)hidden
         dismissBlock:(void(^)(UIView *aView))dismissBlock{
    [[XYPopupViewHelper sharedInstance] popupView:self type:aType  touchOutsideHidden:hidden dismissBlock:dismissBlock];
}
-(void) popupWithtype:(PopupViewBGType)aType
         dismissBlock:(void(^)(UIView *aView))dismissBlock{
    [self popupWithtype:aType touchOutsideHidden:YES dismissBlock:dismissBlock];
}
-(void) dismissPopup{
    [[XYPopupViewHelper sharedInstance] dismissPopup];
}

@end