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

#import "UIAlertView+XY.h"

@implementation UIAlertView (XYExtension)

uxy_staticConstString(UIAlertView_key_clicked)
uxy_staticConstString(UIAlertView_key_cancel)
uxy_staticConstString(UIAlertView_key_willPresent)
uxy_staticConstString(UIAlertView_key_didPresent)
uxy_staticConstString(UIAlertView_key_willDismiss)
uxy_staticConstString(UIAlertView_key_didDismiss)
uxy_staticConstString(UIAlertView_key_shouldEnableFirstOtherButton)

- (void)uxy_handlerClickedButton:(UIAlertView_block_self_index)aBlock
{
    self.delegate = self;
    objc_setAssociatedObject(self, UIAlertView_key_clicked, aBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void)uxy_handlerCancel:(void (^)(UIAlertView *alertView))aBlock
{
    self.delegate = self;
    objc_setAssociatedObject(self, UIAlertView_key_cancel, aBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void)uxy_handlerWillPresent:(void (^)(UIAlertView *alertView))aBlock
{
    self.delegate = self;
    objc_setAssociatedObject(self, UIAlertView_key_willPresent, aBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)uxy_handlerDidPresent:(void (^)(UIAlertView *alertView))aBlock
{
    self.delegate = self;
    objc_setAssociatedObject(self, UIAlertView_key_didPresent, aBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void)uxy_handlerWillDismiss:(UIAlertView_block_self_index)aBlock
{
    self.delegate = self;
    objc_setAssociatedObject(self, UIAlertView_key_willDismiss, aBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void)uxy_handlerDidDismiss:(UIAlertView_block_self_index)aBlock
{
    self.delegate = self;
    objc_setAssociatedObject(self, UIAlertView_key_didDismiss, aBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void)uxy_handlerShouldEnableFirstOtherButton:(UIAlertView_block_shouldEnableFirstOtherButton)aBlock
{
    self.delegate = self;
    objc_setAssociatedObject(self, UIAlertView_key_shouldEnableFirstOtherButton, aBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIAlertView_block_self_index block = objc_getAssociatedObject(self, UIAlertView_key_clicked);
    
    block ? block(alertView, buttonIndex) : nil;
}

- (void)alertViewCancel:(UIAlertView *)alertView
{
    UIAlertView_block_self block = objc_getAssociatedObject(self, UIAlertView_key_cancel);
    
    block ? block(alertView) : nil;
}

- (void)willPresentAlertView:(UIAlertView *)alertView
{
    UIAlertView_block_self block = objc_getAssociatedObject(self, UIAlertView_key_willPresent);

    block ? block(alertView) : nil;
}

- (void)didPresentAlertView:(UIAlertView *)alertView
{
    UIAlertView_block_self block = objc_getAssociatedObject(self, UIAlertView_key_didPresent);
    
    block ? block(alertView) : nil;
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    UIAlertView_block_self_index block = objc_getAssociatedObject(self, UIAlertView_key_willDismiss);
    
    block ? block(alertView, buttonIndex) : nil;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    UIAlertView_block_self_index block = objc_getAssociatedObject(self, UIAlertView_key_didDismiss);
    
    block ? block(alertView, buttonIndex) : nil;
}

- (void)uxy_showWithDuration:(NSTimeInterval)duration
{
    [NSTimer scheduledTimerWithTimeInterval:duration
                                     target:self
                                   selector:@selector(__uxy_dismiss)
                                   userInfo:self
                                    repeats:NO];
    [self show];
}

- (void)__uxy_dismiss
{
    [self dismissWithClickedButtonIndex:0 animated:YES];
}

@end
