//
//  UIAlertView+XY.m
//  JoinShow
//
//  Created by Heaven on 13-10-17.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#undef	UIAlertView_key_clicked
#define UIAlertView_key_clicked	"UIAlertView.clicked"
#undef	UIAlertView_key_cancel
#define UIAlertView_key_cancel	"UIAlertView.cancel"
#undef	UIAlertView_key_willPresent
#define UIAlertView_key_willPresent	"UIAlertView.willPresent"
#undef	UIAlertView_key_didPresent
#define UIAlertView_key_didPresent	"UIAlertView.didPresent"
#undef	UIAlertView_key_willDismiss
#define UIAlertView_key_willDismiss	"UIAlertView.willDismiss"
#undef	UIAlertView_key_didDismiss
#define UIAlertView_key_didDismiss	"UIAlertView.didDismiss"
#undef	UIAlertView_key_shouldEnableFirstOtherButton
#define UIAlertView_key_shouldEnableFirstOtherButton	"UIAlertView.SEFOB"

#import "UIAlertView+XY.h"
#import "XYPrecompile.h"

DUMMY_CLASS(UIAlertView_XY);

@implementation UIAlertView (XY)

-(void) handlerClickedButton:(void (^)(UIAlertView *alertView, NSInteger btnIndex))aBlock{
    self.delegate = self;
    objc_setAssociatedObject(self, UIAlertView_key_clicked, aBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(void) handlerCancel:(void (^)(UIAlertView *alertView))aBlock{
    self.delegate = self;
    objc_setAssociatedObject(self, UIAlertView_key_cancel, aBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(void) handlerWillPresent:(void (^)(UIAlertView *alertView))aBlock{
    self.delegate = self;
    objc_setAssociatedObject(self, UIAlertView_key_willPresent, aBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(void) handlerDidPresent:(void (^)(UIAlertView *alertView))aBlock{
    self.delegate = self;
    objc_setAssociatedObject(self, UIAlertView_key_didPresent, aBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(void) handlerWillDismiss:(void (^)(UIAlertView *alertView, NSInteger btnIndex))aBlock{
    self.delegate = self;
    objc_setAssociatedObject(self, UIAlertView_key_willDismiss, aBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(void) handlerDidDismiss:(void (^)(UIAlertView *alertView, NSInteger btnIndex))aBlock{
    self.delegate = self;
    objc_setAssociatedObject(self, UIAlertView_key_didDismiss, aBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(void) handlerShouldEnableFirstOtherButton:(BOOL (^)(UIAlertView *alertView))aBlock{
    self.delegate = self;
    objc_setAssociatedObject(self, UIAlertView_key_shouldEnableFirstOtherButton, aBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark - UIAlertViewDelegate
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    void (^block)(UIAlertView *alertView, NSInteger btnIndex) = objc_getAssociatedObject(self, UIAlertView_key_clicked);
    
    if (block) block(alertView, buttonIndex);
}
-(void) alertViewCancel:(UIAlertView *)alertView{
    void (^block)(UIAlertView *alertView) = objc_getAssociatedObject(self, UIAlertView_key_cancel);
    
    if (block) block(alertView);
}
-(void) willPresentAlertView:(UIAlertView *)alertView{
    void (^block)(UIAlertView *alertView) = objc_getAssociatedObject(self, UIAlertView_key_willPresent);
    
    if (block) block(alertView);
}

-(void) didPresentAlertView:(UIAlertView *)alertView{
    void (^block)(UIAlertView *alertView) = objc_getAssociatedObject(self, UIAlertView_key_didPresent);
    
    if (block) block(alertView);
}

-(void) alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
    void (^block)(UIAlertView *alertView, NSInteger btnIndex) = objc_getAssociatedObject(self, UIAlertView_key_willDismiss);
    
    if (block) block(alertView,buttonIndex);
}

-(void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    void (^block)(UIAlertView *alertView, NSInteger btnIndex) = objc_getAssociatedObject(self, UIAlertView_key_didDismiss);
    
    if (block) block(alertView, buttonIndex);
}


-(BOOL) alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView{
    BOOL (^block)(UIAlertView *alertView) = objc_getAssociatedObject(self, UIAlertView_key_shouldEnableFirstOtherButton);
    
    if (block) {
        return block(alertView);
    }
    return YES;
}
@end
