//
//  JsonVC.m
//  JoinShow
//
//  Created by Heaven on 13-9-8.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import "JsonVC.h"
#if (1 == __XYQuick_Framework__)
#import <XYQuick/XYQuickDevelop.h>
#else
#import "XYQuickDevelop.h"
#endif

@interface JsonVC ()

@end

@implementation JsonVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickTestString:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://url.cn/DjjSlB"];
    NSString *string = [NSString stringWithContentsOfURL:url encoding:4 error:nil];
    NSArray *array = [string toModels:[Shot class] forKey:@"shots"];
    Shot *shot = array[0];
    Player *player = shot.player;
    
    NSString *str = [player YYJSONString];
    NSLog(@"%@", str);
}

- (IBAction)clickTestData:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://url.cn/DjjSlB"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSArray *array = [data toModels:[Shot class] forKey:@"shots"];
    Shot *shot = array[0];
    Player *player = shot.player;
    NSLog(@"%@", player);
}
@end
