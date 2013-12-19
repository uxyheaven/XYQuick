//
//  TestVC.h
//  JoinShow
//
//  Created by Heaven on 13-9-1.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

// 此页面 测试用

#if (1 == __XYQuick_Framework__)
#import <XYQuick/XYQuickDevelop.h>
#else
#import "XYQuickDevelop.h"
#endif
@class XYObserve;
@interface TestVC : UIViewController <XYTimerDelegate>{
    int offset;
    
}
@property (nonatomic, retain) NSMutableArray *array;

@property (nonatomic, assign) int testKVO;
@property (nonatomic, retain) NSMutableArray *testArrayKVO;

- (IBAction)clickBtn1:(id)sender;
- (IBAction)clickBtn2:(id)sender;
- (IBAction)clickAVSpeech:(id)sender;
- (IBAction)clickOnce:(id)sender;
- (IBAction)clickOnce2:(id)sender;

@end
