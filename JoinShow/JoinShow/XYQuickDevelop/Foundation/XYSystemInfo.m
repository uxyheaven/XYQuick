//
//  XYSystemInfo.m
//  JoinShow
//
//  Created by Heaven on 13-9-23.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import "XYSystemInfo.h"

#pragma mark- todo 待优化
/*
static NSUInteger DeviceSystemMajorVersion();
static NSUInteger DeviceSystemMajorVersion() {
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
    });
    return _deviceSystemMajorVersion;
}*/


@implementation XYSystemInfo

+ (NSString *)OSVersion
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return [NSString stringWithFormat:@"%@ %@", [UIDevice currentDevice].systemName, [UIDevice currentDevice].systemVersion];
#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return nil;
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}

+ (NSString *)appVersion
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR || TARGET_OS_MAC)
	NSString * value = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
	if ( nil == value || 0 == value.length )
	{
		value = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersion"];
	}
	return value;
#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return nil;
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}

+ (NSString *)appIdentifier
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	static NSString * __identifier = nil;
	if ( nil == __identifier )
	{
		__identifier = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"] retain];
	}
	return __identifier;
#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return @"";
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}

+ (NSString *)deviceModel
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return [UIDevice currentDevice].model;
#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return nil;
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}

+ (NSString *)deviceUUID
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR || TARGET_OS_MAC)
	Class openUDID = NSClassFromString( @"OpenUDID" );
	if ( openUDID )
	{
		return [openUDID value];
	}
	else
	{
		return nil; // [UIDevice currentDevice].uniqueIdentifier;
	}
#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return nil;
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
static const char * __jb_app = NULL;
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

+ (BOOL)isJailBroken NS_AVAILABLE_IOS(4_0)
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
    
	__jb_app = NULL;
    
	// method 1
    for ( int i = 0; __jb_apps[i]; ++i )
    {
        if ( [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithUTF8String:__jb_apps[i]]] )
        {
			__jb_app = __jb_apps[i];
			return YES;
        }
    }
	
    // method 2
	if ( [[NSFileManager defaultManager] fileExistsAtPath:@"/private/var/lib/apt/"] )
	{
		return YES;
	}
	
	// method 3
	if ( 0 == system("ls") )
	{
		return YES;
	}
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	
    return NO;
}

+ (NSString *)jailBreaker NS_AVAILABLE_IOS(4_0)
{
#if (TARGET_OS_IPHONE)
	if ( __jb_app )
	{
		return [NSString stringWithUTF8String:__jb_app];
	}
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    
	return @"";
}

+ (BOOL)isDevicePhone
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

+ (BOOL)isDevicePad
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

+ (BOOL)isPhone35
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return [XYSystemInfo isScreenSize:CGSizeMake(320, 480)];
#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return NO;
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}

+ (BOOL)isPhoneRetina35
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return [XYSystemInfo isScreenSize:CGSizeMake(640, 960)];
#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return NO;
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}

+ (BOOL)isPhoneRetina4
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return [XYSystemInfo isScreenSize:CGSizeMake(640, 1136)];
#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return NO;
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}

+ (BOOL)isPad
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return [XYSystemInfo isScreenSize:CGSizeMake(768, 1024)];
#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return NO;
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}

+ (BOOL)isPadRetina
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return [XYSystemInfo isScreenSize:CGSizeMake(1536, 2048)];
#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return NO;
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}

+ (BOOL)isScreenSize:(CGSize)size
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	if ( [UIScreen instancesRespondToSelector:@selector(currentMode)] )
	{
		CGSize screenSize = [UIScreen mainScreen].currentMode.size;
		CGSize size2 = CGSizeMake( size.height, size.width );
        
		if ( CGSizeEqualToSize(size, screenSize) || CGSizeEqualToSize(size2, screenSize) )
		{
			return YES;
		}
	}
	
	return NO;
#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return NO;
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}
+(NSString *) localHost{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
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
@end
