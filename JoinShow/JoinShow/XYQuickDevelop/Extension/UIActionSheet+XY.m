//
//  UIActionSheet+XY.m
//  JoinShow
//
//  Created by Heaven on 13-10-17.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#undef	UIActionSheet_key_clicked
#define UIActionSheet_key_clicked	"UIActionSheet.clicked"
#undef	UIActionSheet_key_cancel
#define UIActionSheet_key_cancel	"UIActionSheet.cancel"
#undef	UIActionSheet_key_willPresent
#define UIActionSheet_key_willPresent	"UIActionSheet.willPresent"
#undef	UIActionSheet_key_didPresent
#define UIActionSheet_key_didPresent	"UIActionSheet.didPresent"
#undef	UIActionSheet_key_willDismiss
#define UIActionSheet_key_willDismiss	"UIActionSheet.willDismiss"
#undef	UIActionSheet_key_didDismiss
#define UIActionSheet_key_didDismiss	"UIActionSheet.sidDismiss"

#import "UIActionSheet+XY.h"
#import "XYPrecompile.h"

DUMMY_CLASS(UIActionSheet_XY);

@implementation UIActionSheet (XY)
- (void)handlerClickedButton:(UIActionSheet_block_self_index)aBlock
{
    self.delegate = self;
    objc_setAssociatedObject(self, UIActionSheet_key_clicked, aBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void)handlerCancel:(UIActionSheet_block_self)aBlock
{
    self.delegate = self;
    objc_setAssociatedObject(self, UIActionSheet_key_cancel, aBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void)handlerWillPresent:(UIActionSheet_block_self)aBlock
{
    self.delegate = self;
    objc_setAssociatedObject(self, UIActionSheet_key_willPresent, aBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void)handlerDidPresent:(UIActionSheet_block_self)aBlock
{
    self.delegate = self;
    objc_setAssociatedObject(self, UIActionSheet_key_didPresent, aBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void)handlerWillDismiss:(UIActionSheet_block_self)aBlock
{
    self.delegate = self;
    objc_setAssociatedObject(self, UIActionSheet_key_willDismiss, aBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void)handlerDidDismiss:(UIActionSheet_block_self_index)aBlock
{
    self.delegate = self;
    objc_setAssociatedObject(self, UIActionSheet_key_didDismiss, aBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIActionSheet_block_self_index block = objc_getAssociatedObject(self, UIActionSheet_key_clicked);
    
    if (block)
        block(actionSheet, buttonIndex);
}
-(void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    UIActionSheet_block_self block = objc_getAssociatedObject(self, UIActionSheet_key_cancel);
    
    if (block)
        block(actionSheet);
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    UIActionSheet_block_self block = objc_getAssociatedObject(self, UIActionSheet_key_willPresent);
    
    if (block)
        block(actionSheet);
}

- (void)didPresentActionSheet:(UIActionSheet *)actionSheet
{
    UIActionSheet_block_self block = objc_getAssociatedObject(self, UIActionSheet_key_didPresent);
    
    if (block)
        block(actionSheet);
}

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    UIActionSheet_block_self_index block = objc_getAssociatedObject(self, UIActionSheet_key_willDismiss);
    
    if (block)
        block(actionSheet, buttonIndex);
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    UIActionSheet_block_self_index block = objc_getAssociatedObject(self, UIActionSheet_key_didDismiss);
    
    if (block)
        block(actionSheet, buttonIndex);
}

@end
