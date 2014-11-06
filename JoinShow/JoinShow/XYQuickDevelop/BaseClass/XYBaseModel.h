//
//  XYBaseModel.h
//  JoinShow
//
//  Created by Heaven on 14-4-25.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYBaseDataSource.h"

@interface XYBaseModel : NSObject <XYDataSourceDelegate>


// 读取数据
- (void)loadDataWith:(XYBaseDataSource *)dataGet;


#pragma mark - m 对 c
// 1 Notification
// 2 KVO

#pragma mark - c直接调用m
// api


@end
