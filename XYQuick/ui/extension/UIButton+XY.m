//
//  UIButton+XY.m
//  JoinShow
//
//  Created by Heaven on 14-5-12.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import "UIButton+XY.h"

@implementation UIButton (XY)

- (NSIndexPath *)getTableViewCellIndexPath
{
    UIView *cell = self.superview;
    
    while (![cell isKindOfClass:[UITableViewCell class]])
    {
        cell = cell.superview;
    }
    
    UIView *tableView = self.superview;
    
    while (![tableView isKindOfClass:[UITableView class]])
    {
        tableView = tableView.superview;
    }
    
    
    NSIndexPath *indexPath = [(UITableView *)tableView indexPathForCell:(UITableViewCell *)cell];
    
    return indexPath;
}

- (NSIndexPath *)getTableViewCellIndexPathAtTableView:(UITableView *)tableView{
    CGPoint point = [self convertPoint:CGPointZero toView:tableView];
    NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:point];
    
    return indexPath;
}


@end
