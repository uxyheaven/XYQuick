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
//  This file Copy from bee Framework.

#import <Foundation/Foundation.h>


#pragma mark -
/*
 * 说明 仅在debug下才显示nslog
 */
#if (1 == __XY_DEBUG__)
    #undef	NSLogD
    #undef	NSLogDD
    #define NSLogD(fmt, ...) {NSLog((@"%s [Line %d] DEBUG: \n" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
    #define NSLogDD NSLogD(@"%@", @"");
    #define NSLogDSelf NSLogD(@"Class: %@", NSStringFromClass([self class]));
#else
    #define NSLogD(format, ...)
    #define NSLogDD
    #define NSLogDSelf
    #define NSLog(...) {}
#endif

#pragma mark -
// Modules
#import "XYPerformance.h"                   // 性能分析
#import "XYDebugToy.h"                      // 一些debug用的小工具

// Extensions

#pragma mark -
