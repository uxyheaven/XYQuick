//
//  UIActionSheet+XY.h
//  JoinShow
//
//  Created by Heaven on 13-10-17.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UIActionSheet_block_self_index)(UIActionSheet *actionSheet, NSInteger btnIndex);
typedef void(^UIActionSheet_block_self)(UIActionSheet *actionSheet);

@interface UIActionSheet (XY) <UIActionSheetDelegate>

- (void)uxy_handlerClickedButton:(UIActionSheet_block_self_index)aBlock;
- (void)uxy_handlerCancel:(UIActionSheet_block_self)aBlock;
- (void)uxy_handlerWillPresent:(UIActionSheet_block_self)aBlock;
- (void)uxy_handlerDidPresent:(UIActionSheet_block_self)aBlock;
- (void)uxy_handlerWillDismiss:(UIActionSheet_block_self)aBlock;
- (void)uxy_handlerDidDismiss:(UIActionSheet_block_self_index)aBlock;

@end
