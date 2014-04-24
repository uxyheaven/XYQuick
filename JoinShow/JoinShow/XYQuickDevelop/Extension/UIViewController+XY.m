//
//  UIViewController+XY.m
//  JoinShow
//
//  Created by Heaven on 14-4-24.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import "UIViewController+XY.h"
#import <objc/runtime.h>

#undef	UIViewController_key_parameters
#define UIViewController_key_parameters	"UIViewController.parameters"

@implementation UIViewController (XY)

@dynamic parameters;

-(id) parameters{
    id object = objc_getAssociatedObject(self, UIViewController_key_parameters);
    
    return object;
}

-(void) setTempObject:(id)anObject{
    objc_setAssociatedObject(self, UIViewController_key_parameters, anObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void) pushVC:(NSString *)vcName parameters:(id)parameters{
    UIViewController *vc = [[[NSClassFromString(vcName) alloc] init] autorelease];
    if (vc) {
        vc.parameters = parameters;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void) modalVC:(NSString *)vcName parameters:(id)parameters succeed:(UIViewController_block_void)block{
    UIViewController *vc = [[[NSClassFromString(vcName) alloc] init] autorelease];
    vc.parameters = parameters;
    if (vc) {
            [self presentViewController:vc animated:YES completion:block];
    }
}
@end
