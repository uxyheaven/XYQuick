//
//  UIActionSheet+XY.h
//  JoinShow
//
//  Created by Heaven on 13-10-17.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import "XYPrecompile.h"

@interface UIActionSheet (XY) <UIActionSheetDelegate>

-(void) handlerClickedButton:(void (^)(UIActionSheet *actionSheet, NSInteger btnIndex))aBlock;
-(void) handlerCancel:(void (^)(UIActionSheet *actionSheet))aBlock;
-(void) handlerWillPresent:(void (^)(UIActionSheet *actionSheet))aBlock;
-(void) handlerDidPresent:(void (^)(UIActionSheet *actionSheet))aBlock;
-(void) handlerWillDismiss:(void (^)(UIActionSheet *actionSheet))aBlock;
-(void) handlerDidDismiss:(void (^)(UIActionSheet *actionSheet, NSInteger btnIndex))aBlock;

@end
