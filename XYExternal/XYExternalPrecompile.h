//
//  XYExternalPrecompile.h
//  JoinShow
//
//  Created by Heaven on 13-11-13.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#ifndef JoinShow_XYExternalPrecompile_h
#define JoinShow_XYExternalPrecompile_h



#endif

// XYQuick是否打包
#define __XYQuick_Build__           (0)


// 第三方支持
#define __USED_FMDatabase__         (1)
#define __USED_LKDBHelper__         (1)
#define __USED_MKNetworkKit__       (1)
#define __USED_ASIHTTPRequest__     (0)
#define __USED_CocosDenshion__      (1)
#define __USED_OpenUDID__           (1)
#define __OPEN_Statistics__         (0)

#define __USED_MBProgressHUD__      (1)
#define __USED_SVPullToRefresh__    (1)

#if (1 == __USED_Statistics__)
#define UMENG
#endif

#if (1 == __XYQuick_Build__)
#define XYQuick_Framework
#import <XYQuick/XYQuickDevelop.h>
#else
#import "XYQuickDevelop.h"
#endif