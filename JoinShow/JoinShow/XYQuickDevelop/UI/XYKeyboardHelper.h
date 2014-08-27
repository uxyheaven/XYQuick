//
//  XYKeyboardHelper.h
// 
//  Copy from IQKeyboardHelper
//
//  Created by Heaven on 13-10-29.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//
//////////////////////////////////////////////////////////
// Copyright (c) 2013 Iftekhar Qurashi.
// Change by Heaven
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "XYPrecompile.h"
#import "XYFoundation.h"

#define XYKeyboardHelper_DefaultDistance 10.0


@interface XYKeyboardHelper : NSObject

AS_SINGLETON(XYKeyboardHelper)

@property(nonatomic, assign) CGFloat keyboardDistanceFromTextField; // can't be less than zero. Default is 10.0
@property(nonatomic, assign) BOOL isEnabled;

//Enable keyboard Helper.
- (void)enableKeyboardHelper;    /*default enabled*/

//Desable keyboard Helper.
- (void)disableKeyboardHelper;

@end


/*****************UITextField***********************/
@interface UITextField (ToolbarOnKeyboard)

//Helper functions to add Done button on keyboard.
- (void)addDoneOnKeyboardWithTarget:(id)target action:(SEL)action;

//Helper function to add SegmentedNextPrevious and Done button on keyboard.
- (void)addPreviousNextDoneOnKeyboardWithTarget:(id)target previousAction:(SEL)previousAction nextAction:(SEL)nextAction doneAction:(SEL)doneAction;

//Helper methods to enable and desable previous next buttons.
- (void)setEnablePrevious:(BOOL)isPreviousEnabled next:(BOOL)isNextEnabled;

@end

/*****************UITextView***********************/
@interface UITextView (ToolbarOnKeyboard)

//Helper functions to add Done button on keyboard.
- (void)addDoneOnKeyboardWithTarget:(id)target action:(SEL)action;

//Helper function to add SegmentedNextPrevious and Done button on keyboard.
- (void)addPreviousNextDoneOnKeyboardWithTarget:(id)target previousAction:(SEL)previousAction nextAction:(SEL)nextAction doneAction:(SEL)doneAction;

//Helper methods to enable and desable previous next buttons.
- (void)setEnablePrevious:(BOOL)isPreviousEnabled next:(BOOL)isNextEnabled;

@end


/*****************XYSegmentedNextPrevious***********************/
@interface XYSegmentedNextPrevious : UISegmentedControl
{
    __weak id buttonTarget;
    SEL previousSelector;
    SEL nextSelector;
}

- (id)initWithTarget:(id)target previousSelector:(SEL)pSelector nextSelector:(SEL)nSelector;

@end

