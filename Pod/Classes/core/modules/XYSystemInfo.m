//
//  __  __          ____           _          _
//  \ \/ / /\_/\   /___ \  _   _  (_)   ___  | | __
//   \  /  \_ _/  //  / / | | | | | |  / __| | |/ /
//   /  \   / \  / \_/ /  | |_| | | | | (__  |   <
//  /_/\_\  \_/  \___,_\   \__,_| |_|  \___| |_|\_\
// //
//  Copyright (C) Heaven.
//
//	https://github.com/uxyheaven/XYQuick
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.
//
//  This file Copy from Samurai.

#import "XYSystemInfo.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import <ifaddrs.h>
#import <arpa/inet.h>

@interface XYSystemInfo ()
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@end

@implementation XYSystemInfo

static id __singleton__objc__token;
static dispatch_once_t __singleton__token__token;
+ (instancetype)sharedInstance
{
    dispatch_once(&__singleton__token__token, ^{ __singleton__objc__token = [[self alloc] init]; });
    return __singleton__objc__token;
}

+ (void)purgeSharedInstance
{
    __singleton__objc__token  = nil;
    __singleton__token__token = 0;
}

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
    NSArray *array = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleURLTypes"];
    for (NSDictionary *dict in array)
    {
        if (name)
        {
            NSString *URLName = [dict objectForKey:@"CFBundleURLName"];
            if (nil == URLName)
            {
                continue;
            }

            if (NO == [URLName isEqualToString:name])
            {
                continue;
            }
        }

        NSArray *URLSchemes = [dict objectForKey:@"CFBundleURLSchemes"];
        if (nil == URLSchemes || 0 == URLSchemes.count)
        {
            continue;
        }

        NSString *schema = [URLSchemes objectAtIndex:0];
        if (schema && schema.length)
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
    Class openUDID = NSClassFromString(@"OpenUDID");
    if (openUDID)
    {
        NSString * (*action)(id, SEL) = (NSString * (*)(id, SEL))objc_msgSend;
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
    static const char *__jb_apps[] =
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

    for (int i = 0; __jb_apps[i]; ++i)
    {
        if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithUTF8String:__jb_apps[i]]])
        {
            return YES;
        }
    }

    // method 2

    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/private/var/lib/apt/"])
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
    pid_t pid;
    int stat = posix_spawn(&pid, "ls", NULL, NULL, NULL, NULL);
    if (0 == stat)
    {
        return YES;
    }
    
//    if (0 == system("ls") )
//    {
//        return YES;
//    }

    //#endif
#endif  // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

    return NO;
}

- (BOOL)runningOnPhone
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    NSString *deviceType = [UIDevice currentDevice].model;
    if ([deviceType rangeOfString:@"iPhone"
                          options:NSCaseInsensitiveSearch].length > 0 ||
        [deviceType rangeOfString:@"iPod"
                          options:NSCaseInsensitiveSearch].length > 0 ||
        [deviceType rangeOfString:@"iTouch"
                          options:NSCaseInsensitiveSearch].length > 0)
    {
        return YES;
    }
#endif  // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

    return NO;
}

- (BOOL)runningOnPad
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    NSString *deviceType = [UIDevice currentDevice].model;
    if ([deviceType rangeOfString:@"iPad"
                          options:NSCaseInsensitiveSearch].length > 0)
    {
        return YES;
    }
#endif  // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

    return NO;
}

- (BOOL)requiresPhoneOS
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    return [[[NSBundle mainBundle].infoDictionary
             objectForKey:@"LSRequiresIPhoneOS"] boolValue];

#else
    return NO;
#endif
}

- (NSString *)localHost
{
    NSString *address          = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr  = NULL;
    int success                = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0)
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL)
        {
            if (temp_addr->ifa_addr->sa_family == AF_INET)
            {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
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

- (NSString *)netWorkState
{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children  = [[[app valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    NSString *state;
    int netType = 0;

    for (id child in children)
    {
        if (![child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")])
        {
            continue;
        }

        netType = [[child valueForKeyPath:@"dataNetworkType"] intValue];
        switch (netType)
        {
            case 0:
                state = @"无网络";
                break;
            case 1:
                state = @"2G";
                break;
            case 2:
                state = @"3G";
                break;
            case 3:
                state = @"4G";
                break;
            case 5:
                state = @"WIFI";
                break;
            default:
                state = @"error";
                break;
        }

        return state;
    }
    return @"error";
}

/*
   lo0       本地ip, 127.0.0.1
   en0       局域网ip, 192.168.1.23
   pdp_ip0   WWAN地址，即3G ip,
   bridge0   桥接、热点ip，172.20.10.1
 */
- (NSString *)deviceIPAdress
{
    struct ifaddrs *temp_addr  = NULL;
    NSString *address          = nil;
    struct ifaddrs *interfaces = NULL;
    int success                = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success != 0)
    {
        freeifaddrs(interfaces);
        return address;
    }

    temp_addr = interfaces;

    while (temp_addr != NULL)
    {
        // Check if interface is en0 which is the wifi connection on the iPhone
        if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"] || [[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"pdp_ip0"])
        {
            //如果是IPV4地址，直接转化
            if (temp_addr->ifa_addr->sa_family == AF_INET)
            {
                // Get NSString from C String
                address = [self __formatIPV4Address:((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr];
            }

            //如果是IPV6地址
            else if (temp_addr->ifa_addr->sa_family == AF_INET6)
            {
                address = [self __formatIPV6Address:((struct sockaddr_in6 *)temp_addr->ifa_addr)->sin6_addr];
                if (address && ![address isEqualToString:@""] && ![address.uppercaseString
                                                                   hasPrefix:@"FE80"])
                {
                    break;
                }
            }
        }

        temp_addr = temp_addr->ifa_next;
    }

    freeifaddrs(interfaces);

    return address;
}

//for IPV6
- (NSString *)__formatIPV6Address:(struct in6_addr)ipv6Addr
{
    NSString *address = nil;

    char dstStr[INET6_ADDRSTRLEN];
    char srcStr[INET6_ADDRSTRLEN];
    memcpy(srcStr, &ipv6Addr, sizeof(struct in6_addr));
    if (inet_ntop(AF_INET6, srcStr, dstStr, INET6_ADDRSTRLEN) != NULL)
    {
        address = [NSString stringWithUTF8String:dstStr];
    }

    return address;
}

//for IPV4
- (NSString *)__formatIPV4Address:(struct in_addr)ipv4Addr
{
    NSString *address = nil;

    char dstStr[INET_ADDRSTRLEN];
    char srcStr[INET_ADDRSTRLEN];
    memcpy(srcStr, &ipv4Addr, sizeof(struct in_addr));
    if (inet_ntop(AF_INET, srcStr, dstStr, INET_ADDRSTRLEN) != NULL)
    {
        address = [NSString stringWithUTF8String:dstStr];
    }

    return address;
}

#pragma mark- 屏幕相关
- (BOOL)isRetina
{
    return [UIScreen mainScreen].scale > 1;
}

- (BOOL)isScreenPhone
{
    if ([self isScreen320x480] || [self isScreen640x960] || [self isScreen640x1136] || [self isScreen750x1334] || [self isScreen1242x2208] || [self isScreen1125x2001])
    {
        return YES;
    }

    return NO;
}

- (BOOL)isScreen320x480
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    if ([self runningOnPad])
    {
        if ([self requiresPhoneOS] && [self isScreen768x1024])
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
    if ([self runningOnPad])
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
    if ([self runningOnPad])
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
    if ([self runningOnPad])
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
    if ([self runningOnPad])
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
    if ([self runningOnPad])
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
    if ([self isScreen768x1024] || [self isScreen1536x2048])
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
    CGSize size2      = CGSizeMake(size.height, size.width);
    CGSize screenSize = [UIScreen mainScreen].currentMode.size;

    if (CGSizeEqualToSize(size, screenSize) || CGSizeEqualToSize(size2, screenSize) )
    {
        return YES;
    }
#endif

    return NO;
}

- (BOOL)isScreenSizeSmallerThan:(CGSize)size
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    CGSize size2      = CGSizeMake(size.height, size.width);
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
    CGSize size2      = CGSizeMake(size.height, size.width);
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
    if ([[self osVersion] compare:ver] != NSOrderedDescending)
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
    if ([[self osVersion] compare:ver] != NSOrderedAscending)
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
    if (NSOrderedSame == [[self osVersion] compare:ver])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark- 启动相关
- (NSUserDefaults *)userDefaults
{
    if (_userDefaults == nil)
    {
        if ([[NSUserDefaults standardUserDefaults] respondsToSelector:@selector(initWithSuiteName:)])
        {
            _userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"firstrun"];
        }
        else
        {
            _userDefaults = [NSUserDefaults standardUserDefaults];
        }
    }
    return _userDefaults;
}

- (NSString *)__eventKeyWithUser:(NSString *)user event:(NSString *)event
{
    NSString *strUser  = user ? : @"uxyz";
    NSString *strEvent = event ? : @"uxye";

    return [NSString stringWithFormat:@"uxy_ver_%@_%@", strUser, strEvent];
}

- (BOOL)isFirstRunWithUser:(NSString *)user event:(NSString *)event
{
    return ([self.userDefaults
             valueForKey:[self __eventKeyWithUser:user
                                            event:event]] == nil);
}

- (BOOL)isFirstRunAtCurrentVersionWithUser:(NSString *)user event:(NSString *)event
{
    NSString *value = [self.userDefaults
                       valueForKey:[self __eventKeyWithUser:user
                                                      event:event]];

    return (value == nil) ? : ![value isEqualToString:[self bundleVersion]];
}

- (void)setFirstRun:(BOOL)isFirst user:(NSString *)user event:(NSString *)event
{
    if (isFirst)
    {
        [self.userDefaults
         removeObjectForKey:[self __eventKeyWithUser:user
                                               event:event]];
    }
    else
    {
        [self.userDefaults
         setObject:[self bundleVersion]
            forKey:[self __eventKeyWithUser:user
                                      event:event]];
    }

    [self.userDefaults synchronize];
}

@end
