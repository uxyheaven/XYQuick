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

-(void) setParameters:(id)anObject{
    [self willChangeValueForKey:@"parameters"];
    objc_setAssociatedObject(self, UIViewController_key_parameters, anObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"parameters"];
}

-(void) pushVC:(NSString *)vcName{
    [self pushVC:vcName object:nil];
}
-(void) pushVC:(NSString *)vcName object:(id)object{
    Class class = NSClassFromString(vcName);
    NSAssert(class != nil, @"Class 必须存在");
    UIViewController *vc = nil;
    
    if ([class conformsToProtocol:@protocol(XYSwitchControllerProtocol)]) {
        vc = [[NSClassFromString(vcName) alloc] initWithObject:object];
    }else {
        vc = [[NSClassFromString(vcName) alloc] init];
        vc.parameters = object;
    }

    [self.navigationController pushViewController:vc animated:YES];
}

-(void) popVC{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) modalVC:(NSString *)vcName withNavigationVC:(NSString *)navName{
    [self modalVC:vcName withNavigationVC:navName object:nil succeed:nil];
}

-(void) modalVC:(NSString *)vcName withNavigationVC:(NSString *)nvcName object:(id)object succeed:(UIViewController_block_void)block{
    Class class = NSClassFromString(vcName);
    NSAssert(class != nil, @"Class 必须存在");
    
    UIViewController *vc = nil;
    
    if ([class conformsToProtocol:@protocol(XYSwitchControllerProtocol)]) {
        vc = [[NSClassFromString(vcName) alloc] initWithObject:object];
    }else {
        vc = [[NSClassFromString(vcName) alloc] init];
        vc.parameters = object;
    }
    
    UINavigationController *nvc = nil;
    if (nvcName) {
        nvc = [[NSClassFromString(nvcName) alloc] initWithRootViewController:vc];
        [self presentViewController:nvc animated:YES completion:block];
        
        return;
    }
    
    [self presentViewController:vc animated:YES completion:block];
}

-(void) dismissModalVC{
    [self dismissModalVCWithSucceed:nil];
}
-(void) dismissModalVCWithSucceed:(UIViewController_block_void)block{
    [self dismissViewControllerAnimated:YES completion:block];
}
@end
