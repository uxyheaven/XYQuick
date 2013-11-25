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
#import "DownloadRequest.h"

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
        self.networkEngine = [RequestHelper defaultSettings];
        [_networkEngine useCache];
        
        self.networkEngine3 = [DownloadRequest defaultSettings];
        [_networkEngine3 setup];
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
    HttpRequest *op = [self.networkEngine get:@"WeatherWebservice.asmx/getWeatherbyCityName"];
    
    [op succeed:^(MKNetworkOperation *op) {
        if([op isCachedResponse]) {
            NSLog(@"Data from cache %@", [op responseString]);
        }
        else {
            NSLog(@"Data from server %@", @"a");
        }
    } failed:^(MKNetworkOperation *op, NSError *err) {
        NSLog(@"MKNetwork request error : %@", [err localizedDescription]);
    }];
    
    [self.networkEngine submit:op];
}

- (IBAction)clickPost:(id)sender {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"theCityName": @"深圳"}];
    MKNetworkOperation *op = [self.networkEngine get:@"/WebServices/WeatherWebservice.asmx/getWeatherbyCityName" params:dic];
    [op succeed:^(MKNetworkOperation *op) {
        NSLog(@"Data from cache %@", [op responseString]);
    } failed:^(MKNetworkOperation *op, NSError *err) {
        NSLog(@"MKNetwork request error : %@", [err localizedDescription]);
    }];
    
    [self.networkEngine submit:op];
}

- (IBAction)clickDownload:(id)sender {
    NSString *locPath = [XYCommon dataFilePath:@"3.0.dmg" ofType:filePathOption_documents];
    
    Downloader *down = [self.networkEngine3 downLoad:NetworkVC_downloadLink
                                                  to:locPath
                                              params:nil
                                    breakpointResume:YES];
    
    [down progress:^(double progress) {
        NSLogD(@"%.2f", progress*100.0);
        _progressDownload.progress = progress;
        _labPregress.text = [NSString stringWithFormat:@"%.1f", progress * 100];
    }];
    [down succeed:^(HttpRequest *op) {
        _progressDownload.progress = 0;
        SHOWMSG(nil, @"Download succeed", @"ok");
    } failed:^(HttpRequest *op, NSError *err) {
        NSLog(@"MKNetwork request error : %@", [err localizedDescription]);
        SHOWMSG(nil, @"Download failed",  @"ok");
    }];
    
    [self.networkEngine3 submit:down];
}

- (IBAction)clickStopDownload:(id)sender {
    // 删除缓存文件
    [self.networkEngine3 clearAllTempFile];
    [self.networkEngine3 cancelDownloadWithString:NetworkVC_downloadLink];
}

- (IBAction)clickPauseDownload:(id)sender {
    // 暂停时 直接取消请求
    [self.networkEngine3 cancelDownloadWithString:NetworkVC_downloadLink];
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
