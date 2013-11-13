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


@interface NSDate (XY)

@property (nonatomic, readonly) NSInteger	year;
@property (nonatomic, readonly) NSInteger	month;
@property (nonatomic, readonly) NSInteger	day;
@property (nonatomic, readonly) NSInteger	hour;
@property (nonatomic, readonly) NSInteger	minute;
@property (nonatomic, readonly) NSInteger	second;
@property (nonatomic, readonly) NSInteger	weekday;

-(NSString *) stringWithDateFormat:(NSString *)format;
-(NSString *) timeAgo;

+(long long) timeStamp;

+(NSDate *) dateWithString:(NSString *)string;
+(NSDate *) now;

@end
