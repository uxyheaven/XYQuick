//
//  UINavigationBar+XY.h
//  JoinShow
//
//  Created by heaven on 15/4/9.
//  Copyright (c) 2015年 Heaven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (XY)


// NavigationBar 变色 透明 尺寸 等方法 copy from https://github.com/ltebean/LTNavigationBar
- (void)xy_setBackgroundColor:(UIColor *)backgroundColor;
- (void)xy_setContentAlpha:(CGFloat)alpha;
- (void)xy_setTranslationY:(CGFloat)translationY;
- (void)xy_reset;

@end
