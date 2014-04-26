//
//  TestVC2.m
//  JoinShow
//
//  Created by Heaven on 14-4-1.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import "TestVC2.h"

#if (1 == __XYQuick_Framework__)
#import <XYQuick/XYQuickDevelop.h>
#else
#import "XYQuickDevelop.h"
#endif

#import "DemoViewController.h"
#import "JsonTestEntity.h"

#import "XYTabBarController.h"

@interface TestVC2 ()

@end

@implementation TestVC2

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.items = @[@{@"title":@"点击动画", @"sel" : @"clickMuhud"},
                   @{@"title":@"AnalyzingJsonWithNull", @"sel" : @"clickAnalyzingJson"},
                   @{@"title":@"XYTabbarController", @"sel" : @"clickXYTabbarController"}];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"test_cell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.items.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"test_cell" forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary *dic = self.items[indexPath.row];
    cell.textLabel.text = dic[@"title"];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.items[indexPath.row];
    NSString *str = dic[@"sel"];
    SEL sel = NSSelectorFromString(str);
    if ([self respondsToSelector:sel]) {
        [self performSelector:sel];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -方法的实现
-(void) clickMuhud{
    DemoViewController *vc = [[[DemoViewController alloc] init] autorelease];
    vc.methodBlock = ^(UIViewController *vc, UIButton *btn){
        XYAnimateSerialStep *steps = [XYAnimateSerialStep animate];
        XYAnimateStep *step1 = [XYAnimateStep duration:0.15 animate:^{
            btn.transform = CGAffineTransformMakeScale(.5, .5);
        }];
        XYAnimateStep *step2 = [XYAnimateStep duration:0.2 animate:^{
            btn.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
        XYAnimateStep *step3 = [XYAnimateStep duration:0.15 animate:^{
            btn.transform = CGAffineTransformMakeScale(0.8, 0.8);
        }];
        XYAnimateStep *step4 = [XYAnimateStep duration:0.1 animate:^{
            btn.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
        [[[[steps addStep:step1] addStep:step2] addStep:step3] addStep:step4];
        
        [steps run];
    };
    vc.viewDidLoadBlock = ^(UIViewController *vc){
        UIButton *tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        tempBtn.backgroundColor = [UIColor redColor];
        tempBtn.frame = CGRectMake(10, 100, 100, 44);
        [tempBtn setTitle:@"muhud" forState:UIControlStateNormal];
        [tempBtn addTarget:vc action:DemoViewController_sel_methodBlock forControlEvents:UIControlEventTouchUpInside];
        [vc.view addSubview:tempBtn];
        
            };
    [self.navigationController pushViewController:vc animated:YES];
}
-(void) clickAnalyzingJson{
    NSString *json = @"{ \
	\"dic\":{}, \
	\"array\":[] \
}";
    NSLogD(@"%@", json);
    
    JsonTestEntity *objc = [json toModel:[JsonTestEntity class]];
    NSLogD(@"%@", objc);
}

-(void) clickXYTabbarController{
    DemoViewController *vc1 = [[[DemoViewController alloc] init] autorelease];
    vc1.viewDidLoadBlock = ^(UIViewController *vc){
        vc.view.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 44)] autorelease];
        label.text = @"vc1";
        [vc.view addSubview:label];
        
        UIButton *tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        tempBtn.backgroundColor = [UIColor redColor];
        tempBtn.frame = CGRectMake(10, 100, 200, 44);
        [tempBtn setTitle:@"xyTabBarController" forState:UIControlStateNormal];
        [tempBtn addTarget:vc action:DemoViewController_sel_methodBlock forControlEvents:UIControlEventTouchUpInside];
        [vc.view addSubview:tempBtn];
    };
    vc1.methodBlock = ^(UIViewController *vc, UIButton *btn){
        NSLogD(@"%@", vc.xyTabBarController);
    };
    
    DemoViewController *vc2 = [[[DemoViewController alloc] init] autorelease];
    vc2.viewDidLoadBlock = ^(UIViewController *vc){
        vc.view.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 44)] autorelease];
        label.text = @"vc2";
        [vc.view addSubview:label];
        UIButton *tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        tempBtn.backgroundColor = [UIColor redColor];
        tempBtn.frame = CGRectMake(10, 100, 200, 44);
        [tempBtn setTitle:@"cancel" forState:UIControlStateNormal];
        [tempBtn addTarget:vc action:DemoViewController_sel_methodBlock forControlEvents:UIControlEventTouchUpInside];
        [vc.view addSubview:tempBtn];
    };
    vc2.methodBlock = ^(UIViewController *vc, UIButton *btn){
        [vc dismissViewControllerAnimated:YES completion:nil];
    };
    
    NSArray *array = @[vc1, vc2];
    NSArray *items = @[@{@"text": @"DemoViewController1", @"normal": @"icon_facebook.png", @"selected" : @"icon_google.png"},
                       @{@"text": @"vc2", @"normal": @"icon_twitter.png", @"selected" : @"icon_google.png"}];
    
    XYTabBarController *tabBarController = [[[XYTabBarController alloc] initWithViewControllers:array items:items] autorelease];
    
    [self presentViewController:tabBarController animated:YES completion:nil];

}
@end
