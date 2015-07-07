//
//  UISignalVC.h
//  JoinShow
//
//  Created by Heaven on 14-5-20.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XYUISignal.h"

@interface UISignal1 : UIView

AS_SIGNAL( click1 )

@end


@interface UISignal2 : UIView

AS_SIGNAL( click2 )

@property (nonatomic, strong) UIButton *btn;

@end

@interface UISignal2_child : UISignal2

@end

@interface UISignalVC : UIViewController<ViewControllerDemo>

AS_SIGNAL( click3 )

@end
