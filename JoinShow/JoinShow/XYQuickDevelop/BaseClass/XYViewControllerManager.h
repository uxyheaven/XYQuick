//
//  XYViewControllerManager.h
//  ChildKing
//
//  Created by Heaven on 14-5-1.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYBaseViewController.h"

typedef UIViewController *(^XYViewControllerManager_createVC_block)(void);

@interface XYViewControllerManager : XYBaseViewController

AS_SINGLETON(XYViewControllerManager)

@property (nonatomic, strong, readonly) NSMutableDictionary *viewControllers;
@property (nonatomic, weak) UIViewController *selectedViewController;
@property (nonatomic, copy) NSString *selectedKey;
@property (nonatomic, copy) NSString *firstKey;

//@property (nonatomic, strong, readonly) NSMutableDictionary *viewControllerSetupBlocks;     // 创建viewControllers的block

@property (nonatomic, strong, readonly) UIView *contentView; // 子视图控制器显示的view


- (void)addAViewController:(XYViewControllerManager_createVC_block)block key:(NSString *)key;

- (void)clean;

@end


#pragma mark - category
@interface UIViewController (XYViewControllerManager)

@property (nonatomic, weak, readonly) XYViewControllerManager *viewControllerManager;

@end
