//
//  XYReachability.h
//  JoinShow
//
//  Created by XingYao on 15/4/12.
//  Copyright (c) 2015年 Heaven. All rights reserved.
//  Copy from https://github.com/tonymillion/Reachability 2015-04-21

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "XYQuick_Predefine.h"

// 通知
extern NSString *const XYNotification_ReachabilityChanged;

#ifndef NS_ENUM
#define NS_ENUM(_type, _name) enum _name : _type _name; enum _name : _type
#endif

typedef NS_ENUM(NSInteger, XYNetworkStatus) {
    // Apple NetworkStatus Compatible Names.
    XYNotReachable = 0,
    XYReachableViaWiFi = 2,
    XYReachableViaWWAN = 1
};

@class XYReachability;

typedef void (^XYNetworkReachable)(XYReachability * reachability);
typedef void (^XYNetworkUnreachable)(XYReachability * reachability);


@interface XYReachability : NSObject

@property (nonatomic, copy) XYNetworkReachable    reachableBlock;   //  this is called on a background thread
@property (nonatomic, copy) XYNetworkUnreachable  unreachableBlock; //  this is called on a background thread

@property (nonatomic, assign) BOOL reachableOnWWAN;


+(instancetype)reachabilityWithHostname:(NSString*)hostname;
// This is identical to the function above, but is here to maintain
//compatibility with Apples original code. (see .m)
+(instancetype)reachabilityWithHostName:(NSString*)hostname;
+(instancetype)reachabilityForInternetConnection;
+(instancetype)reachabilityWithAddress:(void *)hostAddress;
+(instancetype)reachabilityForLocalWiFi;

-(instancetype)initWithReachabilityRef:(SCNetworkReachabilityRef)ref;

-(BOOL)startNotifier;
-(void)stopNotifier;

-(BOOL)isReachable;
-(BOOL)isReachableViaWWAN;
-(BOOL)isReachableViaWiFi;

// WWAN may be available, but not active until a connection has been established.
// WiFi may require a connection for VPN on Demand.
-(BOOL)isConnectionRequired; // Identical DDG variant.
-(BOOL)connectionRequired; // Apple's routine.
// Dynamic, on demand connection?
-(BOOL)isConnectionOnDemand;
// Is user intervention required?
-(BOOL)isInterventionRequired;

-(XYNetworkStatus)currentReachabilityStatus;
-(SCNetworkReachabilityFlags)reachabilityFlags;
-(NSString*)currentReachabilityString;
-(NSString*)currentReachabilityFlags;

@end

