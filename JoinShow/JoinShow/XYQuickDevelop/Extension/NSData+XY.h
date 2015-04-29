//
//  NSData+XY.h
//  JoinShow
//
//  Created by Heaven on 13-10-16.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (XY)

@property (nonatomic, readonly, strong) NSData *uxy_MD5Data;
@property (nonatomic, readonly, copy) NSString *uxy_MD5String;

@property (nonatomic, readonly, strong) NSData *uxy_SHA1Data;
@property (nonatomic, readonly, copy) NSString *uxy_SHA1String;

@property (nonatomic, readonly, copy) NSString *uxy_BASE64Encrypted;

@end
