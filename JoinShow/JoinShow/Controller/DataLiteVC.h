//
//  DataLiteVC.h
//  JoinShow
//
//  Created by Heaven on 13-9-10.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import <UIKit/UIKit.h>
#if (1 == __XYQuick_Framework__)
#import <XYQuick/XYQuickDevelop.h>
#else
#import "XYQuickDevelop.h"
#endif

@interface DataLiteVC : UIViewController
AS_DataLite_string(TestTitle)
AS_DataLite_string(TestSting)
AS_DataLite_string(TestDic)
@end
