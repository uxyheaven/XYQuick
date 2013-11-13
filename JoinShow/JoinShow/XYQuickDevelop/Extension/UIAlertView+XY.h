//
//  UIAlertView+XY.h
//  JoinShow
//
//  Created by Heaven on 13-10-17.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (XY)

-(void) handlerClickedButton:(void (^)(UIAlertView *alertView, NSInteger btnIndex))aBlock;
-(void) handlerCancel:(void (^)(UIAlertView *alertView))aBlock;
-(void) handlerWillPresent:(void (^)(UIAlertView *alertView))aBlock;
-(void) handlerDidPresent:(void (^)(UIAlertView *alertView))aBlock;
-(void) handlerWillDismiss:(void (^)(UIAlertView *alertView, NSInteger btnIndex))aBlock;
-(void) handlerDidDismiss:(void (^)(UIAlertView *alertView, NSInteger btnIndex))aBlock;
-(void) handlerShouldEnableFirstOtherButton:(BOOL (^)(UIAlertView *alertView))aBlock;

@end
