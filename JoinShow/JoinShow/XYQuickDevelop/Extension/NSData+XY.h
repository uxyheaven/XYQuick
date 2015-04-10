//
//  NSData+XY.h
//  JoinShow
//
//  Created by Heaven on 13-10-16.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import "XYPrecompile.h"

@interface NSData (XY)

@property (nonatomic, readonly, strong) NSData * MD5Data;
@property (nonatomic, readonly, copy) NSString * MD5String;

@property (nonatomic, readonly, strong) NSData *SHA1Data;
@property (nonatomic, readonly, copy) NSString *SHA1String;

@property (nonatomic, readonly, copy) NSString *BASE64Encrypted;

@end
