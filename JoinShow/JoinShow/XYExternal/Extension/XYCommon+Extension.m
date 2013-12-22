//
//  XYFunction+Extension.m
//  JoinShow
//
//  Created by Heaven on 13-10-24.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import "XYCommon+Extension.h"
#import "XYExternal.h"
@implementation XYCommon (Extension)

/***************************************************************/
#if (1 == __USED_FMDatabase__)
+(BOOL) updateTable:(NSString *)tableName dbPath:(NSString *)dbPath object:(id)anObject{
    // NSString *path = [XYCommon dataFilePath:@"/BeeDatabase/TWP_SkyBookShelf.db" ofType:kCommon_dataFilePath_documents];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    [db open];
    
    //查询指定表的字段
    NSString *sql = [NSString stringWithFormat:@"pragma table_info(%@)", tableName];
    FMResultSet *rs = [db executeQuery:sql];
    NSMutableArray *columns = [NSMutableArray arrayWithCapacity:1];
    while ([rs next])
    {
        [columns addObject:[rs stringForColumn:@"name"]];
    }
    
    //当前model的属性集合
    NSMutableArray *newColumns = [NSMutableArray arrayWithArray:((NSObject *)anObject).attributeList];
    
    //新增属性个数
    int newColumnCount = newColumns.count - columns.count;
    
    //当新增属性大于0才进行更新，我勒个去，哥不判断属性名变更了，太麻烦了，不许给我随便更改model的属性名否则后果自负
    //因为父类有SQLiteID 所有判断个数的时候-1
    if (newColumnCount >= 0)
    {
        NSMutableSet *setA = [NSMutableSet setWithArray:columns];
        //最新的列
        NSMutableSet *setB = [NSMutableSet setWithArray:newColumns];
        //得到新增的属性
        [setB minusSet:setA];
        NSString *baseSQL = [NSString stringWithFormat:@"alter table '%@' add column", tableName];
        FMDatabase *database = db;
        //采用事务，暂时写不来单条语句插入多个列的
        [database beginTransaction];
        //回滚标识
        BOOL needRollBack = NO;
        for (NSString *newColumn in setB)
        {
            NSString *sql1 = [NSString stringWithFormat:@"%@ '%@' TEXT", baseSQL, newColumn];
            NSLog(@"sql = %@", sql1);
            needRollBack = ![database executeUpdate:sql1];
            if (needRollBack)
            {
                //回滚吧，少年
                [database rollback];
                return NO;
            }
        }
        [database commit];
    }
    [db close];
    
    return YES;
}
#endif

/***************************************************************/
#if (1 == __USED_MBProgressHUD__)
static MBProgressHUD *HUD = nil;
+(void) hiddenMBProgressHUD{
    [HUD hide:YES];
}

+(MBProgressHUD *) showMBProgressHUDTitle:(NSString *)aTitle msg:(NSString *)aMsg image:(UIImage *)aImg dimBG:(BOOL)dimBG delay:(float)d{
    UIViewController *vc = [self topMostController];
    if (nil == HUD) {
        HUD = [[MBProgressHUD alloc] initWithView:vc.view];
    }
    
    [vc.view addSubview:HUD];
    
    if (aImg)
    {
        UIImageView *img = [[UIImageView alloc] initWithImage:aImg];
        HUD.customView = img;
        HUD.mode = MBProgressHUDModeCustomView;
        [img release];
    }
    if (aTitle || aMsg) {
        HUD.mode = MBProgressHUDModeText;
        HUD.labelText = aTitle;
        HUD.detailsLabelText = aMsg;
    }
    
    HUD.removeFromSuperViewOnHide = YES;
    HUD.dimBackground = dimBG;
    [HUD show:YES];
    
    if (d > 0) {
        [HUD hide:YES afterDelay:d];
    }
    
    return HUD;
}

+(MBProgressHUD *) showMBProgressHUDModeIndeterminateTitle:(NSString *)aTitle msg:(NSString *)aMsg dimBG:(BOOL)dimBG{
    UIViewController *vc = [self topMostController];
    if (nil == HUD) {
        HUD = [[MBProgressHUD alloc] initWithView:vc.view];
    }
    [vc.view addSubview:HUD];
    
    HUD.labelText = aTitle;
    HUD.detailsLabelText = aMsg;
    HUD.removeFromSuperViewOnHide = YES;
    HUD.dimBackground = dimBG;
    [HUD show:YES];
    
    return HUD;
}

+(MBProgressHUD *) showMBProgressHUDTitle:(NSString *)aTitle msg:(NSString *)aMsg dimBG:(BOOL)dimBG executeBlock:(void(^)(MBProgressHUD *hud))blockE finishBlock:(void(^)(void))blockF{
    UIViewController *vc = [self topMostController];
    if (nil == HUD) {
        HUD = [[MBProgressHUD alloc] initWithView:vc.view];
    }
    
    [vc.view addSubview:HUD];
    
    HUD.labelText = aTitle;
    HUD.detailsLabelText = aMsg;
    HUD.removeFromSuperViewOnHide = YES;
    HUD.dimBackground = dimBG;
    [HUD showAnimated:YES whileExecutingBlock:^{
		blockE(HUD);
	} completionBlock:^{
		//[hud hide:YES];
        blockF();
	}];
    
    return HUD;
}
#endif

/***************************************************************/
#if (1 ==  __USED_ASIHTTPRequest__)
+(ASIHTTPRequest *) startAsynchronousRequestWithURLString:(NSString *)str
                                                  succeed:(void (^)(ASIHTTPRequest *request))blockS
                                                   failed:(void (^)(NSError *error))blockF{
    NSURL *link = [NSURL URLWithString:str];
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:link];
    request.timeOutSeconds = 10;
    [request setCompletionBlock:^{
        if (blockS) {
            blockS(request);
        }
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        if (blockF) {
            blockF(error);
        }
    }];
    [request startAsynchronous];
    
    return request;
}
#endif

/***************************************************************/
#if (1 ==  __USED_ASIHTTPRequest__)
+(void) checkUpdateInAppStore:(NSString *)appID curVersion:(NSString *)aVersion appURLString:(NSString *)strURL
                         same:(void(^)(void))blockSame
                    stayStill:(void(^)(void))blockStayStill{
    [self checkUpdateInAppStore:appID curVersion:aVersion
                           same:blockSame localIsOld:^(NSString *appStoreVersion) {
                               NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
                               NSString *appName = [infoDict objectForKey:@"CFBundleDisplayName"];
                               NSString *msg = [NSString stringWithFormat:@"There is a new update available for the %@ (v%@),  would you like to download from the App Store now ?", appName, appStoreVersion];
                               
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message"
                                                                               message:msg
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"Cancel"
                                                                     otherButtonTitles:@"Update",nil];
                               [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
                                   if (buttonIndex == 0) {
                                       if (blockStayStill) {
                                           blockStayStill();
                                       }
                                   }else if (buttonIndex == 1){
                                       [self openURL:[NSURL URLWithString:strURL]];
                                   }
                               }];
                           }];
}
+(void) checkUpdateInAppStore:(NSString *)appID curVersion:(NSString *)aVersion
                         same:(void(^)(void))blockSame
                   localIsOld:(void(^)(NSString *appStoreVersion))blockLocalIsOld{
    NSURL *appleLink = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", appID]];
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:appleLink];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    request.timeOutSeconds = 10;
    [request setCompletionBlock:^{
        NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
        NSString *str = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
        
        NSRange range = [self rangeOfString:str pointStart:0 start:@":\"" end:@"\"," mark:@"\"version\"" operation:markOption_front];
        NSString *versionAppStore = [str substringWithRange:NSMakeRange(range.location + 2, range.length -4)];
        NSString *localVersion;
        if (aVersion == nil) {
            localVersion = [infoDict objectForKey:@"CFBundleVersion"];
        }else{
            localVersion = aVersion;
        }
        
        BOOL b = [self compareVersionFromOldVersion:localVersion newVersion:versionAppStore];
        
        if (b) {
            if (blockLocalIsOld) {
                blockLocalIsOld(versionAppStore);
            }
        }else{
            if (blockSame) {
                blockSame();
            }
        }
        
    }];
    [request setFailedBlock:^{
        if (blockSame) {
            blockSame();
        }
    }];
    [request startAsynchronous];
}
#endif

@end
