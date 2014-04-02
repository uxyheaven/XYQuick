//
//  DemoViewController.h
//  JoinShow
//
//  Created by Heaven on 14-4-2.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DemoViewController_sel_methodBlock @selector(funny:)
#define DemoViewController_sel_methodBlock2 @selector(funny2:)

typedef void(^DemoDemoViewControllerExecuteBlock)(UIViewController *vc);
typedef void(^DemoDemoViewControllerFunBlock)(UIViewController *vc, id sender);

@interface DemoViewController : UIViewController

@property (nonatomic, copy) DemoDemoViewControllerExecuteBlock loadViewBlock;
@property (nonatomic, copy) DemoDemoViewControllerExecuteBlock viewDidLoadBlock;

@property (nonatomic, copy) DemoDemoViewControllerFunBlock methodBlock;
@property (nonatomic, copy) DemoDemoViewControllerFunBlock methodBlock2;

@end
