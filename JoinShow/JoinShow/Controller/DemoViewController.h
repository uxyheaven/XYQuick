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

typedef void(^DemoViewControllerExecuteBlock)(UIViewController *vc);
typedef void(^DemoViewControllerFunBlock)(UIViewController *vc, id sender);

@interface DemoViewController : UIViewController

@property (nonatomic,  strong) DemoViewControllerExecuteBlock loadViewBlock;
@property (nonatomic,  strong) DemoViewControllerExecuteBlock viewDidLoadBlock;

@property (nonatomic,  strong) DemoViewControllerFunBlock methodBlock;
@property (nonatomic,  strong) DemoViewControllerFunBlock methodBlock2;

@end
