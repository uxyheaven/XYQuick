//
//  Test2View.m
//  JoinShow
//
//  Created by Heaven on 13-7-31.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import "Test2View.h"
#if (1 == __XYQuick_Framework__)
#import <XYQuick/XYQuickDevelop.h>
#else
#import "XYQuickDevelop.h"
#endif

@implementation Test2View

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self test];
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
    NSLogD(@"%s, %@", __FUNCTION__, [super class]);
}
@end
