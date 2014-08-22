//
//  NSDate+XY.h
//  JoinShow
//
//  Created by Heaven on 13-10-16.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#define SECOND	(1)
#define MINUTE	(60 * SECOND)
#define HOUR	(60 * MINUTE)
#define DAY		(24 * HOUR)
#define MONTH	(30 * DAY)

static NSArray *XY_weekdays = nil;

@interface NSDate (XY)

@property (nonatomic, readonly) NSInteger	year;
@property (nonatomic, readonly) NSInteger	month;
@property (nonatomic, readonly) NSInteger	day;
@property (nonatomic, readonly) NSInteger	hour;
@property (nonatomic, readonly) NSInteger	minute;
@property (nonatomic, readonly) NSInteger	second;
@property (nonatomic, readonly) NSInteger	weekday;

@property (nonatomic, readonly) NSString	*stringWeekday;

// @"yyyy-MM-dd HH:mm:ss"
- (NSString *)stringWithDateFormat:(NSString *)format;
- (NSString *)timeAgo;

+ (long long)timeStamp;

+ (NSDate *)dateWithString:(NSString *)string;
+ (NSDate *)now;

// 返回day天后的日期(若day为负数,则为|day|天前的日期)
- (NSDate *)dateAfterDay:(int)day;

// 返回距离aDate有多少天
- (NSInteger)distanceInDaysToDate:(NSDate *)aDate;

// UTC时间string缓存
@property (nonatomic, copy, readonly) NSString *stringCache;
// 重置缓存
- (NSString *)resetStringCache;
// 返回当地时区的时间
- (NSDate *)localTime;

@end
