//
//  PopViewManager.h
//  JoinShow
//
//  Created by Heaven on 13-11-1.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import "XYPrecompile.h"
#import "XYFoundation.h"

typedef enum {
    PopupViewOption_none = 1, 
    PopupViewOption_colorLump,
    PopupViewOption_blur
} PopupViewBGType;

@interface XYPopupViewHelper : NSObject

XY_SINGLETON(XYPopupViewHelper)

@property (nonatomic, retain) UIColor       *colorLump;
@property (nonatomic, assign) float         colorLumpAlpha;
@property (nonatomic, assign) int           blurLevel;

-(void) setShowAnimationBlock:(void(^)(UIView *aView))aBlock;
-(void) setDismissAnimationBlock:(void(^)(UIView *aView))aBlock;

-(void) popupView:(UIView* )aView
             type:(PopupViewBGType)aType
touchOutsideHidden:(BOOL)hidden
     succeedBlock:(void(^)(UIView *aView))succeedBlock
     dismissBlock:(void(^)(UIView *aView))dismissBlock;

-(void) popupView:(UIView* )aView
             type:(PopupViewBGType)aType
     succeedBlock:(void(^)(UIView *aView))succeedBlock
     dismissBlock:(void(^)(UIView *aView))dismissBlock;

-(void) dismissPopup;

@end

#pragma mark -UIView
@interface UIView (XYPopupViewHelper)
// 弹出
-(void) popupWithtype:(PopupViewBGType)aType
   touchOutsideHidden:(BOOL)hidden
         succeedBlock:(void(^)(UIView *aView))succeedBlock
         dismissBlock:(void(^)(UIView *aView))dismissBlock;

-(void) popupWithtype:(PopupViewBGType)aType
         succeedBlock:(void(^)(UIView *aView))succeedBlock
         dismissBlock:(void(^)(UIView *aView))dismissBlock;

-(void) dismissPopup;
@end