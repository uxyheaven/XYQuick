//
//  KeyboardVC.m
//  JoinShow
//
//  Created by Heaven on 13-10-29.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import "KeyboardVC.h"
#import "XYQuickDevelop.h"


@interface KeyboardVC ()

@end

@implementation KeyboardVC

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
    NSLogDD
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    int count = 7;
    for (int i = 0; i < count; i++)
    {
        UITextField *textField = (UITextField*)[self.view viewWithTag:10000 + i];
        textField.delegate = self;
        [textField addPreviousNextDoneOnKeyboardWithTarget:self previousAction:@selector(previousClicked:) nextAction:@selector(nextClicked:) doneAction:@selector(doneClicked:)];
        
        //First textField
        if (i == 0)
        {
            [textField setEnablePrevious:NO next:YES];
        }
        //Last textField
        else if(i== count - 1)
        {
            [textField setEnablePrevious:YES next:NO];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickEnable:(id)sender {
    [[XYKeyboardHelper sharedInstance] enableKeyboardHelper];
}

- (IBAction)clickDisable:(id)sender {
    [[XYKeyboardHelper sharedInstance] disableKeyboardHelper];
}

- (IBAction)clickPop:(id)sender {
    /*
    UIView *tempView = [[[UIView alloc] initWithFrame:CGRectMake(30, self.view.bounds.size.height - 100, self.view.bounds.size.width - 60, 80)] autorelease];
    tempView.backgroundColor = [UIColor lightGrayColor];
    */
}
-(void)previousClicked:(UISegmentedControl*)segmentedControl
{
    [(UIResponder *)[self.view viewWithTag:selectedTextFieldTag - 1] becomeFirstResponder];
}

-(void)nextClicked:(UISegmentedControl*)segmentedControl
{
    [(UIResponder *)[self.view viewWithTag:selectedTextFieldTag + 1] becomeFirstResponder];
}

-(void)doneClicked:(UIBarButtonItem*)barButton
{
    [self.view endEditing:YES];
}
#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    selectedTextFieldTag = textField.tag;
}
#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    selectedTextFieldTag = textView.tag;
}
@end
