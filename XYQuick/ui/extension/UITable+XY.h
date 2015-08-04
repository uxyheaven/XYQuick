//
//  UITableViewCell+XY.h
//  JoinShow
//
//  Created by Heaven on 14-1-2.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (XY)

// 子类需要重写此方法
+ (CGFloat)uxy_heightForRowWithData:(id)data;

- (void)uxy_layoutSubviewsWithDictionary:(NSMutableDictionary *)dictionary;

@end

@interface UITableView (XY)

- (void)uxy_reloadData:(BOOL)animated;

@end
