//
//  __  __          ____           _          _
//  \ \/ / /\_/\   /___ \  _   _  (_)   ___  | | __
//   \  /  \_ _/  //  / / | | | | | |  / __| | |/ /
//   /  \   / \  / \_/ /  | |_| | | | | (__  |   <
//  /_/\_\  \_/  \___,_\   \__,_| |_|  \___| |_|\_\
//
//  Copyright (C) Heaven.
//
//	https://github.com/uxyheaven/XYQuick
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.
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
#import "XYReachability.h"              // 网络可达性检测
#import "XYBaseBuilder.h"               // 通用建造者
#import "XYProtocolExtension.h"         // 协议扩展

#import "XYCommonDefine.h"
#import "XYCommon.h"                    // 待分解

#import "XYQuick_Cache.h"               // 缓存模块
#import "XYQuick_Debug.h"               // 调试模块

// Extensions
#import "NSObject+XY.h"
#import "NSArray+XY.h"
#import "NSDictionary+XY.h"
#import "NSString+XY.h"
#import "NSData+XY.h"
#import "NSDate+XY.h"
#import "NSNumber+XY.h"
#import "NSSet+XY.h"
#import "NSNull+XY.h"

