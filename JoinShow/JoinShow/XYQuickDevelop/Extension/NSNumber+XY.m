//
//  NSNumber+XY.m
//  JoinShow
//
//  Created by Heaven on 13-10-16.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import "NSNumber+XY.h"
#import "XYPrecompile.h"
#import "NSDate+XY.h"

DUMMY_CLASS(NSNumber_XY);

@implementation NSNumber (XY)

@dynamic dateValue;

- (NSDate *)dateValue
{
	return [NSDate dateWithTimeIntervalSince1970:self.doubleValue];
}

- (NSString *)stringWithDateFormat:(NSString *)format
{
#if 0
	NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
	NSString * result = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[self doubleValue]]];
	[dateFormatter release];
    
	return result;
	
#else
	// thanks @lancy, changed: "NSDate depend on NSNumber" to "NSNumber depend on NSDate"
	return [[NSDate dateWithTimeIntervalSince1970:[self doubleValue]] stringWithDateFormat:format];
#endif
}

@end
