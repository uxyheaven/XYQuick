//
//  XYAppModule.h
//  JoinShow
//
//  Created by heaven on 14/12/4.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XYMenuItem;

@interface XYAppModule : NSObject

@property (nonatomic, strong) id <XYMenuItem> activeMenuItem;

@end
