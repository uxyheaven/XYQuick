//
//  XYAutoCoding.h
//  JoinShow
//
//  Created by Heaven on 14/10/31.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYAutoCoding : NSObject

@end

#pragma mark- category AutoCoding
// copy frome https://github.com/nicklockwood/AutoCoding
// 序列化 2.2
//
@interface NSObject (AutoCoding) <NSSecureCoding>

//coding

+ (NSDictionary *)codableProperties;
- (void)setWithCoder:(NSCoder *)aDecoder;

//property access

- (NSDictionary *)codableProperties;
- (NSDictionary *)dictionaryRepresentation;

//loading / saving
+ (instancetype)objectWithContentsOfFile:(NSString *)path;
- (BOOL)writeToFile:(NSString *)filePath atomically:(BOOL)useAuxiliaryFile;

@end