//
//  AnimationVC.m
//  JoinShow
//
//  Created by Heaven on 13-8-23.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import "AnimationVC.h"
#if (1 == __XYQuick_Framework__)
#import <XYQuick/XYQuickDevelop.h>
#else
#import "XYQuickDevelop.h"
#endif
@interface AnimationVC ()<XYSpriteDelegate>{
    UILabel *labText;
    int count;
}

@end

@implementation AnimationVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)dealloc
{
    NSLogDD;
    [[XYSpriteHelper sharedInstance] clearAllSprites];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
  //  self.navigationController.delegate = self;
    
	// Do any additional setup after loading the view.
    UILabel *tmpLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 30)];
    tmpLab.backgroundColor = [UIColor lightGrayColor];
    tmpLab.text = @"test";
    labText = tmpLab;
    [self.view addSubview:tmpLab];

    ////////////////////////////  XYSpriteView ////////////////////////////
    XYSpriteView *tmpSprite = [[XYSpriteView alloc] initWithFrame:CGRectMake(0, 50, 224, 138)];
    tmpSprite.firstImgIndex = 1;
    [tmpSprite formatImg:@"p31b%0.4d.png" count:180 repeatCount:0];
    [tmpSprite showImgWithIndex:0];
    tmpSprite.delegate = self;
    [[XYSpriteHelper sharedInstance].sprites setObject:tmpSprite forKey:@"a"];
    [self.view addSubview:tmpSprite];
    
    [[XYSpriteHelper sharedInstance] startAllSprites];

}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[XYSpriteHelper sharedInstance] startTimer];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[XYSpriteHelper sharedInstance] stopTimer];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -XYSpriteDelegate
-(void) spriteOnIndex:(int)aIndex sprite:(XYSpriteView *)aSprite{
    if (aIndex == 1) {
        count++;
        labText.text = [NSString stringWithFormat:@"%d", count];
    }
}
-(void) spriteWillStart:(XYSpriteView *)aSprite{
    NSLogDD
}
/*
#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
}
 */
@end
