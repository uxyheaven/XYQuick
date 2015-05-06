//
//  UIButton+XY.h
//  JoinShow
//
//  Created by Heaven on 14-5-12.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (XY)

- (NSIndexPath *)getTableViewCellIndexPath;

- (NSIndexPath *)getTableViewCellIndexPathAtTableView:(UITableView *)tableView;

@end
