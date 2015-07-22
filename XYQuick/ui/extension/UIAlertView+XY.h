//
//  UIAlertView+XY.h
//  JoinShow
//
//  Created by Heaven on 13-10-17.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UIAlertView_block_self_index)(UIAlertView *alertView, NSInteger btnIndex);
typedef void(^UIAlertView_block_self)(UIAlertView *alertView);
typedef BOOL(^UIAlertView_block_shouldEnableFirstOtherButton)(UIAlertView *alertView);

@interface UIAlertView (XY)

- (void)uxy_handlerClickedButton:(UIAlertView_block_self_index)aBlock;
- (void)uxy_handlerCancel:(UIAlertView_block_self)aBlock;
- (void)uxy_handlerWillPresent:(UIAlertView_block_self)aBlock;
- (void)uxy_handlerDidPresent:(UIAlertView_block_self)aBlock;
- (void)uxy_handlerWillDismiss:(UIAlertView_block_self_index)aBlock;
- (void)uxy_handlerDidDismiss:(UIAlertView_block_self_index)aBlock;
- (void)uxy_handlerShouldEnableFirstOtherButton:(UIAlertView_block_shouldEnableFirstOtherButton)aBlock;

// 延时消失
- (void)uxy_showWithDuration:(NSTimeInterval)i;

@end
