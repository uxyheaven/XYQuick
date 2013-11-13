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
    filePathOption_blur,
} PopupViewBGType;

@interface XYPopupViewManager : NSObject

XY_SINGLETON(XYPopupViewManager)

@property (nonatomic, retain) UIColor       *colorLump;
@property (nonatomic, assign) float         colorLumpAlpha;
@property (nonatomic, assign) int           blurLevel;

-(void) setShowAnimationBlock:(void(^)(UIView *aView))aBlock;
-(void) setDismissAnimationBlock:(void(^)(UIView *aView))aBlock;

-(void) popupView:(UIView* )aView
             type:(PopupViewBGType)aType
     dismissBlock:(void(^)(UIView *aView))dismissBlock;

-(void) dismissPopup;

@end
