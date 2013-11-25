//
//  NetworkVC.h
//  JoinShow
//
//  Created by Heaven on 13-9-7.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#define NetworkVC_downloadLink @"http://dl_dir.qq.com/qqfile/qq/QQforMac/QQ_V3.0.0.dmg"

#import <UIKit/UIKit.h>
@class RequestHelper;
@class DownloadRequest;
@interface NetworkVC : UIViewController

// get
@property (nonatomic, retain) RequestHelper *networkEngine;
// post
@property (nonatomic, retain) RequestHelper *networkEngine2;
// download
@property (nonatomic, retain) DownloadRequest *networkEngine3;

@property (retain, nonatomic) IBOutlet UIProgressView *progressDownload;
@property (retain, nonatomic) IBOutlet UILabel *labPregress;

- (IBAction)clickGet:(id)sender;
- (IBAction)clickPost:(id)sender;
- (IBAction)clickDownload:(id)sender;
- (IBAction)clickStopDownload:(id)sender;
- (IBAction)clickPauseDownload:(id)sender;

@end
