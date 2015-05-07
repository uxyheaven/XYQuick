//
//  XYDebugToy.h
//  JoinShow
//
//  Created by heaven on 15/4/21.
//  Copyright (c) 2015年 Heaven. All rights reserved.
//

#import "XYQuick_Predefine.h"

#pragma mark - XYDebugToy
// 这个个debug的玩具类
@interface XYDebugToy : NSObject

// 当被观察的对象释放的时候打印一段String
+ (void)hookObject:(id)anObject whenDeallocLogString:(NSString *)string;

/**
 * @brief 提取视图层次结构的方法
 * @param aView 要提取的视图
 * @param indent 层次 请给0值
 * @param outstring 保存层次的字符串
 */
+ (void)dumpView:(UIView *)aView atIndent:(int)indent into:(NSMutableString *)outstring;
// 打印视图层次结构
+ (NSString *)displayViews:(UIView *)aView;

@end

#pragma mark - XYDebug
#undef	PRINT_CALLSTACK
#define PRINT_CALLSTACK( __n )	[XYDebug printCallstack:__n];
// 断点
#undef	BREAK_POINT
#define BREAK_POINT()			[XYDebug breakPoint];

#undef	BREAK_POINT_IF
#define BREAK_POINT_IF( __x )	if ( __x ) { [XYDebug breakPoint]; }

#undef	BB
#define BB						[XYDebug breakPoint];

// 这个类名字需要在想下
@interface XYDebug : NSObject __AS_SINGLETON

+ (NSArray *)callstack:(NSUInteger)depth;

+ (void)printCallstack:(NSUInteger)depth;
+ (void)breakPoint;

- (void)allocAll;
- (void)freeAll;

- (void)alloc50M;
- (void)free50M;

@end;


#pragma mark - BorderView
#if (1 == __XY_DEBUG_SHOWBORDER__)
// uiview点击时 加边框
@interface UIWindow(XYDebug)
+ (void)hookSendEvent;
@end


@interface BorderView : UIView
- (void)startAnimation;
@end
#endif

