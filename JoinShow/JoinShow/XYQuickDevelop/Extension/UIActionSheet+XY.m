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
-(void) handlerClickedButton:(void (^)(UIActionSheet *actionSheet, NSInteger btnIndex))aBlock{
    self.delegate = self;
    objc_setAssociatedObject(self, UIActionSheet_key_clicked, aBlock, OBJC_ASSOCIATION_COPY);
}
-(void) handlerCancel:(void (^)(UIActionSheet *actionSheet))aBlock{
    self.delegate = self;
    objc_setAssociatedObject(self, UIActionSheet_key_cancel, aBlock, OBJC_ASSOCIATION_COPY);
}
-(void) handlerWillPresent:(void (^)(UIActionSheet *actionSheet))aBlock{
    self.delegate = self;
    objc_setAssociatedObject(self, UIActionSheet_key_willPresent, aBlock, OBJC_ASSOCIATION_COPY);
}
-(void) handlerDidPresent:(void (^)(UIActionSheet *actionSheet))aBlock{
    self.delegate = self;
    objc_setAssociatedObject(self, UIActionSheet_key_didPresent, aBlock, OBJC_ASSOCIATION_COPY);
}
-(void) handlerWillDismiss:(void (^)(UIActionSheet *actionSheet))aBlock{
    self.delegate = self;
    objc_setAssociatedObject(self, UIActionSheet_key_willDismiss, aBlock, OBJC_ASSOCIATION_COPY);
}
-(void) handlerDidDismiss:(void (^)(UIActionSheet *actionSheet, NSInteger btnIndex))aBlock{
    self.delegate = self;
    objc_setAssociatedObject(self, UIActionSheet_key_didDismiss, aBlock, OBJC_ASSOCIATION_COPY);
}
#pragma mark - UIActionSheetDelegate
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    void (^block)(UIActionSheet *actionSheet, NSInteger btnIndex) = objc_getAssociatedObject(self, UIActionSheet_key_clicked);
    
    if (block) block(actionSheet, buttonIndex);
}
-(void)actionSheetCancel:(UIActionSheet *)actionSheet{
    void (^block)(UIActionSheet *actionSheet) = objc_getAssociatedObject(self, UIActionSheet_key_cancel);
    
    if (block) block(actionSheet);
}

-(void) willPresentActionSheet:(UIActionSheet *)actionSheet{
    void (^block)(UIActionSheet *actionSheet) = objc_getAssociatedObject(self, UIActionSheet_key_willPresent);
    
    if (block) block(actionSheet);
}

-(void) didPresentActionSheet:(UIActionSheet *)actionSheet{
    void (^block)(UIActionSheet *actionSheet) = objc_getAssociatedObject(self, UIActionSheet_key_didPresent);
    
    if (block) block(actionSheet);
}

-(void) actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    void (^block)(UIActionSheet *actionSheet, NSInteger btnIndex) = objc_getAssociatedObject(self, UIActionSheet_key_willDismiss);
    
    if (block) block(actionSheet, buttonIndex);
}

-(void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    void (^block)(UIActionSheet *actionSheet, NSInteger btnIndex) = objc_getAssociatedObject(self, UIActionSheet_key_didDismiss);
    
    if (block) block(actionSheet, buttonIndex);
}

@end
