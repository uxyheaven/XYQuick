//
//  DemoViewController.h
//  JoinShow
//
//  Created by Heaven on 14-4-2.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DemoDemoViewControllerExecuteBlock)(UIViewController *vc);

@interface DemoViewController : UIViewController

@property (nonatomic, copy) DemoDemoViewControllerExecuteBlock loadViewBlock;
@property (nonatomic, copy) DemoDemoViewControllerExecuteBlock viewDidLoadBlock;

-(void) addSel:(SEL)sel;

@end
