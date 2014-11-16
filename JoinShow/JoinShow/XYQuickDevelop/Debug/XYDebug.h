//
//  XYDebug.h
//  JoinShow
//
//  Created by Heaven on 13-12-9.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//  Copy from bee Framework http://www.bee-framework.com

// debug模式下的nslog

#import "XYPrecompile.h"

#import "XYPerformance.h"

#pragma mark -
/*
 * 说明 仅在debug下才显示nslog
 */
#if (1 == __XYDEBUG__)
#undef	NSLogD
#undef	NSLogDD
#define NSLogD(fmt, ...) {NSLog((@"%s [Line %d] DEBUG: \n" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
#define NSLogDD NSLogD(@"%@", @"");
#define NSLogDSelf NSLogD(@"Class: %@", NSStringFromClass([self class]));

#else
#define NSLogD(format, ...)
#define NSLogDD
#define NSLogDSelf
#endif


#undef	PRINT_CALLSTACK
#define PRINT_CALLSTACK( __n )	[XYDebug printCallstack:__n];
// 断点
#undef	BREAK_POINT
#define BREAK_POINT()			[XYDebug breakPoint];

#undef	BREAK_POINT_IF
#define BREAK_POINT_IF( __x )	if ( __x ) { [XYDebug breakPoint]; }

#undef	BB
#define BB						[XYDebug breakPoint];

#pragma mark - UIWindow
@interface UIWindow(XYDebug)

+ (void)hookSendEvent;

@end

#pragma mark - XYDebug
@interface XYDebug : NSObject

AS_SINGLETON(XYDebug)

+ (NSArray *)callstack:(NSUInteger)depth;

+ (void)printCallstack:(NSUInteger)depth;
+ (void)breakPoint;

- (void)allocAll;
- (void)freeAll;

- (void)alloc50M;
- (void)free50M;

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

#pragma mark - BorderView
// uiview点击时 加边框
@interface BorderView : UIView
- (void)startAnimation;
@end


@interface NSObject (XYDebug)


@end



