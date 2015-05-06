//
//  XYClassLoader.h
//  JoinShow
//
//  Created by heaven on 15/4/22.
//  Copyright (c) 2015年 Heaven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject(XYClassLoader)
+ (void)uxy_classAutoLoad;
@end

#pragma mark -

@interface XYClassLoader : NSObject

+ (instancetype)classLoader;

- (void)loadClasses:(NSArray *)classNames;

@end