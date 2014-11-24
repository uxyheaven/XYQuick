//
//  XYFunction.m
//  TWP_SkyBookShelf
//
//  Created by Heaven on 13-7-10.
//
//

#import "XYCommon.h"

@implementation XYCommon
{
    
}
/***************************************************************/
+ (NSString *) dataFilePath:(NSString *)file ofType:(FilePathOption)kType
{
    NSString *pathFile = nil;
    switch (kType)
    {
        case filePathOption_documents:
        {
            // NSDocumentDirectory代表查找Documents路径,NSUserDomainMask代表在应用程序沙盒下找
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            // ios下Documents文件夹只有一个
            NSString *documentsDirectory = [paths objectAtIndex:0];
            pathFile = [documentsDirectory stringByAppendingPathComponent:file];
            break;
        }
        case filePathOption_tmp:
        {
            NSString *str = NSTemporaryDirectory();
            //    NSLog(@"%@", str);
            pathFile = [str stringByAppendingPathComponent:file];
            break;
        }
        case filePathOption_app:
        case filePathOption_resource:
        {
            // 获得文件名
            NSString *str =[file stringByDeletingPathExtension];
            // 获得文件扩展路径
            NSString *str2 = [file pathExtension];
            pathFile = [[NSBundle mainBundle] pathForResource:str ofType:str2];
            break;
        }
        default:
            break;
    }
    
    return pathFile;
}
// 程序目录，不能存任何东西
+ (NSString *)dataFileAppPath:(NSString *)file{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSUserDomainMask, YES);
	
    if (file)
    {
        return [NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0], file];
    }
    else
    {
        return [paths objectAtIndex:0];
    }
}
// 文档目录，需要ITUNES同步备份的数据存这里
+ (NSString *)dataFileDocPath:(NSString *)file{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if (file)
    {
        return [NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0], file];
    }
    else
    {
        return [paths objectAtIndex:0];
    }
}
// 配置目录，配置文件存这里
+ (NSString *)dataFileLibPrefPath:(NSString *)file{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    if (file)
    {
        return [NSString stringWithFormat:@"%@/Preference/%@",[paths objectAtIndex:0], file];
    }
    else
    {
        return [[paths objectAtIndex:0] stringByAppendingFormat:@"/Preference"];
    }
}
// 缓存目录，系统永远不会删除这里的文件，ITUNES会删除
+ (NSString *)dataFileLibCachePath:(NSString *)file
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    if (file)
    {
        return [NSString stringWithFormat:@"%@/Caches/%@",[paths objectAtIndex:0], file];
    }
    else
    {
        return [[paths objectAtIndex:0] stringByAppendingFormat:@"/Caches"];
    }
}
// 缓存目录，APP退出后，系统可能会删除这里的内容
+ (NSString *) dataFileTmpPath:(NSString *)file
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    if (file)
    {
        return [NSString stringWithFormat:@"%@/tmp/%@",[paths objectAtIndex:0], file];
    }
    else
    {
        return [[paths objectAtIndex:0] stringByAppendingFormat:@"/tmp"];
    }
}
/***************************************************************/
+ (void)createDirectoryAtPath:(NSString *)aPath{
    if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:aPath isDirectory:NULL] )
    {
        BOOL ret = [[NSFileManager defaultManager] createDirectoryAtPath:aPath
                                             withIntermediateDirectories:YES
                                                              attributes:nil
                                                                   error:nil];
        if ( NO == ret )
        {
            NSLogD(@"%s, create %@ failed", __PRETTY_FUNCTION__, aPath);
            return;
        }
    }
}
/***************************************************************/
+ (NSString *) replaceUnicode:(NSString *)unicodeStr
{
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    //  NSLog(@"%@",returnStr);
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}

/***************************************************************/
+ (NSRange) rangeOfString:(NSString *)str pointStart:(int)iStart start:(NSString *)strStart end:(NSString *)strEnd mark:(NSString *)strMark operation:(MarkOption)operation;
{
    int option = 0;
    NSRange rangeMark = {0, 0};
    NSRange rangeMarkA = {0, 0};
    
    rangeMark.location = iStart;
    rangeMark.length = str.length - iStart;
    
    rangeMark = [str rangeOfString:strMark options:NSLiteralSearch range:rangeMark];
    if(rangeMark.length == 0)
        return rangeMark;
    
    switch (operation)
    {
        case MarkOption_middle:
            rangeMarkA.location = iStart;
            rangeMarkA.length = rangeMark.location + rangeMark.length - iStart;
            option = NSBackwardsSearch;
            break;
        case MarkOption_front:
            rangeMarkA.location = rangeMark.location;
            rangeMarkA.length = str.length - rangeMark.location;
            option = NSLiteralSearch;
            break;
        case MarkOption_back:
            rangeMarkA.location = iStart;
            rangeMarkA.length = rangeMark.location + rangeMark.length - iStart;
            option = NSBackwardsSearch;
        default:
            break;
    }
    rangeMarkA = [str rangeOfString:strStart options:option range:rangeMarkA];
    if(rangeMarkA.length == 0)
        return rangeMarkA;
    
    NSRange rangeMarkB = NSMakeRange(0, 0);
    switch (operation)
    {
        case MarkOption_middle:
            rangeMarkB.length = str.length - rangeMark.location;
            rangeMarkB.location = rangeMark.location;
            break;
        case MarkOption_front:
            rangeMarkB.length = str.length - rangeMarkA.location - rangeMarkA.length;
            rangeMarkB.location = rangeMarkA.location + rangeMarkA.length;
            break;
        case MarkOption_back:
            rangeMarkB.length = rangeMark.location - rangeMarkA.location -rangeMarkA.length;
            rangeMarkB.location = rangeMarkA.location + rangeMarkA.length;
        default:
            break;
    }
    
    rangeMarkB = [str rangeOfString:strEnd options:NSLiteralSearch range:rangeMarkB];
    if(rangeMarkB.length == 0)
        return rangeMarkB;
    
    NSRange rangeTmp;
    rangeTmp.location = rangeMarkA.location;
    rangeTmp.length = rangeMarkB.location - rangeMarkA.location + rangeMarkB.length;
    
    return rangeTmp;
}

+ (NSRange) rangeOfString:(NSString *)str pointStart:(int)iStart start:(NSString *)strStart end:(NSString *)strEnd operation:(int)operation;
{
    // NSString *strMark = nil;
    NSRange rangeMark;
    return rangeMark;
}
+ (NSMutableArray *) rangeArrayOfString:(NSString *)str pointStart:(int)iStart start:(NSString *)strStart end:(NSString *)strEnd mark:(NSString *)strMark operation:(MarkOption)operation
{
    return [XYCommon rangeArrayOfString:str pointStart:iStart start:strStart end:strEnd mark:strMark operation:operation everyStringExecuteBlock:nil];
}
+ (NSMutableArray *) rangeArrayOfString:(NSString *)str pointStart:(int)iStart start:(NSString *)strStart end:(NSString *)strEnd mark:(NSString *)strMark operation:(MarkOption)operation everyStringExecuteBlock:(void(^)(NSRange rangeEvery))block
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    int i = 0;
    while (i != -1)
    {
        NSRange range = [self rangeOfString:str pointStart:i start:strStart end:strEnd mark:strMark operation:operation];
        if(range.length == 0) break;
        [array addObject:[NSValue valueWithRange:range]];
        if (block)
        {
            // NSString *tmpStr = [str substringWithRange:range];
            block(range);
        }
        i = range.location + range.length;
    }
    
    return array;
}
/***************************************************************/
+ (NSString *) getValueInANonAttributeXMLNode:(NSString *)str key:(NSString *)akey location:(int)location{
    NSString *str1 = [NSString stringWithFormat:@"<%@>", akey];
    NSString *str2 = [NSString stringWithFormat:@"</%@>", akey];
    static int i = 0;
    if (XYCommon_lastLocation == location)
    {
        //   NSLogD(@"%s,%d", __FUNCTION__, str.length - akey.length*2);
        if (i > (str.length - akey.length*2))
        {
           i = 0;
        }
    }
    else
    {
       i = location;
    }
    
    NSRange range = [XYCommon rangeOfString:str pointStart:i start:str1 end:str2 mark:str1 operation:MarkOption_middle];
#pragma mark- 待优化
    if (0 == range.length)
    {
        i = 0;
        range = [XYCommon rangeOfString:str pointStart:i start:str1 end:str2 mark:str1 operation:MarkOption_middle];
    }
    
    if (0 == range.length)
        return nil;
    
    i = range.location +range.length;
    range.location = range.location + str1.length;
    range.length = range.length - str1.length -str2.length;
    
    NSString *tmp = [str substringWithRange:range];
#pragma mark - 如果没有 返回空格
    if (tmp == nil)
        tmp = @" ";
    
    return tmp;
}


/***************************************************************/
+ (NSMutableArray *)analyseString:(NSString *)str regularExpression:(NSString *)regexStr
{
    NSMutableArray *arrayA = [self analyseStringToRange:str regularExpression:regexStr];
    NSMutableArray *arrayStr = [[NSMutableArray alloc] init];
    
    for (NSValue *value in arrayA)
    {
        NSRange range = [value rangeValue];
        NSString *tmpString = [str substringWithRange:range];
        //NSLogD(@"->%@<-",result);
        [arrayStr addObject:tmpString];
    }
    
    return arrayStr;
}
+ (NSMutableArray *)analyseStringToRange:(NSString *)str regularExpression:(NSString *)regexStr
{
    NSMutableArray *arrayA = [[NSMutableArray alloc] init];
    
    //NSRegularExpression类里面调用表达的方法需要传递一个NSError的参数。下面定义一个
	NSError *error;
    // \\d*\\.?\\d+匹配浮点
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:0 error:&error];
    if (regex != nil)
    {
        NSArray *matchs=[regex matchesInString:str options:0 range:NSMakeRange(0, [str length])];
        
        for (NSTextCheckingResult *match in matchs)
        {
            if (match)
            {
                NSRange resultRange = [match rangeAtIndex:0];
                
                //从str当中截取数据
                // NSString *result=[str substringWithRange:resultRange];
                [arrayA addObject:[NSValue valueWithRange:resultRange]];
                //输出结果
                //NSLogD(@"->%@<-",result);
            }
        }
    }
    
    return arrayA;
}

/***************************************************************/
+ (void)shareToTwitterWithStr:(NSString *)strText withPicPath:(NSString *)picPath withURL:(NSString*)strURL inController:(id)vc
{
    /* 本项目屏蔽
     if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
     {
     SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
     [tweetSheet setInitialText:@"Tweeting from my own app! :)"];
     if (picPath) [tweetSheet addImage:[UIImage imageWithContentsOfFile:picPath]];
     if (strText) [tweetSheet setInitialText:strText];
     if (strURL) [tweetSheet addURL:[NSURL URLWithString:strURL]];
     
     if(vc==nil)
     {
     [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:tweetSheet animated:YES completion:nil];
     }
     }
     else
     {
     UIAlertView *alertView = [[UIAlertView alloc]
     initWithTitle:@"Sorry"
     message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
     delegate:self
     cancelButtonTitle:@"OK"
     otherButtonTitles:nil];
     [alertView show];
     }
     */
}
/***************************************************************/
+ (void)showAlertViewTitle:(NSString *)aTitle message:(NSString *)msg cancelButtonTitle:(NSString *)str
{
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:aTitle message:msg delegate:nil cancelButtonTitle:str otherButtonTitles:nil];
    [alertview show];
}

/***************************************************************/
+ (NSString *)UUID
{
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString(nil, puuid);
    NSString *result = (NSString *)CFBridgingRelease(CFStringCreateCopy(nil, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    
    return result;
}

+ (NSString *)UUIDWithoutMinus
{
    NSString *str = [self UUID];
    str = [str stringByReplacingOccurrencesOfString :@"-" withString:@""];
    return str;
}
/***************************************************************/
+ (void)openURL:(NSURL *)url
{
    NSURL *tmpURL = url;
    if ([url isKindOfClass:[NSString class]])
    {
        tmpURL = [NSURL URLWithString:(NSString *)url];
    }
    [[UIApplication sharedApplication] openURL:tmpURL];
}


/***************************************************************/
+ (UIViewController *)topMostController
{
    //Getting rootViewController
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    //Getting topMost ViewController
    while (topController.presentedViewController)
        topController = topController.presentedViewController;
    
    //Returning topMost ViewController
    return topController;
}

/***************************************************************/
+ (NSString *) StringForSQL:(NSString *)str
{
    return [str stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
}
/***************************************************************/
+ (NSDateFormatter *)dateFormatter
{
    NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *dateFormatter = threadDictionary[@"dateFormatter"];
    if(!dateFormatter)
    {
        @synchronized(self)
        {
            if(!dateFormatter)
            {
                dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                threadDictionary[@"dateFormatter"] = dateFormatter;
            }
        }
    }
    
    return dateFormatter;
}
+ (NSDateFormatter *)dateFormatterTemp
{
    NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *dateFormatter = threadDictionary[@"dateFormatterTemp"];
    if(!dateFormatter)
    {
        @synchronized(self)
        {
            if(!dateFormatter)
            {
                dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                threadDictionary[@"dateFormatterTemp"] = dateFormatter;
            }
        }
    }
    
    return dateFormatter;
}
+ (NSDateFormatter *)dateFormatterByUTC
{
    NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *dateFormatter = threadDictionary[@"dateFormatterByUTC"];
    if(!dateFormatter)
    {
        @synchronized(self)
        {
            if(!dateFormatter)
            {
                dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
                [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
                threadDictionary[@"dateFormatterByUTC"] = dateFormatter;
            }
        }
    }
    
    return dateFormatter;
}
/***************************************************************/
+ (void)printUsedAndFreeMemoryWithMark:(NSString *)mark
{
    mach_port_t host_port;
    mach_msg_type_number_t host_size;
    vm_size_t pagesize;
    
    host_port = mach_host_self();
    host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    host_page_size(host_port, &pagesize);
    
    vm_statistics_data_t vm_stat;
    
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS)
        NSLog(@"mark: %@\nFailed to fetch vm statistics", mark);
    
    /* Stats in bytes */
    natural_t mem_used = (vm_stat.active_count +
                          vm_stat.inactive_count +
                          vm_stat.wire_count) * pagesize;
    natural_t mem_free = vm_stat.free_count * pagesize;
    natural_t mem_total = mem_used + mem_free;
    int iUsed = round(mem_used/100000);
    int iFree = round(mem_free/100000);
    int iTotal = round(mem_total/100000);
    NSLog(@"mark: %@\nused: %d free: %d total: %d", mark, iUsed, iFree, iTotal);
}

/***************************************************************/
+ (NSComparisonResult)compareVersionFromOldVersion:(NSString *)oldVersion newVersion:(NSString *)newVersion
{
    return [oldVersion compare:newVersion options:NSNumericSearch];
}
/***************************************************************/

/***************************************************************/

@end

/***************************************************************/

XYCommonBlockTest	__getTestBlock( id context )
{
    NSLogD(@"%@", context);
    return nil;
}
