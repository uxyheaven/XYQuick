//
//  UITableViewCell+XY.h
//  JoinShow
//
//  Created by Heaven on 14-1-2.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (XY)

//@property (nonatomic, assign) float                rowHeight;       // cell高度

// 子类需要重新此方法
+(CGFloat) heightForRowWithData:(id)aData;

@end
