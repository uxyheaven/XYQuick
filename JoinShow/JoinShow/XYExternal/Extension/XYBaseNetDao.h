//
//  XYBaseNetDao.h
//  JoinShow
//
//  Created by Heaven on 14-9-10.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^XYBaseNetDao_successBlock)(id request, NSError *err, id data, BOOL isCache);

@interface XYBaseNetDao : NSObject

- (void)loadEntity;

@end
