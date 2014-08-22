//
//  NSNumber+XY.h
//  JoinShow
//
//  Created by Heaven on 13-10-16.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#undef	__INT
#define __INT( __x )			[NSNumber numberWithInteger:(NSInteger)__x]

#undef	__UINT
#define __UINT( __x )			[NSNumber numberWithUnsignedInt:(NSUInteger)__x]

#undef	__FLOAT
#define	__FLOAT( __x )			[NSNumber numberWithFloat:(float)__x]

#undef	__DOUBLE
#define	__DOUBLE( __x )			[NSNumber numberWithDouble:(double)__x]

#undef	__BOOL
#define __BOOL( __x )			[NSNumber numberWithBool:(BOOL)__x]

@interface NSNumber (XY)

@property (nonatomic, readonly, strong) NSDate  *dateValue;

- (NSString *)stringWithDateFormat:(NSString *)format;

@end
