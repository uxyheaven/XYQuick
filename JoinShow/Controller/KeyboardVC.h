//
//  KeyboardVC.h
//  JoinShow
//
//  Created by Heaven on 13-10-29.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KeyboardVC : UIViewController <UITextFieldDelegate, UITextViewDelegate>{
     NSInteger selectedTextFieldTag;
}
- (IBAction)clickEnable:(id)sender;
- (IBAction)clickDisable:(id)sender;
- (IBAction)clickPop:(id)sender;

@end
