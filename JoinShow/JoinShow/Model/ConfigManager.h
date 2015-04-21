//
//  ConfigManager.h
//  JoinShow
//
//  Created by Heaven on 13-9-10.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#if (1 == __XYQuick_Framework__)
#import <XYQuick/XYQuickDevelop.h>
#else
#import "XYQuickDevelop.h"
#endif

#import "XYPredefine.h"

@interface ConfigManager : NSObject __AS_SINGLETON

@property (nonatomic,  strong) NSString *StrTest;

@end
