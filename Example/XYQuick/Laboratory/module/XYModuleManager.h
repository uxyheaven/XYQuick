//
//  XYModuleManager.h
//  XYQuick
//
//  Created by heaven on 2016/12/20.
//  Copyright © 2016年 xingyao095. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYModuleManager : NSObject

+ (instancetype)sharedInstance;

- (void)hookAppDelegate:(id <UIApplicationDelegate>)appDelegate;

- (void)addAModule:(id)module;

@end
