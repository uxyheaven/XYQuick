//
//  UIViewController+XY.h
//  JoinShow
//
//  Created by Heaven on 14-4-24.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UIViewController_block_void) (void);

@interface UIViewController (XY)

@property (nonatomic, retain) id parameters; // 参数

// 导航
-(void) pushVC:(NSString *)vcName parameters:(id)parameters;

// 模态
-(void) modalVC:(NSString *)vcName parameters:(id)parameters succeed:(UIViewController_block_void)block;

@end
