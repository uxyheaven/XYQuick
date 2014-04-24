//
//  UIViewController+XY.h
//  JoinShow
//
//  Created by Heaven on 14-4-24.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UIViewController_block_self) (UIViewController *);

@interface UIViewController (XY)

-(void) pushVC:(NSString *)vcName succeed:(UIViewController_block_self)block;

-(void) modalVC:(NSString *)vcName succeed:(UIViewController_block_self)block;

@end
