//
//  XYViewControllerProtocol.h
//  JoinShow
//
//  Created by heaven on 14/12/19.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XYViewControllerProtocol <NSObject>

@optional
- (void)showErrorViewWithParameter:(id)param;
- (void)closeErrorView;

- (void)showZeroDataViewWithParameter:(id)param;
- (void)closeZeroDataView;

- (void)showLoadingDataViewWithParameter:(id)param;
- (void)closeLoadingDataView;

@end
