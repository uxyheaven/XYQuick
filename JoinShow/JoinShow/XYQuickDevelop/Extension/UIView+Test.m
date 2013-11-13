//
//  UIView+Test.m
//  JoinShow
//
//  Created by Heaven on 13-9-13.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import "UIView+Test.h"
#import "XYPrecompile.h"

DUMMY_CLASS(UIView_Test);

@implementation UIView (Test)

+ (void) load{
}

// 可以多次劫持
-(void) UIView_dealloc2{
    NSLogDD
    objc_removeAssociatedObjects(self);
    XY_swizzleInstanceMethod([self class], @selector(UIView_dealloc2), @selector(dealloc));
	[self dealloc];
}

-(void) test{
  //  NSLogDD
    XY_swizzleInstanceMethod([self class], @selector(dealloc), @selector(UIView_dealloc2));
}
@end
