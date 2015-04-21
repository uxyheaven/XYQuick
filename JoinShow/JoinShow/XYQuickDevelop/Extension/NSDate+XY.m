//
//  NSDate+XY.m
//  JoinShow
//
//  Created by Heaven on 13-10-16.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import "NSDate+XY.h"
#import "XYPredefine.h"
#import "XYCommon.h"
#import "NSObject+XY.h"

DUMMY_CLASS(NSDate_XY);

#define NSDate_key_stringCache	"NSDate.stringCache"

@implementation NSDate (XY)

+ (void)load
{
    XY_weekdays = @[@"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六"];
}


#pragma mark -
@dynamic year;
- (NSInteger)year
{
	return [[NSCalendar currentCalendar] components:NSYearCalendarUnit
										   fromDate:self].year;
}

@dynamic month;
- (NSInteger)month
{
	return [[NSCalendar currentCalendar] components:NSMonthCalendarUnit
										   fromDate:self].month;
}

@dynamic day;
- (NSInteger)day
{
	return [[NSCalendar currentCalendar] components:NSDayCalendarUnit
										   fromDate:self].day;
}

@dynamic hour;
- (NSInteger)hour
{
	return [[NSCalendar currentCalendar] components:NSHourCalendarUnit
										   fromDate:self].hour;
}

@dynamic minute;
- (NSInteger)minute
{
	return [[NSCalendar currentCalendar] components:NSMinuteCalendarUnit
										   fromDate:self].minute;
}

@dynamic second;
- (NSInteger)second
{
	return [[NSCalendar currentCalendar] components:NSSecondCalendarUnit
										   fromDate:self].second;
}

@dynamic weekday;
- (NSInteger)weekday
{
	return [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit
										   fromDate:self].weekday;
}

@dynamic stringWeekday;
- (NSString *)stringWeekday
{
    return XY_weekdays[self.weekday - 1];
}

- (NSString *)stringWithDateFormat:(NSString *)format
{
#if 0
	
	NSTimeInterval time = [self timeIntervalSince1970];
	NSUInteger timeUint = (NSUInteger)time;
    
	return [[NSNumber numberWithUnsignedInteger:timeUint] stringWithDateFormat:format];
	
#else
	
	// thansk @lancy, changed: "NSDate depend on NSNumber" to "NSNumber depend on NSDate"
	
	NSDateFormatter * dateFormatter = [XYCommon dateFormatterTemp];
	[dateFormatter setDateFormat:format];
    
	return [dateFormatter stringFromDate:self];
	
#endif
}

- (NSString *)timeAgo
{
	NSTimeInterval delta = [[NSDate date] timeIntervalSinceDate:self];
	
	if (delta < 1 * MINUTE)
	{
		return @"刚刚";
	}
	else if (delta < 2 * MINUTE)
	{
		return @"1分钟前";
	}
	else if (delta < 45 * MINUTE)
	{
		int minutes = floor((double)delta/MINUTE);
		return [NSString stringWithFormat:@"%d分钟前", minutes];
	}
	else if (delta < 90 * MINUTE)
	{
		return @"1小时前";
	}
	else if (delta < 24 * HOUR)
	{
		int hours = floor((double)delta/HOUR);
		return [NSString stringWithFormat:@"%d小时前", hours];
	}
	else if (delta < 48 * HOUR)
	{
		return @"昨天";
	}
	else if (delta < 30 * DAY)
	{
		int days = floor((double)delta/DAY);
		return [NSString stringWithFormat:@"%d天前", days];
	}
	else if (delta < 12 * MONTH)
	{
		int months = floor((double)delta/MONTH);
		return months <= 1 ? @"1个月前" : [NSString stringWithFormat:@"%d个月前", months];
	}
    
	int years = floor((double)delta/MONTH/12.0);
	return years <= 1 ? @"1年前" : [NSString stringWithFormat:@"%d年前", years];
}

+ (long long)timeStamp
{
	return (long long)[[NSDate date] timeIntervalSince1970];
}

+ (NSDate *)dateWithString:(NSString *)string
{
    return nil;
}

+ (NSDate *)now
{
	return [NSDate date];
}

- (NSDate *)dateAfterDay:(int)day
{
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    [componentsToAdd setDay:day];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *dateAfterDay = [calendar dateByAddingComponents:componentsToAdd toDate:self options:0];

    return dateAfterDay;
}

- (NSInteger)distanceInDaysToDate:(NSDate *)aDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSDayCalendarUnit fromDate:self toDate:aDate options:0];
    return [dateComponents day];
}

///////////////////////////
@dynamic stringCache;
- (NSString *)stringCache
{
    NSString *str = (NSString *)[self getAssociatedObjectForKey:NSDate_key_stringCache];
    if (str == nil)
    {
        return [self resetStringCache];
    }
    
    return str;
}

- (NSString *)resetStringCache
{
    NSDateFormatter *dateFormatter = [XYCommon dateFormatterByUTC];
    NSString *str                  = [dateFormatter stringFromDate:self];
    
    [self copyAssociatedObject:str forKey:NSDate_key_stringCache];
    
    return str;
}

- (NSDate *)localTime
{
    // NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSTimeZone *zone   = [NSTimeZone localTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: self];
    NSDate *localeDate = [self  dateByAddingTimeInterval: interval];
    
    return localeDate;
}

#pragma mark - private
+ (NSCalendar *)AZ_currentCalendar
{
    // 你使用NSThread的threadDictionary方法来检索一个NSMutableDictionary对象，你可以在它里面添加任何线程需要的键。每个线程都维护了一个键-值的字典，它可以在线程里面的任何地方被访问。你可以使用该字典来保存一些信息，这些信息在整个线程的执行过程中都保持不变。
    NSMutableDictionary *dictionary = [[NSThread currentThread] threadDictionary];
    NSCalendar *currentCalendar     = [dictionary objectForKey:@"AZ_currentCalendar"];
    if (currentCalendar == nil)
    {
        currentCalendar = [NSCalendar currentCalendar];
        [dictionary setObject:currentCalendar forKey:@"AZ_currentCalendar"];
    }
    
    return currentCalendar;
}
@end








