//
//  NetworkVC.h
//  JoinShow
//
//  Created by Heaven on 13-9-7.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NetworkEngine;
@interface NetworkVC : UIViewController

// get
@property (nonatomic, retain) NetworkEngine *networkEngine;
// post
@property (nonatomic, retain) NetworkEngine *networkEngine2;
// download
@property (nonatomic, retain) NetworkEngine *networkEngine3;

@property (retain, nonatomic) IBOutlet UIProgressView *progressDownload;
@property (retain, nonatomic) IBOutlet UILabel *labPregress;

- (IBAction)clickGet:(id)sender;
- (IBAction)clickPost:(id)sender;
- (IBAction)clickDownload:(id)sender;
- (IBAction)clickStopDownload:(id)sender;
- (IBAction)clickPauseDownload:(id)sender;

@end
