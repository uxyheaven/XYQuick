//
//  BusinessVC.h
//  JoinShow
//
//  Created by Heaven on 13-10-31.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import <UIKit/UIKit.h>
#if (1 == __XYQuick_Framework__)
#import <XYQuick/XYQuickDevelop.h>
#else
#import "XYQuickDevelop.h"
#endif

@interface BusinessVC : XYBaseViewController

@property (nonatomic, strong) UIButton *btnLoad;
@property (nonatomic, strong) UIButton *btnStart;

- (IBAction)clickStart:(id)sender;

- (IBAction)clickLoad:(id)sender;

@end
