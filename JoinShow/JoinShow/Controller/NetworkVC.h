//
//  NetworkVC.h
//  JoinShow
//
//  Created by Heaven on 13-9-7.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#define NetworkVC_downloadLink @"http://dl_dir.qq.com/qqfile/qq/QQforMac/QQ_V3.0.0.dmg"

#import <UIKit/UIKit.h>
@class HTTPClient;
@class HTTPClient2;
@class HTTPClient3;

@class DownloadRequest;
@interface NetworkVC : UIViewController

// get
@property (nonatomic, weak) HTTPClient *httpClient;
// post
@property (nonatomic, weak) HTTPClient2 *httpClient2;
// download
@property (nonatomic, weak) HTTPClient3 *httpClient3;

@property (weak, nonatomic) IBOutlet UIProgressView *progressDownload;
@property (weak, nonatomic) IBOutlet UILabel *labPregress;

- (IBAction)clickGet:(id)sender;
- (IBAction)clickPost:(id)sender;
- (IBAction)clickDownload:(id)sender;
- (IBAction)clickStopDownload:(id)sender;
- (IBAction)clickPauseDownload:(id)sender;

@end
