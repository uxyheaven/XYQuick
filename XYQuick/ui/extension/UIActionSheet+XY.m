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
#import "XYQuick_Predefine.h"
#import "NSObject+XY.h"

DUMMY_CLASS(UIActionSheet_XY);

@implementation UIActionSheet (XY)
- (void)uxy_handlerClickedButton:(UIActionSheet_block_self_index)aBlock
{
    self.delegate = self;
    [self uxy_copyAssociatedObject:aBlock forKey:UIActionSheet_key_clicked];
}
- (void)uxy_handlerCancel:(UIActionSheet_block_self)aBlock
{
    self.delegate = self;
    [self uxy_copyAssociatedObject:aBlock forKey:UIActionSheet_key_cancel];
}
- (void)uxy_handlerWillPresent:(UIActionSheet_block_self)aBlock
{
    self.delegate = self;
    [self uxy_copyAssociatedObject:aBlock forKey:UIActionSheet_key_willPresent];
}
- (void)uxy_handlerDidPresent:(UIActionSheet_block_self)aBlock
{
    self.delegate = self;
    [self uxy_copyAssociatedObject:aBlock forKey:UIActionSheet_key_didPresent];
}
- (void)uxy_handlerWillDismiss:(UIActionSheet_block_self)aBlock
{
    self.delegate = self;
    [self uxy_copyAssociatedObject:aBlock forKey:UIActionSheet_key_willDismiss];
}
- (void)uxy_handlerDidDismiss:(UIActionSheet_block_self_index)aBlock
{
    self.delegate = self;
    [self uxy_copyAssociatedObject:aBlock forKey:UIActionSheet_key_didDismiss];
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIActionSheet_block_self_index block = [self uxy_getAssociatedObjectForKey:UIActionSheet_key_clicked];
    
    if (block)
        block(actionSheet, buttonIndex);
}

-(void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    UIActionSheet_block_self block = [self uxy_getAssociatedObjectForKey:UIActionSheet_key_cancel];
    
    if (block)
        block(actionSheet);
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    UIActionSheet_block_self block = [self uxy_getAssociatedObjectForKey:UIActionSheet_key_willPresent];
    
    if (block)
        block(actionSheet);
}

- (void)didPresentActionSheet:(UIActionSheet *)actionSheet
{
    UIActionSheet_block_self block = [self uxy_getAssociatedObjectForKey:UIActionSheet_key_didPresent];
    
    if (block)
        block(actionSheet);
}

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    UIActionSheet_block_self_index block = [self uxy_getAssociatedObjectForKey:UIActionSheet_key_willDismiss];
    
    if (block)
        block(actionSheet, buttonIndex);
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    UIActionSheet_block_self_index block = [self uxy_getAssociatedObjectForKey:UIActionSheet_key_didDismiss];
    
    if (block)
        block(actionSheet, buttonIndex);
}

@end
