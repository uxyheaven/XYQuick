//
//  XYExternal.h
//  JoinShow
//
//  Created by Heaven on 13-8-1.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#ifndef JoinShow_XYExternal_h
#define JoinShow_XYExternal_h



#endif


// 预编译头文件
#import "XYExternalPrecompile.h"

///////////////////////////////////////////////////////////////
// fmdb
#if (1 == __USED_FMDatabase__)
#import "FMDatabase.h"
#endif

// sqlite 数据库全自动操作
#if (1 == __USED_LKDBHelper__)
#import "LKDBHelper.h"
#endif

// 网络请求
#if (1 ==  __USED_MKNetworkKit__)
#import "MKNetworkKit.h"
#endif

#if (1 ==  __USED_ASIHTTPRequest__)
#import "ASIHTTPRequest.h"
#endif

// cocos2d 音频引擎
#if (1 == __USED_CocosDenshion__)
#import "SimpleAudioEngine.h"
#endif

// UDID
#if (1 == __USED_OpenUDID__)
#import "OpenUDID.h"
#endif



///////////////////////////////////////////////////////////////

// 状态指示器
#if (1 == __USED_MBProgressHUD__)
#import "MBProgressHUD.h"
#endif

// 上拉刷新 下拉加载
#if (1 == __USED_SVPullToRefresh__)
#import "SVPullToRefresh.h"
#endif

///////////////////////////////////////////////////////////////
// 导入第三方外部扩展
#import "ExternalExtension.h"

///////////////////////////////////////////////////////////////


