//
//  XYControllerProtocol.h
//  JoinShow
//
//  Created by Heaven on 14-3-28.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "XYControllerProtocol.h"

@protocol XYControllerProtocol <NSObject>

@optional
// 选择子控制器
- (void)selectChildWithItem:(id)item;

@end