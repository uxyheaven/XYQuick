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
    UILabelResizeType_constantHeight = 1,
    UILabelResizeType_constantWidth,
} UILabelResizeType;

// 调整UILabel尺寸
// UILabelResizeType_constantHeight 高度不变
- (void)uxy_resize:(UILabelResizeType)type;

// 返回估计的尺寸
- (CGSize)uxy_estimateUISizeByHeight:(CGFloat)height;
- (CGSize)uxy_estimateUISizeByWidth:(CGFloat)width;


@end
