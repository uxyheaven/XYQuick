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
#import "XYQuick_Predefine.h"

#define uxy_handleSignal( __signal, __name ) \
        - (void)__uxy_handleSignal_n_##__name:(XYSignal *)__signal


#pragma mark -
// 声明 定义
#define uxy_as_def_signal( __name )    \
        static NSString *const __name = uxy_macro_string(__name);

#pragma mark -

#pragma mark - XYSignalTarget
@protocol XYSignalTarget
@property (nonatomic, weak) id uxy_nextSignalHandler;
@property (nonatomic, weak, readonly) id uxy_defaultNextSignalHandler;
@end

#pragma mark - Request && Response
@interface XYSignal : NSObject

// Request
@property (nonatomic, assign) BOOL isDead;  // 是否结束
@property (nonatomic, assign) BOOL isReach;      // 是否触达最后的Handler

@property (nonatomic, weak) id<XYSignalTarget> sender;          // 发送者

@property (nonatomic, assign) NSInteger jump;       // 跳转次数
@property (nonatomic, copy) NSString *name;     // 名字
@property (nonatomic, strong) id userInfo;        // 请求的参数

// Response
@property (nonatomic, strong) id response;       // 返回值

@end


#pragma mark- UXYSignalHandler

@interface NSObject (UXYSignalHandler)

- (XYSignal *)uxy_sendSignalWithName:(NSString *)name userInfo:(id)userInfo;
- (XYSignal *)uxy_sendSignalWithName:(NSString *)name userInfo:(id)userInfo sender:(id)sender;

@end

@interface UIView (UXYSignalHandler)<XYSignalTarget>
@end

@interface UIViewController (UXYSignalHandler)<XYSignalTarget>
@end

#pragma mark - XYSignalBus
// 暂时无用
/*
@interface XYSignalBus : NSObject
+ (instancetype)defaultBus;
@end
 */



