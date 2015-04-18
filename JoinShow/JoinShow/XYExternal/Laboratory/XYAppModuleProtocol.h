//
//  XYAppModuleProtocol.h
//  JoinShow
//
//  Created by heaven on 14/12/19.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYMenuItem.h"

@protocol XYAppModuleProtocol <NSObject>

@property (nonatomic, strong) id<XYMenuItem> activeMenuItem;
@property (nonatomic, strong, readonly) UIViewController *rootViewController;

@end
