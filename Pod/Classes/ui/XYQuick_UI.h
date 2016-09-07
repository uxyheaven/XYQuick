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
#import "XYUIDefine.h"                  // 一些ui相关宏定义
#import "XYAnimate.h"                   // 普通动画
#import "XYKeyboardHelper.h"            // Keyboard偏移通用解决方案
#import "XYTabBarController.h"          // TabBarController
#import "XYBaseViewController.h"        // UIViewController 生命周期扩展
#import "XYViewLayout.h"                // UIView 布局
#import "XYViewControllerManager.h"     // XYViewControllerManager

// Extensions
#import "UIColor+XY.h"
#import "UIControl+XY.h"
#import "UIView+XY.h"
#import "UIImage+XY.h"
#import "UIAlertView+XY.h"
#import "UIActionSheet+XY.h"
#import "UILabel+XY.h"
#import "UITable+XY.h"
#import "UIWebView+XY.h"
#import "UIButton+XY.h"
#import "UINavigationBar+XY.h"
#import "UIViewController+XY.h"
#import "UIWindow+XY.h"

// Protocol
#import "XYHUDProtocol.h"           // HUD协议


/**************************************************************/
static __inline__ CGRect CGRectFromCGSize( CGSize size ) {
    return CGRectMake( 0, 0, size.width, size.height );
};

static __inline__ CGRect CGRectMakeWithCenterAndSize( CGPoint center, CGSize size ) {
    return CGRectMake( center.x - size.width * 0.5, center.y - size.height * 0.5, size.width, size.height );
};

static __inline__ CGRect CGRectMakeWithOriginAndSize( CGPoint origin, CGSize size ) {
    return CGRectMake( origin.x, origin.y, size.width, size.height );
};

static __inline__ CGPoint CGRectCenter( CGRect rect ) {
    return CGPointMake( CGRectGetMidX( rect ), CGRectGetMidY( rect ) );
};
