//
//  UITableViewCell+XY.m
//  JoinShow
//
//  Created by Heaven on 14-1-2.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import "UITable+XY.h"
#import "XYPrecompile.h"

@implementation UITableViewCell (XY)

+ (CGFloat)heightForRowWithData:(id)aData
{
    if (aData == nil)
    {
        return -1;
    }
    
    
    return 44;
}

- (void)layoutSubviewsWithDic:(NSMutableDictionary *)dic
{
    
}

@end


@implementation UITableView (XY)

- (void)reloadData:(BOOL)animated
{
    [self reloadData];
    
    if (animated)
    {
        CATransition *animation = [CATransition animation];
        [animation setType:kCATransitionReveal];
        [animation setSubtype:kCATransitionFromBottom];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [animation setFillMode:kCAFillModeBoth];
        [animation setDuration:.3];
        [[self layer] addAnimation:animation forKey:@"UITableViewReloadDataAnimationKey"];
    }
}

@end