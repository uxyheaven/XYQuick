//
//  XYFileCache.h
//  JoinShow
//
//  Created by Heaven on 14-1-17.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import "XYPrecompile.h"
#import "XYCacheProtocol.h"

@interface XYFileCache : NSObject

@property (nonatomic, retain) NSString *	cachePath;
@property (nonatomic, retain) NSString *	cacheUser;

XY_SINGLETON( XYFileCache );

- (NSString *)fileNameForKey:(NSString *)key;

@end
