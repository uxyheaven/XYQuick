//
//  AutoSizeView.m
//  JC139house
//
//  Created by Jam on 13-3-11.
//  Copyright (c) 2013年 Jam. All rights reserved.
//

#import "AutoSizeView.h"

@implementation AutoSizeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview.bounds.size.width == 0.0 || newSuperview.bounds.size.height == 0.0)
        return;
    
    [self setFrame:newSuperview.bounds];
}

@end
