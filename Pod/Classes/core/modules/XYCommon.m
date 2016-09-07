//
//  __  __          ____           _          _
//  \ \/ / /\_/\   /___ \  _   _  (_)   ___  | | __
//   \  /  \_ _/  //  / / | | | | | |  / __| | |/ /
//   /  \   / \  / \_/ /  | |_| | | | | (__  |   <
//  /_/\_\  \_/  \___,_\   \__,_| |_|  \___| |_|\_\
//
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

#import "XYCommon.h"
#import <UIKit/UIKit.h>

@implementation XYCommon
{
    
}

/***************************************************************/
+ (NSRange)rangeOfString:(NSString *)str pointStart:(NSUInteger)iStart start:(NSString *)strStart end:(NSString *)strEnd mark:(NSString *)strMark operation:(MarkOption)operation;
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

+ (NSRange)rangeOfString:(NSString *)str pointStart:(NSUInteger)iStart start:(NSString *)strStart end:(NSString *)strEnd operation:(int)operation;
{
    // NSString *strMark = nil;
    NSRange rangeMark;
    return rangeMark;
}
+ (NSMutableArray *)rangeArrayOfString:(NSString *)str pointStart:(NSUInteger)iStart start:(NSString *)strStart end:(NSString *)strEnd mark:(NSString *)strMark operation:(MarkOption)operation
{
    return [XYCommon rangeArrayOfString:str pointStart:iStart start:strStart end:strEnd mark:strMark operation:operation everyStringExecuteBlock:nil];
}
+ (NSMutableArray *)rangeArrayOfString:(NSString *)str pointStart:(NSUInteger)iStart start:(NSString *)strStart end:(NSString *)strEnd mark:(NSString *)strMark operation:(MarkOption)operation everyStringExecuteBlock:(void(^)(NSRange rangeEvery))block
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSUInteger i = 0;
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
+ (NSString *)getValueInANonAttributeXMLNode:(NSString *)str key:(NSString *)akey location:(int)location{
    NSString *str1 = [NSString stringWithFormat:@"<%@>", akey];
    NSString *str2 = [NSString stringWithFormat:@"</%@>", akey];
    static NSUInteger i = 0;
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
+ (void)openURL:(NSURL *)URL
{
    NSURL *tmpURL = URL;
    if ([URL isKindOfClass:[NSString class]])
    {
        tmpURL = [NSURL URLWithString:(NSString *)URL];
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
    NSLog(@"%@", context);
    return nil;
}
