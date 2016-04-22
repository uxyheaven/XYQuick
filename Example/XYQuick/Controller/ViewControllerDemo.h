//
//  ViewControllerDemo.h
//  JoinShow
//
//  Created by heaven on 15/7/7.
//  Copyright (c) 2015年 Heaven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYQuick_Predefine.h"

@protocol ViewControllerDemo <NSObject>
+ (NSString *)title;
@end


#define ViewControllerDemoTitle( __title )  \
        + (NSString *)title { return uxy_macro_string( __title ); }
