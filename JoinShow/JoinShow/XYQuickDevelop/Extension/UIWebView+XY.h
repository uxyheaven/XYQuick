//
//  UIWebView+XY.h
//  JoinShow
//
//  Created by Heaven on 14-3-5.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (XY)

// 清理网页,如果isCleanCache = YES, 就连NSURLCache,Disk,Memory也清理
- (void)clean:(BOOL)isCleanCache;

//获取当前页面的html
- (NSString*)innerHTML;

// 获取userAgent
- (NSString*)userAgent;

@end
