//
//  TestVC.h
//  JoinShow
//
//  Created by Heaven on 13-9-1.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

// 此页面 测试用

@class XYObserve;
@class TestView;
@class GirlEntity;
@interface TestVC : UIViewController {
    int offset;
    
}
@property (nonatomic, strong) NSMutableArray *array;

@property (nonatomic, assign) int testKVO;
@property (nonatomic, assign) BOOL testKVO_BOOL;
@property (nonatomic, assign) int testKVO2;
@property (nonatomic, strong) NSMutableArray *testArrayKVO;

@property (nonatomic, strong) GirlEntity *myGirl;

@property (nonatomic, strong) TestView *testView;

@property (nonatomic, strong) NSString *text;

- (IBAction)clickBtn1:(id)sender;
- (IBAction)clickBtn2:(id)sender;
- (IBAction)clickAVSpeech:(id)sender;
- (IBAction)clickOnce:(id)sender;
- (IBAction)clickOnce2:(id)sender;

@end
