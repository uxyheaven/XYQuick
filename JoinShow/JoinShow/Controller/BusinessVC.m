//
//  BusinessVC.m
//  JoinShow
//
//  Created by Heaven on 13-10-31.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import "BusinessVC.h"
#import "EntityBaseModel.h"

#import "XYExternal.h"

#import "RubyChinaNodeEntity.h"

@interface BusinessVC ()
// get
@property (nonatomic, strong) NSArray *model;
@property (nonatomic, strong) EntityBaseModel *entityModel;

@end

@implementation BusinessVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return  self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createFields
{
    [super createFields];
    
    self.entityModel = [[EntityBaseModel alloc] init];
    RequestHelper *request = [[RequestHelper alloc] initWithHostName:@"www.ruby-china.org" customHeaderFields:@{@"x-client-identifier" : @"iOS"}];
    [request useCache];
    request.freezable = YES;
    request.forceReload = YES;
    
    self.entityModel.requestHelper = request;
}

- (void)destroyFields
{
    [super destroyFields];
    
    self.entityModel = nil;
}

- (void)createViews
{
    [super createViews];
    
    _btnStart = (UIButton *)[self.view viewWithTag:11000];
    
    _btnLoad = (UIButton *)[self.view viewWithTag:11001];
}

- (void)destroyViews
{
    [super destroyViews];
}

- (void)createEvents
{
    [super createEvents];
    
    [_btnStart addTarget: self action: @selector(clickStart:) forControlEvents:UIControlEventTouchUpInside];
    [_btnLoad addTarget: self action: @selector(clickLoad:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)destroyEvents
{
    [super destroyEvents];
}

// 如果页面加载过程需要调用MobileAPI，则写在这个地方。
- (void)loadData
{
    [super loadData];
}


#pragma mark - rewrite

#pragma mark - event
- (IBAction)clickStart:(id)sender {
    for (int i = 0; i < 6; i++) {
        UILabel *label = (UILabel *)[self.view viewWithTag:i + 10000];
        label.textColor = [UIColor blueColor];
    }
    
    [self performSelector:@selector(start) withObject:nil afterDelay:1];
}

- (IBAction)clickLoad:(id)sender {
    UITextField *textField = (UITextField *)[self.view viewWithTag:11003];
    [self.view endEditing:YES];
    
    RubyChinaNodeEntity *anObject = [[RubyChinaNodeEntity alloc] init];
    anObject.nodeID = [textField.text intValue];
    [anObject loadFromDB];
    NSString *str = [anObject XYJSONString];
    SHOWMBProgressHUD(@"Data", str, nil, NO, 3);
}


- (void)start{
    UILabel *label = (UILabel *)[self.view viewWithTag:0 + 10000];
    label.textColor = [UIColor redColor];
    [self performSelector:@selector(httpGET) withObject:nil afterDelay:1];
}
- (void)httpGET{
    UILabel *label = (UILabel *)[self.view viewWithTag:1 + 10000];
    label.textColor = [UIColor redColor];
    __block id myself =self;
    HttpRequest *request = [self.entityModel.requestHelper get:@"api/nodes.json"];
    [request succeed:^(HttpRequest *op) {
        UILabel *label = (UILabel *)[self.view viewWithTag:2 + 10000];
        label.textColor = [UIColor redColor];
        
        if([op isCachedResponse]) {
            NSLog(@"Data from cache %@", [op responseString]);
            [myself parseData:[op responseString] isCachedResponse:YES];
        }
        else {
            NSLog(@"Data from server %@", [op responseString]);
            [myself parseData:[op responseString] isCachedResponse:NO];
        }
    } failed:^(HttpRequest *op, NSError *err) {
        NSString *str = [NSString stringWithFormat:@"Request error : %@", [err localizedDescription]];
        NSLogD(@"%@", str);
        
        // SHOWMBProgressHUD(@"Message", str, nil, NO, 3);
        [self loadFromDBProcess];
    }];
    
    [self.entityModel.requestHelper submit:request];
}
- (void)parseData:(NSString *)str isCachedResponse:(BOOL)isCachedResponse{
    UILabel *label = (UILabel *)[self.view viewWithTag:3 + 10000];
    label.textColor = [UIColor redColor];
    
    self.model = [str toModels:[RubyChinaNodeEntity class]];
    
    [self performSelector:@selector(refreshUI) withObject:nil afterDelay:1];
    
    if (isCachedResponse) {
        ;
    }else{
        [self performSelector:@selector(saveToDBProcess) withObject:nil afterDelay:1];
    }
}
- (void)saveToDBProcess{
    UILabel *label = (UILabel *)[self.view viewWithTag:4 + 10000];
    label.textColor = [UIColor redColor];
    PERF_ENTER_( saveAllToDB )
    [self.model saveAllToDB];
    PERF_LEAVE_( saveAllToDB )
}
- (void)refreshUI{
    UILabel *label = (UILabel *)[self.view viewWithTag:5 + 10000];
    label.textColor = [UIColor redColor];
    
    if (self.model && self.model.count > 0) {
        NSString *str = [[self.model objectAtIndex:0] XYJSONString];
        SHOWMBProgressHUD(@"Data", str, nil, NO, 3);
    }
}
- (void)loadFromDBProcess{
    self.model = [NSArray loadFromDBWithClass:[RubyChinaNodeEntity class]];
    
    [self performSelector:@selector(refreshUI) withObject:nil afterDelay:1];
}

#pragma mark - delegate

#pragma mark - private
@end
