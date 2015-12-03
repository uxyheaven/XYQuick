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

@interface XYAlertViewHandler : NSObject
@end

@interface UIAlertView (__XYExtension)
@property (nonatomic, strong) XYAlertViewHandler *uxy_handler;
@end

@implementation UIAlertView (XYExtension)

uxy_staticConstString(XYAlertView_key_clicked)
uxy_staticConstString(XYAlertView_key_cancel)
uxy_staticConstString(XYAlertView_key_willPresent)
uxy_staticConstString(XYAlertView_key_didPresent)
uxy_staticConstString(XYAlertView_key_willDismiss)
uxy_staticConstString(XYAlertView_key_didDismiss)
uxy_staticConstString(XYAlertView_key_shouldEnableFirstOtherButton)
uxy_staticConstString(XYAlertView_key_handler)

- (void)uxy_handlerClickedButton:(XYAlertView_block_self_index)aBlock
{
    self.delegate = self.uxy_handler;
    objc_setAssociatedObject(self, XYAlertView_key_clicked, aBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void)uxy_handlerCancel:(void (^)(UIAlertView *alertView))aBlock
{
    self.delegate = self.uxy_handler;
    objc_setAssociatedObject(self, XYAlertView_key_cancel, aBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void)uxy_handlerWillPresent:(void (^)(UIAlertView *alertView))aBlock
{
    self.delegate = self.uxy_handler;
    objc_setAssociatedObject(self, XYAlertView_key_willPresent, aBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)uxy_handlerDidPresent:(void (^)(UIAlertView *alertView))aBlock
{
    self.delegate = self.uxy_handler;
    objc_setAssociatedObject(self, XYAlertView_key_didPresent, aBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void)uxy_handlerWillDismiss:(XYAlertView_block_self_index)aBlock
{
    self.delegate = self.uxy_handler;
    objc_setAssociatedObject(self, XYAlertView_key_willDismiss, aBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void)uxy_handlerDidDismiss:(XYAlertView_block_self_index)aBlock
{
    self.delegate = self.uxy_handler;
    objc_setAssociatedObject(self, XYAlertView_key_didDismiss, aBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void)uxy_handlerShouldEnableFirstOtherButton:(XYAlertView_block_shouldEnableFirstOtherButton)aBlock
{
    self.delegate = self.uxy_handler;
    objc_setAssociatedObject(self, XYAlertView_key_shouldEnableFirstOtherButton, aBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
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

#pragma mark -
-(void)__uxy_dismiss
{
    [self dismissWithClickedButtonIndex:0 animated:YES];
}

- (XYAlertViewHandler *)uxy_handler
{
    XYAlertViewHandler *handler = objc_getAssociatedObject(self, XYAlertView_key_handler);
    if (!handler)
    {
        handler = [[XYAlertViewHandler alloc] init];
        objc_setAssociatedObject(self, XYAlertView_key_handler, handler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return handler;
}
@end




@implementation XYAlertViewHandler

#pragma mark - XYAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    XYAlertView_block_self_index block = objc_getAssociatedObject(alertView, XYAlertView_key_clicked);
    
    block ? block(alertView, buttonIndex) : nil;
}

- (void)alertViewCancel:(UIAlertView *)alertView
{
    XYAlertView_block_self block = objc_getAssociatedObject(alertView, XYAlertView_key_cancel);
    
    block ? block(alertView) : nil;
}

- (void)willPresentAlertView:(UIAlertView *)alertView
{
    XYAlertView_block_self block = objc_getAssociatedObject(alertView, XYAlertView_key_willPresent);
    
    block ? block(alertView) : nil;
}

- (void)didPresentAlertView:(UIAlertView *)alertView
{
    XYAlertView_block_self block = objc_getAssociatedObject(alertView, XYAlertView_key_didPresent);
    
    block ? block(alertView) : nil;
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    XYAlertView_block_self_index block = objc_getAssociatedObject(alertView, XYAlertView_key_willDismiss);
    
    block ? block(alertView, buttonIndex) : nil;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    XYAlertView_block_self_index block = objc_getAssociatedObject(alertView, XYAlertView_key_didDismiss);
    
    block ? block(alertView, buttonIndex) : nil;
}

@end
