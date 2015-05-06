//
//  NetworkVC.m
//  JoinShow
//
//  Created by Heaven on 13-9-7.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import "NetworkVC.h"

#import "XYQuick.h"
#import "RequestHelper.h"
#import "HTTPClient.h"

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
        self.httpClient = [HTTPClient sharedInstance];
        [_httpClient useCache];
        
        self.httpClient2 = [HTTPClient2 sharedInstance];
        
        self.httpClient3 = [HTTPClient3 sharedInstance];
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
    [self.httpClient cancelAllOperations];
    [self.httpClient2 cancelAllOperations];
    [self.httpClient3 cancelAllDownloads];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickGet:(id)sender {
    HttpRequest *op = [self.httpClient get:@"WeatherWebservice.asmx/getWeatherbyCityName"];
    [op succeed:^(MKNetworkOperation *op) {
        if([op isCachedResponse]) {
            NSLog(@"Data from cache %@", [op responseString]);
        }
        else {
            NSLog(@"Data from server %@", @"a");
        }
    } failed:^(MKNetworkOperation *op, NSError *err) {
        NSLog(@"Request error : %@", [err localizedDescription]);
    }];
    [self.httpClient submit:op];
}

- (IBAction)clickPost:(id)sender {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"theCityName": @"深圳"}];
    MKNetworkOperation *op = [self.httpClient2 post:@"/WebServices/WeatherWebservice.asmx/getWeatherbyCityName" params:dic];
    [op succeed:^(MKNetworkOperation *op) {
        NSLog(@"Data from cache %@", [op responseString]);
    } failed:^(MKNetworkOperation *op, NSError *err) {
        NSLog(@"Request error : %@", [err localizedDescription]);
    }];
    op.freezable = YES;
    [self.httpClient2 submit:op];
}

- (IBAction)clickDownload:(id)sender {
    NSString *locPath = [XYCommon dataFilePath:@"3.0.dmg" ofType:filePathOption_documents];
    DEF_WEAKSELF
    Downloader *down = [self.httpClient3 download:NetworkVC_downloadLink
                                                  to:locPath
                                              params:nil
                                    breakpointResume:YES];
    
    [down progress:^(double progress) {
        DEF_STRONGSELF
        NSLogD(@"%.2f", progress*100.0);
        [self progressDownload].progress = progress;
        [self labPregress].text = [NSString stringWithFormat:@"%.1f", progress * 100];
    }];
    [down succeed:^(HttpRequest *op) {
        DEF_STRONGSELF
        [self progressDownload].progress = 0;
        SHOWMSG(nil, @"Download succeed", @"ok");
    } failed:^(HttpRequest *op, NSError *err) {
        NSLog(@"Request error : %@", [err localizedDescription]);
        SHOWMSG(nil, @"Download failed",  @"ok");
    }];
    
    [self.httpClient3 submit:down];
}

- (IBAction)clickStopDownload:(id)sender {
    // 删除缓存文件
    [self.httpClient3 emptyTempFile];
    [self.httpClient3 cancelDownloadWithString:NetworkVC_downloadLink];
}

- (IBAction)clickPauseDownload:(id)sender {
    // 暂停时 直接取消请求
    [self.httpClient3 cancelDownloadWithString:NetworkVC_downloadLink];
}
#else
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
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
