//
//  UISignalVC.h
//  JoinShow
//
//  Created by Heaven on 14-5-20.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYQuick.h"

@interface Signal1 : UIView

AS_SIGNAL( click1 )

@end


@interface Signal2 : UIView

AS_SIGNAL( click2 )

@property (nonatomic, strong) UIButton *btn;

@end

@interface Signal2_child : Signal2

@end

@interface UISignalVC : UIViewController

AS_SIGNAL( click3 )

@end
