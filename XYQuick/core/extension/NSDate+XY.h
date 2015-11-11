//
//  __  __          ____           _          _
//  \ \/ / /\_/\   /___ \  _   _  (_)   ___  | | __
//   \  /  \_ _/  //  / / | | | | | |  / __| | |/ /
//   /  \   / \  / \_/ /  | |_| | | | | (__  |   <
//  /_/\_\  \_/  \___,_\   \__,_| |_|  \___| |_|\_\
//
//  Copyright (C) Heaven.
//
//	https://github.com/uxyheaven/XYQuick
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.
//

#import "XYQuick_Predefine.h"
#pragma mark -

#define __XY_SECOND	(1)
#define __XY_MINUTE	(60 * __XY_SECOND)
#define __XY_HOUR	(60 * __XY_MINUTE)
#define __XY_DAY    (24 * __XY_HOUR)
#define __XY_MONTH	(30 * __XY_DAY)

@interface NSDate (XYExtension)

@property (nonatomic, readonly) NSInteger uxy_year;
@property (nonatomic, readonly) NSInteger uxy_month;
@property (nonatomic, readonly) NSInteger uxy_day;
@property (nonatomic, readonly) NSInteger uxy_hour;
@property (nonatomic, readonly) NSInteger uxy_minute;
@property (nonatomic, readonly) NSInteger uxy_second;
@property (nonatomic, readonly) NSInteger uxy_weekday;

@property (nonatomic, readonly) NSString *uxy_stringWeekday;

// @"yyyy-MM-dd HH:mm:ss"
- (NSString *)uxy_stringWithDateFormat:(NSString *)format;
// 刚刚 %d分钟前 %d小时前 昨天 %d天前 %d个月前 %d年前
- (NSString *)uxy_timeAgo;

+ (long long)uxy_timeStamp;

+ (NSDate *)uxy_dateWithString:(NSString *)string;
+ (NSDate *)uxy_now;

/// 返回day天后的日期(若day为负数,则为|day|天前的日期)
- (NSDate *)uxy_dateAfterDay:(int)day;

/// 返回距离aDate有多少天
- (NSInteger)uxy_distanceInDaysToDate:(NSDate *)aDate;

/// UTC时间string缓存
@property (nonatomic, copy, readonly) NSString *uxy_stringCache;
/// 重置缓存
- (NSString *)uxy_resetStringCache;
/// 返回当地时区的时间
- (NSDate *)uxy_localTime;

/**
 * @brief 返回日期格式器
 * @return dateFormatter yyyy-MM-dd HH:mm:ss. dateFormatterByUTC 返回UTC格式的
 */
+ (NSDateFormatter *)uxy_dateFormatter;
+ (NSDateFormatter *)uxy_dateFormatterByUTC;
+ (NSDateFormatter *)uxy_dateFormatterWithFormatter:(NSString *)formatter;
@end
