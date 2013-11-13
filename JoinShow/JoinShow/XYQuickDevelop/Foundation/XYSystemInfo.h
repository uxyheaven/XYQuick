//
//  XYSystemInfo.h
//  JoinShow
//
//  Created by Heaven on 13-9-23.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//
//  Copy from bee Framework

// 系统信息

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
#undef IOS7_OR_LATER
#define IOS7_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
#undef IOS6_OR_LATER
#define IOS6_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"6.0"] != NSOrderedAscending )
#undef IOS5_OR_LATER
#define IOS5_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"5.0"] != NSOrderedAscending )
#undef IOS4_OR_LATER
#define IOS4_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"4.0"] != NSOrderedAscending )
#undef IOS3_OR_LATER
#define IOS3_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"3.0"] != NSOrderedAscending )

#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
#undef IOS6_OR_LATER
#define IOS6_OR_LATER	(NO)
#undef IOS5_OR_LATER
#define IOS5_OR_LATER	(NO)
#undef IOS6_OR_LATER
#define IOS4_OR_LATER	(NO)
#undef IOS3_OR_LATER
#define IOS3_OR_LATER	(NO)

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#undef Screen_WIDTH
#define Screen_WIDTH   [[UIScreen mainScreen] bounds].size.width
#undef Screen_HEIGHT
#define Screen_HEIGHT  [[UIScreen mainScreen] bounds].size.height

#import "XYPrecompile.h"

@interface XYSystemInfo : NSObject

+(NSString *) OSVersion;
+(NSString *) appVersion;
+(NSString *) appIdentifier;
+(NSString *) deviceModel;
+(NSString *) deviceUUID;

// 是否越狱
+(BOOL) isJailBroken		NS_AVAILABLE_IOS(4_0);
+(NSString *) jailBreaker	NS_AVAILABLE_IOS(4_0);

+(BOOL) isDevicePhone;
+(BOOL) isDevicePad;

+(BOOL) isPhone35;
+(BOOL) isPhoneRetina35;
+(BOOL) isPhoneRetina4;
+(BOOL) isPad;
+(BOOL) isPadRetina;
+(BOOL) isScreenSize:(CGSize)size;

//////////////////////////////
+(NSString *) localHost;
@end
