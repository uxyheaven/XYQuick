//
//  UISignalVC.h
//  JoinShow
//
//  Created by Heaven on 14-5-20.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYQuick.h"
#import "XYSignal.h"

uxy_as_signal( signal_name1 )      // 信号1

@interface Signal1 : UIView
@end

@interface Signal2 : UIView
@property (nonatomic, strong) UIButton *btn;
@end

@interface Signal2_child : Signal2
@end

@interface SignalVC : UIViewController<ViewControllerDemo>
@end
