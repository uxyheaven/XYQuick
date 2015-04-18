//
//  XYMenuItem.h
//  JoinShow
//
//  Created by heaven on 14/12/11.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XYMenuItem <NSObject>


@optional

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *backgroundImage;

@end
