//
//  XYKeychain.h
//  JoinShow
//
//  Created by Heaven on 14-1-21.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import "XYPrecompile.h"
#import "XYCacheProtocol.h"

@interface XYKeychain : NSObject <XYCacheProtocol>

@property (nonatomic, copy) NSString * defaultDomain;

AS_SINGLETON( XYKeychain );

+ (void)setDefaultDomain:(NSString *)domain;

+ (NSString *)readValueForKey:(NSString *)key;
+ (NSString *)readValueForKey:(NSString *)key andDomain:(NSString *)domain;

+ (void)writeValue:(NSString *)value forKey:(NSString *)key;
+ (void)writeValue:(NSString *)value forKey:(NSString *)key andDomain:(NSString *)domain;

+ (void)deleteValueForKey:(NSString *)key;
+ (void)deleteValueForKey:(NSString *)key andDomain:(NSString *)domain;

@end

@interface NSObject(XYKeychain)

+ (NSString *)keychainRead:(NSString *)key;
+ (void)keychainWrite:(NSString *)value forKey:(NSString *)key;
+ (void)keychainDelete:(NSString *)key;

- (NSString *)keychainRead:(NSString *)key;
- (void)keychainWrite:(NSString *)value forKey:(NSString *)key;
- (void)keychainDelete:(NSString *)key;

@end
