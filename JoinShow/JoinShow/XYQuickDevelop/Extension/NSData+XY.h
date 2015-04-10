//
//  NSData+XY.h
//  JoinShow
//
//  Created by Heaven on 13-10-16.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import "XYPrecompile.h"

@interface NSData (XY)

@property (nonatomic, readonly, strong) NSData *uxyMD5Data;
@property (nonatomic, readonly, copy) NSString *uxyMD5String;

@property (nonatomic, readonly, strong) NSData *uxySHA1Data;
@property (nonatomic, readonly, copy) NSString *uxySHA1String;

@property (nonatomic, readonly, copy) NSString *uxyBASE64Encrypted;

@end
