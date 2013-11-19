//
//  NetworkVC.m
//  JoinShow
//
//  Created by Heaven on 13-9-7.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import "NetworkVC.h"
#if (1 == __XYQuick_Framework__)
#import <XYQuick/XYQuickDevelop.h>
#else
#import "XYQuickDevelop.h"
#endif
#import "XYExternal.h"

@interface NetworkVC ()

@end

@implementation NetworkVC
#if (1 ==  __USED_MKNetworkKit__)
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
                _networkEngine = [[NetworkEngine alloc] initWithHostName:@"www.webxml.com.cn/" customHeaderFields:nil];
        [_networkEngine useCache];
        
        _networkEngine3 = [[NetworkEngine alloc] initWithHostName:@"developer.apple.com" customHeaderFields:nil];
        [_networkEngine3 useCache];
    }
    return  self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
- (void)dealloc
{
    NSLogDD;
    self.networkEngine = nil;
    self.networkEngine2 = nil;
    self.networkEngine3 = nil;
    [_progressDownload release];
    [_labPregress release];
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickGet:(id)sender {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"theCityName": @"深圳"}];
    
    [self.networkEngine
     addGetRequestWithPath:@"WeatherWebservice.asmx/getWeatherbyCityName"
     params:dic
     succeed:^(MKNetworkOperation *operation) {
         if([operation isCachedResponse]) {
             NSLog(@"Data from cache %@", [operation responseString]);
         }
         else {
             NSLog(@"Data from server %@", @"a");
         }
     }
     failed:^(MKNetworkOperation *errorOp, NSError *err) {
         NSLog(@"MKNetwork request error : %@", [err localizedDescription]);
     }];
}

- (IBAction)clickPost:(id)sender {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"theCityName": @"深圳"}];
    
    [self.networkEngine
     addPostRequestWithPath:@"/WebServices/WeatherWebservice.asmx/getWeatherbyCityName"
     params:dic
     succeed:^(MKNetworkOperation *operation) {
         if([operation isCachedResponse]) {
             NSLog(@"Data from cache %@", [operation responseString]);
         }
         else {
             NSLog(@"Data from server %@", [operation responseString]);
         }
     }
     failed:^(MKNetworkOperation *errorOp, NSError *err) {
         NSLog(@"MKNetwork request error : %@", [err localizedDescription]);
     }];
}

- (IBAction)clickDownload:(id)sender {
    NSString *locPath = [XYCommon dataFilePath:@"2.1.dmg" ofType:filePathOption_documents];
    
     id down = [self.networkEngine3 downLoadForm:@"http://dl_dir.qq.com/qqfile/qq/QQforMac/QQ_V2.1.0.dmg" toFile:locPath params:nil rewriteFile:NO];
    
    [self.networkEngine3 addDownload:down
                    breakpointResume:YES
                            progress:^(double progress) {
                                NSLogD(@"%.2f", progress*100.0);
                                _progressDownload.progress = progress;
                                _labPregress.text = [NSString stringWithFormat:@"%.1f", progress * 100];
                            }
                             succeed:^(MKNetworkOperation *operation) {
                                 _progressDownload.progress = 0;
                                 SHOWMSG(nil, @"Download succeed", @"ok");
                             } failed:^(MKNetworkOperation *errorOp, NSError *err) {
                                 NSLog(@"MKNetwork request error : %@", [err localizedDescription]);
                                 SHOWMSG(nil, @"Download failed",  @"ok");
                             }];
}

- (IBAction)clickStopDownload:(id)sender {
    // 删除缓存文件
    [self.networkEngine3 clearAllTempDownload];
    [self.networkEngine3 cancelDownloadWithString:@"http://dl_dir.qq.com/qqfile/qq/QQforMac/QQ_V2.1.0.dmg"];
}

- (IBAction)clickPauseDownload:(id)sender {
    // 暂停时 直接取消请求
    [self.networkEngine3 cancelDownloadWithString:@"http://dl_dir.qq.com/qqfile/qq/QQforMac/QQ_V2.1.0.dmg"];
}
#else
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    SHOWMBProgressHUD(@"Message", @"Please used MKNetworkKit.", nil, YES, 3);
    
}
- (IBAction)clickGet:(id)sender {
}
- (IBAction)clickPost:(id)sender {
}
- (IBAction)clickDownload:(id)sender {
}
- (IBAction)clickStopDownload:(id)sender {
}
- (IBAction)clickPauseDownload:(id)sender {
}
#endif
@end
