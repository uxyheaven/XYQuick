//
//  IndicatorHelper.m
//  JoinShow
//
//  Created by Heaven on 14-6-11.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import "IndicatorHelper.h"

@implementation IndicatorHelper

DEF_SINGLETON(IndicatorHelper)

+(id) originalIndicator{
    UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    view.hidesWhenStopped = YES;
    
    return view;
}

@end
