//
//  XYSystemInfo.m
//  JoinShow
//
//  Created by Heaven on 13-9-23.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import "XYSystemInfo.h"

@implementation XYSystemInfo __DEF_SINGLETON

- (NSString *)osVersion
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    return [NSString stringWithFormat:@"%@ %@", [UIDevice currentDevice].systemName, [UIDevice currentDevice].systemVersion];
#else
    return nil;
#endif
}

- (NSString *)bundleVersion
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR || TARGET_OS_MAC)
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
#else
    return nil;
#endif
}

- (NSString *)bundleShortVersion
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR || TARGET_OS_MAC)
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
#else
    return nil;
#endif
}

- (NSString *)bundleIdentifier
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
#else
    return nil;
#endif
}

- (NSString *)urlSchema
{
    return [self urlSchemaWithName:nil];
}

- (NSString *)urlSchemaWithName:(NSString *)name
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    
    NSArray * array = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleURLTypes"];
    for ( NSDictionary * dict in array )
    {
        if ( name )
        {
            NSString * URLName = [dict objectForKey:@"CFBundleURLName"];
            if ( nil == URLName )
            {
                continue;
            }
            
            if ( NO == [URLName isEqualToString:name] )
            {
                continue;
            }
        }
        
        NSArray * URLSchemes = [dict objectForKey:@"CFBundleURLSchemes"];
        if ( nil == URLSchemes || 0 == URLSchemes.count )
        {
            continue;
        }
        
        NSString * schema = [URLSchemes objectAtIndex:0];
        if ( schema && schema.length )
        {
            return schema;
        }
    }
    
    return nil;
    
#else
    
    return nil;
    
#endif
}

- (NSString *)deviceModel
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    return [UIDevice currentDevice].model;
#else
    return nil;
#endif
}

- (NSString *)deviceUUID
{
    Class openUDID = NSClassFromString( @"OpenUDID" );
    if ( openUDID )
    {
        NSString * (*action)(id, SEL) = (NSString * (*)(id, SEL)) objc_msgSend;
        return action(openUDID, @selector(value));
    }
    else
    {
        return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    }
}

- (BOOL)isJailBroken
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    
    static const char * __jb_apps[] =
    {
        "/Application/Cydia.app",
        "/Application/limera1n.app",
        "/Application/greenpois0n.app",
        "/Application/blackra1n.app",
        "/Application/blacksn0w.app",
        "/Application/redsn0w.app",
        NULL
    };
    
    // method 1
    
    for ( int i = 0; __jb_apps[i]; ++i )
    {
        if ( [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithUTF8String:__jb_apps[i]]] )
        {
            return YES;
        }
    }
    
    // method 2
    
    if ( [[NSFileManager defaultManager] fileExistsAtPath:@"/private/var/lib/apt/"] )
    {
        return YES;
    }
    
    // method 3
    
    //#ifdef __IPHONE_8_0
    //
    //	if ( 0 == posix_spawn("ls") )
    //	{
    //		return YES;
    //	}
    //
    //#else
    
    if ( 0 == system("ls") )
    {
        return YES;
    }
    
    //#endif
    
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    
    return NO;
}

- (BOOL)runningOnPhone
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    
    NSString * deviceType = [UIDevice currentDevice].model;
    if ( [deviceType rangeOfString:@"iPhone" options:NSCaseInsensitiveSearch].length > 0 ||
        [deviceType rangeOfString:@"iPod" options:NSCaseInsensitiveSearch].length > 0 ||
        [deviceType rangeOfString:@"iTouch" options:NSCaseInsensitiveSearch].length > 0 )
    {
        return YES;
    }
    
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    
    return NO;
}

- (BOOL)runningOnPad
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    
    NSString * deviceType = [UIDevice currentDevice].model;
    if ( [deviceType rangeOfString:@"iPad" options:NSCaseInsensitiveSearch].length > 0 )
    {
        return YES;
    }
    
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    
    return NO;
}

- (BOOL)requiresPhoneOS
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    
    return [[[NSBundle mainBundle].infoDictionary objectForKey:@"LSRequiresIPhoneOS"] boolValue];
    
#else
    
    return NO;
    
#endif
}
- (NSString *)localHost
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0)
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL)
        {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
}

#pragma mark- 屏幕相关
- (BOOL)isRetina
{
    return [UIScreen mainScreen].scale > 1;
}
- (BOOL)isScreenPhone
{
	if ( [self isScreen320x480] || [self isScreen640x960] || [self isScreen640x1136] || [self isScreen750x1334] || [self isScreen1242x2208] || [self isScreen1125x2001] )
    {
        return YES;
    }
    
    return NO;
}

- (BOOL)isScreen320x480
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    
    if ( [self runningOnPad] )
    {
        if ( [self requiresPhoneOS] && [self isScreen768x1024] )
        {
            return YES;
        }
        
        return NO;
    }
    else
    {
        return [self isScreenSizeEqualTo:CGSizeMake(320, 480)];
    }
    
#endif
    
    return NO;
}

- (BOOL)isScreen640x960
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    
    if ( [self runningOnPad] )
    {
        return NO;
    }
    else
    {
        return [self isScreenSizeEqualTo:CGSizeMake(640, 960)];
    }
    
#endif
    
    return NO;
}

- (BOOL)isScreen640x1136
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    
    if ( [self runningOnPad] )
    {
        return NO;
    }
    else
    {
        return [self isScreenSizeEqualTo:CGSizeMake(640, 1136)];
    }
    
#endif
    
    return NO;
}

- (BOOL)isScreen750x1334
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    
    if ( [self runningOnPad] )
    {
        return NO;
    }
    else
    {
        return [self isScreenSizeEqualTo:CGSizeMake(750, 1334)];
    }
    
#endif
    
    return NO;
}

- (BOOL)isScreen1242x2208
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    
    if ( [self runningOnPad] )
    {
        return NO;
    }
    else
    {
        return [self isScreenSizeEqualTo:CGSizeMake(1242, 2208)];
    }
    
#endif
    
    return NO;
}

- (BOOL)isScreen1125x2001
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    
    if ( [self runningOnPad] )
    {
        return NO;
    }
    else
    {
        return [self isScreenSizeEqualTo:CGSizeMake(1125, 2001)];
    }
    
#endif
    
    return NO;
}

- (BOOL)isScreenPad
{
    if ( [self isScreen768x1024] || [self isScreen1536x2048] )
    {
        return YES;
    }
    
    return NO;
}

- (BOOL)isScreen768x1024
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    
    return [self isScreenSizeEqualTo:CGSizeMake(768, 1024)];
    
#endif
    
    return NO;
}

- (BOOL)isScreen1536x2048
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    
    return [self isScreenSizeEqualTo:CGSizeMake(1536, 2048)];
    
#endif
    
    return NO;
}

- (CGSize)screenSize
{
    return [UIScreen mainScreen].currentMode.size;
}

- (BOOL)isScreenSizeEqualTo:(CGSize)size
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    
    CGSize size2 = CGSizeMake( size.height, size.width );
    CGSize screenSize = [UIScreen mainScreen].currentMode.size;
    
    if ( CGSizeEqualToSize(size, screenSize) || CGSizeEqualToSize(size2, screenSize) )
    {
        return YES;
    }
    
#endif
    
    return NO;
}
- (BOOL)isScreenSizeSmallerThan:(CGSize)size
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    
    CGSize size2 = CGSizeMake( size.height, size.width );
    CGSize screenSize = [UIScreen mainScreen].currentMode.size;
    
    if ( (size.width > screenSize.width && size.height > screenSize.height) ||
        (size2.width > screenSize.width && size2.height > screenSize.height) )
    {
        return YES;
    }
    
#endif
    
    return NO;
}

- (BOOL)isScreenSizeBiggerThan:(CGSize)size
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    
    CGSize size2 = CGSizeMake( size.height, size.width );
    CGSize screenSize = [UIScreen mainScreen].currentMode.size;
    
    if ( (size.width < screenSize.width && size.height < screenSize.height) ||
        (size2.width < screenSize.width && size2.height < screenSize.height) )
    {
        return YES;
    }
    
#endif
    
    return NO;
}

#pragma mark- 版本判断相关
- (BOOL)isOsVersionOrEarlier:(NSString *)ver
{
    if ( [[self osVersion] compare:ver] != NSOrderedDescending )
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)isOsVersionOrLater:(NSString *)ver
{
    if ( [[self osVersion] compare:ver] != NSOrderedAscending )
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)isOsVersionEqualTo:(NSString *)ver
{
    if ( NSOrderedSame == [[self osVersion] compare:ver] )
    {
        return YES;
    }
    else
    {
        return NO;
    }	
}

#pragma mark- 启动相关
- (NSUserDefaults *)__userDefaults
{
   return [[NSUserDefaults alloc] initWithSuiteName:@"firstrun"];
}

- (NSString *)__eventKeyWithUser:(NSString *)user event:(NSString *)event
{
    NSString *strUser  = user ?: @"uxyz";
    NSString *strEvent = event ?: @"uxye";
    
    return [NSString stringWithFormat:@"uxy_ver_%@_%@", strUser, strEvent];
}


- (BOOL)isFirstRunWithUser:(NSString *)user event:(NSString *)event
{
    return ([self.__userDefaults valueForKey:[self __eventKeyWithUser:user event:event]] == nil);
}

- (BOOL)isFirstRunAtCurrentVersionWithUser:(NSString *)user event:(NSString *)event
{
    NSString *value = [self.__userDefaults valueForKey:[self __eventKeyWithUser:user event:event]];
    
    if (value)
    {
        return YES;
    }
    else
    {
        return [value isEqualToString:[self bundleVersion]];
    }
}

- (void)resetFirstRun:(BOOL)isFirst user:(NSString *)user event:(NSString *)event
{
    if (isFirst)
    {
        [self.__userDefaults removeObjectForKey:[self __eventKeyWithUser:user event:event]];
    }
    else
    {
        [self.__userDefaults setObject:[self bundleVersion] forKey:[self __eventKeyWithUser:user event:event]];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
