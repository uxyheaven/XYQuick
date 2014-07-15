//
//  UISignalVC.h
//  JoinShow
//
//  Created by Heaven on 14-5-20.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYQuickDevelop.h"

@interface Signal1 : UIView

AS_SIGNAL( BUTTON_CLICK1 )

@end


@interface Signal2 : UIView

AS_SIGNAL( BUTTON_CLICK2 )

@property (nonatomic, strong) UIButton *btn;

@end

@interface Signal2_child : Signal2

@end

@interface UISignalVC : UIViewController

@end
