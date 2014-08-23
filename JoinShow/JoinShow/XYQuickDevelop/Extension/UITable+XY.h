//
//  UITableViewCell+XY.h
//  JoinShow
//
//  Created by Heaven on 14-1-2.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (XY)

// 子类需要重新此方法
+ (CGFloat)heightForRowWithData:(id)aData;

- (void)layoutSubviewsWithDic:(NSMutableDictionary *)dic;

@end

@interface UITableView (XY)

- (void)reloadData:(BOOL)animated;

@end
