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

#import "UIActionSheet+XY.h"
#import <objc/runtime.h>

@implementation UIActionSheet (XYExtension)

uxy_staticConstString(XYActionSheet_key_clicked)
uxy_staticConstString(XYActionSheet_key_cancel)
uxy_staticConstString(XYActionSheet_key_willPresent)
uxy_staticConstString(XYActionSheet_key_didPresent)
uxy_staticConstString(XYActionSheet_key_willDismiss)
uxy_staticConstString(XYActionSheet_key_didDismiss)

- (void)uxy_handlerClickedButton:(XYActionSheet_block_self_index)aBlock
{
    self.delegate = self;
    objc_setAssociatedObject(self, XYActionSheet_key_clicked, aBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void)uxy_handlerCancel:(XYActionSheet_block_self)aBlock
{
    self.delegate = self;
    objc_setAssociatedObject(self, XYActionSheet_key_cancel, aBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void)uxy_handlerWillPresent:(XYActionSheet_block_self)aBlock
{
    self.delegate = self;
    objc_setAssociatedObject(self, XYActionSheet_key_willPresent, aBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void)uxy_handlerDidPresent:(XYActionSheet_block_self)aBlock
{
    self.delegate = self;
    objc_setAssociatedObject(self, XYActionSheet_key_didPresent, aBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void)uxy_handlerWillDismiss:(XYActionSheet_block_self)aBlock
{
    self.delegate = self;
    objc_setAssociatedObject(self, XYActionSheet_key_willDismiss, aBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void)uxy_handlerDidDismiss:(XYActionSheet_block_self_index)aBlock
{
    self.delegate = self;
    objc_setAssociatedObject(self, XYActionSheet_key_didDismiss, aBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
#pragma mark - XYActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    XYActionSheet_block_self_index block = objc_getAssociatedObject(self, XYActionSheet_key_clicked);
    
    block ? block(actionSheet, buttonIndex) : nil;
}

-(void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    XYActionSheet_block_self block = objc_getAssociatedObject(self, XYActionSheet_key_cancel);

    block ? block(actionSheet) : nil;
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    XYActionSheet_block_self block = objc_getAssociatedObject(self, XYActionSheet_key_willPresent);
    
    block ? block(actionSheet) : nil;
}

- (void)didPresentActionSheet:(UIActionSheet *)actionSheet
{
    XYActionSheet_block_self block = objc_getAssociatedObject(self, XYActionSheet_key_didPresent);
    
    block ? block(actionSheet) : nil;
}

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    XYActionSheet_block_self_index block = objc_getAssociatedObject(self, XYActionSheet_key_willDismiss);
    
    block ? block(actionSheet, buttonIndex) : nil;
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    XYActionSheet_block_self_index block = objc_getAssociatedObject(self, XYActionSheet_key_didDismiss);
    
    block ? block(actionSheet, buttonIndex) : nil;
}

@end
