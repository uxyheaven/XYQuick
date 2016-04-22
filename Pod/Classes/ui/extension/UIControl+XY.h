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
//  This file Copy from BlockUI.

#import "XYQuick_Predefine.h"
#pragma mark -

/*
 typedef NS_OPTIONS(NSUInteger, UIControlEvents) {
 UIControlEventTouchDown           = 1 <<  0,      // on all touch downs
 UIControlEventTouchDownRepeat     = 1 <<  1,      // on multiple touchdowns (tap count > 1)
 UIControlEventTouchDragInside     = 1 <<  2,
 UIControlEventTouchDragOutside    = 1 <<  3,
 UIControlEventTouchDragEnter      = 1 <<  4,
 UIControlEventTouchDragExit       = 1 <<  5,
 UIControlEventTouchUpInside       = 1 <<  6,
 UIControlEventTouchUpOutside      = 1 <<  7,
 UIControlEventTouchCancel         = 1 <<  8,
 
 UIControlEventValueChanged        = 1 << 12,     // sliders, etc.
 
 UIControlEventEditingDidBegin     = 1 << 16,     // UITextField
 UIControlEventEditingChanged      = 1 << 17,
 UIControlEventEditingDidEnd       = 1 << 18,
 UIControlEventEditingDidEndOnExit = 1 << 19,     // 'return key' ending editing
 
 UIControlEventAllTouchEvents      = 0x00000FFF,  // for touch events
 UIControlEventAllEditingEvents    = 0x000F0000,  // for UITextField
 UIControlEventApplicationReserved = 0x0F000000,  // range available for application use
 UIControlEventSystemReserved      = 0xF0000000,  // range reserved for internal framework use
 UIControlEventAllEvents           = 0xFFFFFFFF
 };
 */

@interface UIControl (XYExtension)

- (void)uxy_handleControlEvent:(UIControlEvents)event withBlock:(void(^)(id sender))block;
- (void)uxy_removeHandlerForEvent:(UIControlEvents)event;

@end
