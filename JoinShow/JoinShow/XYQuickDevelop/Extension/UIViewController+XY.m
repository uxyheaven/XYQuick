//
//  UIViewController+XY.m
//  JoinShow
//
//  Created by Heaven on 14-4-24.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import "UIViewController+XY.h"



@implementation UIViewController (XY)

-(void) pushVC:(NSString *)vcName succeed:(UIViewController_block_self)block{
    UIViewController *vc = [[[NSClassFromString(vcName) alloc] init] autorelease];
    if (vc) {
        if (block) {
            block(self);
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void) modalVC:(NSString *)vcName succeed:(UIViewController_block_self)block{
    UIViewController *vc = [[[NSClassFromString(vcName) alloc] init] autorelease];
    if (vc) {
        [self presentViewController:vc animated:YES completion:^{
            if (block) {
                block(self);
            }
        }];
    }
}
@end
