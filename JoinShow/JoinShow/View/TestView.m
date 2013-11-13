//
//  TestView.m
//  JoinShow
//
//  Created by Heaven on 13-7-31.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import "TestView.h"
#if (1 == __XYQuick_Framework__)
#import <XYQuick/XYQuickDevelop.h>
#else
#import "XYQuickDevelop.h"
#endif
@implementation TestView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
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

-(void)dealloc{
    NSLogDD
    [super dealloc];
}

@end
