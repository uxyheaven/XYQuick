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

#import "NSDate+XY.h"
#import "NSObject+XY.h"

DUMMY_CLASS(NSDate_XY);

@implementation NSDate (XY)

+ (void)load
{
    XY_weekdays = @[@"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六"];
}


#pragma mark -
@dynamic uxy_year;
- (NSInteger)uxy_year
{
	return [[NSCalendar currentCalendar] components:NSYearCalendarUnit
										   fromDate:self].year;
}

@dynamic uxy_month;
- (NSInteger)uxy_month
{
	return [[NSCalendar currentCalendar] components:NSMonthCalendarUnit
										   fromDate:self].month;
}

@dynamic uxy_day;
- (NSInteger)uxy_day
{
	return [[NSCalendar currentCalendar] components:NSDayCalendarUnit
										   fromDate:self].day;
}

@dynamic uxy_hour;
- (NSInteger)uxy_hour
{
	return [[NSCalendar currentCalendar] components:NSHourCalendarUnit
										   fromDate:self].hour;
}

@dynamic uxy_minute;
- (NSInteger)uxy_minute
{
	return [[NSCalendar currentCalendar] components:NSMinuteCalendarUnit
										   fromDate:self].minute;
}

@dynamic uxy_second;
- (NSInteger)uxy_second
{
	return [[NSCalendar currentCalendar] components:NSSecondCalendarUnit
										   fromDate:self].second;
}

@dynamic uxy_weekday;
- (NSInteger)uxy_weekday
{
	return [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit
										   fromDate:self].weekday;
}

@dynamic uxy_stringWeekday;
- (NSString *)uxy_stringWeekday
{
    return XY_weekdays[self.uxy_weekday - 1];
}

- (NSString *)uxy_stringWithDateFormat:(NSString *)format
{
#if 0
	
	NSTimeInterval time = [self timeIntervalSince1970];
	NSUInteger timeUint = (NSUInteger)time;
    
	return [[NSNumber numberWithUnsignedInteger:timeUint] stringWithDateFormat:format];
	
#else
	
	// thansk @lancy, changed: "NSDate depend on NSNumber" to "NSNumber depend on NSDate"
	
	NSDateFormatter * dateFormatter = [NSDate uxy_dateFormatter];
	[dateFormatter setDateFormat:format];
    
	return [dateFormatter stringFromDate:self];
	
#endif
}

- (NSString *)uxy_timeAgo
{
	NSTimeInterval delta = [[NSDate date] timeIntervalSinceDate:self];
	
	if (delta < 1 * __XY_MINUTE)
	{
		return @"刚刚";
	}
	else if (delta < 2 * __XY_MINUTE)
	{
		return @"1分钟前";
	}
	else if (delta < 45 * __XY_MINUTE)
	{
		int minutes = floor((double)delta / __XY_MINUTE);
		return [NSString stringWithFormat:@"%d分钟前", minutes];
	}
	else if (delta < 90 * __XY_MINUTE)
	{
		return @"1小时前";
	}
	else if (delta < 24 * __XY_HOUR)
	{
		int hours = floor((double)delta /__XY_HOUR);
		return [NSString stringWithFormat:@"%d小时前", hours];
	}
	else if (delta < 48 * __XY_HOUR)
	{
		return @"昨天";
	}
	else if (delta < 30 * __XY_DAY)
	{
		int days = floor((double)delta / __XY_DAY);
		return [NSString stringWithFormat:@"%d天前", days];
	}
	else if (delta < 12 * __XY_MONTH)
	{
		int months = floor((double)delta / __XY_MONTH);
		return months <= 1 ? @"1个月前" : [NSString stringWithFormat:@"%d个月前", months];
	}
    
	int years = floor((double)delta / __XY_MONTH / 12.0);
	return years <= 1 ? @"1年前" : [NSString stringWithFormat:@"%d年前", years];
}

+ (long long)uxy_timeStamp
{
	return (long long)[[NSDate date] timeIntervalSince1970];
}

+ (NSDate *)uxy_dateWithString:(NSString *)string
{
    return nil;
}

+ (NSDate *)uxy_now
{
	return [NSDate date];
}

- (NSDate *)uxy_dateAfterDay:(int)day
{
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    [componentsToAdd setDay:day];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *dateAfterDay = [calendar dateByAddingComponents:componentsToAdd toDate:self options:0];

    return dateAfterDay;
}

- (NSInteger)uxy_distanceInDaysToDate:(NSDate *)aDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSDayCalendarUnit fromDate:self toDate:aDate options:0];
    return [dateComponents day];
}

///////////////////////////
uxy_staticConstString(NSDate_key_stringCache)

- (NSString *)uxy_stringCache
{
    NSString *str = (NSString *)[self uxy_getAssociatedObjectForKey:NSDate_key_stringCache];
    if (str == nil)
    {
        return [self uxy_resetStringCache];
    }
    
    return str;
}

- (NSString *)uxy_resetStringCache
{
    NSDateFormatter *dateFormatter = [NSDate uxy_dateFormatter];
    NSString *str                  = [dateFormatter stringFromDate:self];
    
    [self uxy_setCopyAssociatedObject:str forKey:NSDate_key_stringCache];
    
    return str;
}

- (NSDate *)uxy_localTime
{
    // NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSTimeZone *zone   = [NSTimeZone localTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: self];
    NSDate *localeDate = [self  dateByAddingTimeInterval: interval];
    
    return localeDate;
}

/***************************************************************/
+ (NSDateFormatter *)uxy_dateFormatter
{
    NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *dateFormatter = threadDictionary[@"uxy_dateFormatter"];
    if(!dateFormatter)
    {
        @synchronized(self)
        {
            if(!dateFormatter)
            {
                dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                threadDictionary[@"uxy_dateFormatter"] = dateFormatter;
            }
        }
    }
    
    return dateFormatter;
}

+ (NSDateFormatter *)uxy_dateFormatterByUTC
{
    NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *dateFormatter = threadDictionary[@"uxy_dateFormatterByUTC"];
    if(!dateFormatter)
    {
        @synchronized(self)
        {
            if(!dateFormatter)
            {
                dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
                [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
                threadDictionary[@"uxy_dateFormatterByUTC"] = dateFormatter;
            }
        }
    }
    
    return dateFormatter;
}

#pragma mark - private
+ (NSCalendar *)uxy_currentCalendar
{
    // 你使用NSThread的threadDictionary方法来检索一个NSMutableDictionary对象，你可以在它里面添加任何线程需要的键。每个线程都维护了一个键-值的字典，它可以在线程里面的任何地方被访问。你可以使用该字典来保存一些信息，这些信息在整个线程的执行过程中都保持不变。
    NSMutableDictionary *dictionary = [[NSThread currentThread] threadDictionary];
    NSCalendar *currentCalendar     = [dictionary objectForKey:@"uxy_currentCalendar"];
    if (currentCalendar == nil)
    {
        currentCalendar = [NSCalendar currentCalendar];
        [dictionary setObject:currentCalendar forKey:@"uxy_currentCalendar"];
    }
    
    return currentCalendar;
}
@end








