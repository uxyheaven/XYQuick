//
//  NSDate+XY.h
//  JoinShow
//
//  Created by Heaven on 13-10-16.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SECOND	(1)
#define MINUTE	(60 * SECOND)
#define HOUR	(60 * MINUTE)
#define DAY		(24 * HOUR)
#define MONTH	(30 * DAY)

static NSArray *XY_weekdays = nil;

@interface NSDate (XY)

@property (nonatomic, readonly) NSInteger   uxy_year;
@property (nonatomic, readonly) NSInteger	uxy_month;
@property (nonatomic, readonly) NSInteger	uxy_day;
@property (nonatomic, readonly) NSInteger	uxy_hour;
@property (nonatomic, readonly) NSInteger	uxy_minute;
@property (nonatomic, readonly) NSInteger	uxy_second;
@property (nonatomic, readonly) NSInteger	uxy_weekday;

@property (nonatomic, readonly) NSString	*uxy_stringWeekday;

// @"yyyy-MM-dd HH:mm:ss"
- (NSString *)uxy_stringWithDateFormat:(NSString *)format;
- (NSString *)uxy_timeAgo;

+ (long long)uxy_timeStamp;

+ (NSDate *)uxy_dateWithString:(NSString *)string;
+ (NSDate *)uxy_now;

// 返回day天后的日期(若day为负数,则为|day|天前的日期)
- (NSDate *)uxy_dateAfterDay:(int)day;

// 返回距离aDate有多少天
- (NSInteger)uxy_distanceInDaysToDate:(NSDate *)aDate;

// UTC时间string缓存
@property (nonatomic, copy, readonly) NSString *uxy_stringCache;
// 重置缓存
- (NSString *)uxy_resetStringCache;
// 返回当地时区的时间
- (NSDate *)uxy_localTime;

/**
 * @brief 返回日期格式器
 * @return dateFormatter yyyy-MM-dd HH:mm:ss. dateFormatterByUTC 返回UTC格式的
 */
+ (NSDateFormatter *)uxy_dateFormatter;
+ (NSDateFormatter *)uxy_dateFormatterByUTC;
@end
