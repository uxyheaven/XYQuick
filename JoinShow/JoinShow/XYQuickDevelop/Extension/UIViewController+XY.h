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
-(void) pushVC:(NSString *)vcName;
-(void) pushVC:(NSString *)vcName object:(id)object;

// 模态 带导航控制器
-(void) modalVC:(NSString *)vcName withNavigationVC:(NSString *)navName;
-(void) modalVC:(NSString *)vcName withNavigationVC:(NSString *)navName object:(id)object succeed:(UIViewController_block_void)block;

@end

@protocol XYSwitchControllerProtocol <NSObject>

-(id) initWithObject:(id)object;

@end