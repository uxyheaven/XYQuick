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

typedef void(^XYPopupViewHelperNormalBlock)(UIView *);

@interface XYPopupViewHelper : NSObject

AS_SINGLETON(XYPopupViewHelper)

@property (nonatomic, strong) UIColor       *colorLump;
@property (nonatomic, assign) float         colorLumpAlpha;
@property (nonatomic, assign) int           blurLevel;

-(void) setShowAnimationBlock:(XYPopupViewHelperNormalBlock)aBlock;
-(void) setDismissAnimationBlock:(XYPopupViewHelperNormalBlock)aBlock;

-(void) popupView:(UIView* )aView
             type:(PopupViewBGType)aType
touchOutsideHidden:(BOOL)hidden
     succeedBlock:(XYPopupViewHelperNormalBlock)succeedBlock
     dismissBlock:(XYPopupViewHelperNormalBlock)dismissBlock;

-(void) popupView:(UIView* )aView
             type:(PopupViewBGType)aType
     succeedBlock:(XYPopupViewHelperNormalBlock)succeedBlock
     dismissBlock:(XYPopupViewHelperNormalBlock)dismissBlock;

-(void) dismissPopup;

@end

#pragma mark -UIView
@interface UIView (XYPopupViewHelper)
// 弹出
-(void) popupWithtype:(PopupViewBGType)aType
   touchOutsideHidden:(BOOL)hidden
         succeedBlock:(XYPopupViewHelperNormalBlock)succeedBlock
         dismissBlock:(XYPopupViewHelperNormalBlock)dismissBlock;

-(void) popupWithtype:(PopupViewBGType)aType
         succeedBlock:(XYPopupViewHelperNormalBlock)succeedBlock
         dismissBlock:(XYPopupViewHelperNormalBlock)dismissBlock;

-(void) dismissPopup;
@end