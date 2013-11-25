//
//  NSString+XY.h
//  JoinShow
//
//  Created by Heaven on 13-10-16.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import "XYPrecompile.h"

@interface NSString (XY)

@property (nonatomic, readonly) NSString 				*SHA1;

@property (nonatomic, readonly) NSString 				*MD5;
@property (nonatomic, readonly) NSData                  *MD5Data;

@property (nonatomic, readonly) NSData                  *data;
@property (nonatomic, readonly) NSDate                  *date;

// 去掉空格和换行
-(NSString *) trim;

-(BOOL) isNormal;
-(BOOL) isUserName;
-(BOOL) isPassword;
-(BOOL) isEmail;
-(BOOL) isUrl;
-(BOOL) isTelephone;

-(BOOL)isValueOf:(NSArray *)array;
-(BOOL)isValueOf:(NSArray *)array caseInsens:(BOOL)caseInsens;

@end
