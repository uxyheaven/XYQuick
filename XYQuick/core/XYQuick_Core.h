//
//  XYQuick_Core.h
//  JoinShow
//
//  Created by heaven on 15/5/6.
//  Copyright (c) 2015年 Heaven. All rights reserved.
//

#import <Foundation/Foundation.h>

// Modules
#import "XYThread.h"                    // GCD
#import "XYTimer.h"                     // 定时器
#import "XYSystemInfo.h"                // 系统信息
#import "XYSandbox.h"                   // 沙箱
#import "XYJsonHelper.h"                // json to object , object to json
#import "XYAOP.h"                       // aop
#import "XYRuntime.h"                   // runtime
#import "XYBlackMagic.h"                // 黑魔法
#import "XYReachability.h"              // 网络可达性
#import "XYBaseBuilder.h"               // 通用建造者
#import "XYUnitTest.h"                  // 单元测试

#import "XYCommonDefine.h"
#import "XYCommon.h"                    // 待分解

#import "XYCache.h"                     // 缓存
#import "XYQuick_Debug.h"               // 测试

#import "XYChainMethod.h"               // 链式方法调用

// Extensions
#import "NSObject+XY.h"
#import "NSArray+XY.h"
#import "NSDictionary+XY.h"
#import "NSString+XY.h"
#import "NSData+XY.h"
#import "NSDate+XY.h"




@interface XYQuick_Core : NSObject

@end
