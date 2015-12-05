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

#import "XYQuick_Predefine.h"
#pragma mark -

typedef void(^XYAlertView_block_self_index)(UIAlertView *alertView, NSInteger btnIndex);
typedef void(^XYAlertView_block_self)(UIAlertView *alertView);
typedef BOOL(^XYAlertView_block_shouldEnableFirstOtherButton)(UIAlertView *alertView);

@interface UIAlertView (XYExtension)

- (void)uxy_handlerClickedButton:(XYAlertView_block_self_index)aBlock;
- (void)uxy_handlerCancel:(XYAlertView_block_self)aBlock;
- (void)uxy_handlerWillPresent:(XYAlertView_block_self)aBlock;
- (void)uxy_handlerDidPresent:(XYAlertView_block_self)aBlock;
- (void)uxy_handlerWillDismiss:(XYAlertView_block_self_index)aBlock;
- (void)uxy_handlerDidDismiss:(XYAlertView_block_self_index)aBlock;
- (void)uxy_handlerShouldEnableFirstOtherButton:(XYAlertView_block_shouldEnableFirstOtherButton)aBlock;

// 延时消失
- (void)uxy_showWithDuration:(NSTimeInterval)duration;

@end
