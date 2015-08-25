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

#import <UIKit/UIKit.h>
#import "XYQuick_Predefine.h"

typedef UIViewController *  (^XYViewControllerManager_createVC_block) (void);

@interface XYViewControllerManager : UIViewController uxy_as_singleton

@property (nonatomic, strong, readonly) NSMutableDictionary *viewControllers;
@property (nonatomic, weak) UIViewController *selectedViewController;
@property (nonatomic, copy) NSString *selectedKey;
@property (nonatomic, copy) NSString *firstKey;

//@property (nonatomic, strong, readonly) NSMutableDictionary *viewControllerSetupBlocks;     // 创建viewControllers的block

@property (nonatomic, strong, readonly) UIView *contentView; // 子视图控制器显示的view


- (void)addAViewController:(XYViewControllerManager_createVC_block)block key:(NSString *)key;

- (void)clean;

@end


#pragma mark - category
@interface UIViewController (XYViewControllerManager)

@property (nonatomic, weak, readonly) XYViewControllerManager *uxy_viewControllerManager;

@end
