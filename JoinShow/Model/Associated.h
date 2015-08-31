//
//  Associated.h
//  JoinShow
//
//  Created by Heaven on 15/8/28.
//  Copyright (c) 2015年 Heaven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYQuick.h"

@interface Associated : NSObject

@end

@interface Associated (test)
@uxy_property_basicDataType(int, age);
@uxy_property_basicDataType(NSTimeInterval, time);
@uxy_property_copy(NSString *, name);
@uxy_property_weak(NSDate *, date);

@end
