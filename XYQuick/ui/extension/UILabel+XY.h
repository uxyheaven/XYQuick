//
//  UILabel+XY.h
//  JoinShow
//
//  Created by Heaven on 13-11-28.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (uxy)

typedef enum {
    UXYLabelResizeType_constantHeight = 1,
    UXYLabelResizeType_constantWidth,
} UXYLabelResizeType;

// 调整UILabel尺寸
// UXYLabelResizeType_constantHeight 高度不变
- (void)uxy_resize:(UXYLabelResizeType)type;

// 返回估计的尺寸
- (CGSize)uxy_estimateUISizeByHeight:(CGFloat)height;
- (CGSize)uxy_estimateUISizeByWidth:(CGFloat)width;


@end
