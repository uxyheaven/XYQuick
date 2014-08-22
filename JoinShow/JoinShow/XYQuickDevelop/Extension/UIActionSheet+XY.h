//
//  UIActionSheet+XY.h
//  JoinShow
//
//  Created by Heaven on 13-10-17.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import "XYPrecompile.h"
typedef void(^UIActionSheet_block_self_index)(UIActionSheet *actionSheet, NSInteger btnIndex);
typedef void(^UIActionSheet_block_self)(UIActionSheet *actionSheet);

@interface UIActionSheet (XY) <UIActionSheetDelegate>

- (void)handlerClickedButton:(UIActionSheet_block_self_index)aBlock;
- (void)handlerCancel:(UIActionSheet_block_self)aBlock;
- (void)handlerWillPresent:(UIActionSheet_block_self)aBlock;
- (void)handlerDidPresent:(UIActionSheet_block_self)aBlock;
- (void)handlerWillDismiss:(UIActionSheet_block_self)aBlock;
- (void)handlerDidDismiss:(UIActionSheet_block_self_index)aBlock;

@end
