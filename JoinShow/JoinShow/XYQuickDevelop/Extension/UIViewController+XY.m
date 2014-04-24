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

-(void) pushVC:(NSString *)vcName{
    [self pushVC:vcName object:nil];
}
-(void) pushVC:(NSString *)vcName object:(id)object{
    Class class = NSClassFromString(vcName);
    NSAssert(class != nil, @"Class 必须存在");
    UIViewController *vc = nil;
    
    if ([class conformsToProtocol:@protocol(XYSwitchControllerProtocol)]) {
        vc = [[[NSClassFromString(vcName) alloc] initWithObject:object] autorelease];
    }else {
        vc = [[[NSClassFromString(vcName) alloc] init] autorelease];
        vc.parameters = object;
    }

    [self.navigationController pushViewController:vc animated:YES];
}

-(void) modalVC:(NSString *)vcName object:(id)object succeed:(UIViewController_block_void)block{
    [self modalVC:vcName withNavigationVC:nil object:object succeed:block];
}

-(void) modalVC:(NSString *)vcName withNavigationVC:(NSString *)nvcName object:(id)object succeed:(UIViewController_block_void)block{
    Class class = NSClassFromString(vcName);
    NSAssert(class != nil, @"Class 必须存在");
    
    UIViewController *vc = nil;
    
    if ([class conformsToProtocol:@protocol(XYSwitchControllerProtocol)]) {
        vc = [[[NSClassFromString(vcName) alloc] initWithObject:object] autorelease];
    }else {
        vc = [[[NSClassFromString(vcName) alloc] init] autorelease];
        vc.parameters = object;
    }
    
    UINavigationController *nvc = nil;
    if (nvcName) {
        nvc = [[[NSClassFromString(vcName) alloc] initWithRootViewController:vc] autorelease];
        [self presentViewController:nvc animated:YES completion:block];
        
        return;
    }
    
    [self presentViewController:vc animated:YES completion:block];
}

@end
