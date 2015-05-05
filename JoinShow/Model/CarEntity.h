//
//  CarEntity.h
//  JoinShow
//
//  Created by Heaven on 14-9-12.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

// 测试XYBaseDao用
#import <Foundation/Foundation.h>
#import "XYBaseDao.h"

@interface CarEntity : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *brand;
@property (nonatomic, assign) NSInteger time;

@end
