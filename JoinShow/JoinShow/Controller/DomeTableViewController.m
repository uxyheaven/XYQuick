//
//  DomeTableViewController.m
//  JoinShow
//
//  Created by Heaven on 13-8-23.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import "DomeTableViewController.h"
#if (1 == __XYQuick_Framework__)
#import <XYQuick/XYQuickDevelop.h>
#else
#import "XYQuickDevelop.h"
#endif
@interface DomeTableViewController ()

@end

@implementation DomeTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
    }
    return self;
}
- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.list = @[@{@"title": @"Test", @"className": @"TestVC"},
                      @{@"title": @"Frame Animation", @"className": @"AnimationVC"},
                      @{@"title": @"Something", @"className": @"MessVC"},
                      @{@"title": @"Network", @"className": @"NetworkVC"},
                      @{@"title": @"Json", @"className": @"JsonVC"},
                      @{@"title": @"DataLite", @"className": @"DataLiteVC"},
                      @{@"title": @"Database", @"className": @"DatabaseVC"},
                      @{@"title": @"Parallax", @"className": @"ParallaxVC"},
                      @{@"title": @"Image", @"className": @"ImageVC"},
                      @{@"title": @"Keyboard", @"className": @"KeyboardVC"},
                      @{@"title": @"Business", @"className": @"BusinessVC"},
                      @{@"title": @"PopupView", @"className": @"PopupViewVC"}];
    }
    return self;
}
- (void)dealloc
{
    NSLogDD;
    self.list = nil;
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    /*
    // 1 initalize
    // 2 config view
    // 3 assign view
    // 4 addsubview
     */
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
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
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    // Configure the cell...
    NSDictionary *dic = [self.list objectAtIndex:indexPath.row];
    cell.textLabel.text = [dic objectForKey:@"title"];
    
    return cell;
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
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    NSDictionary *dic = [self.list objectAtIndex:indexPath.row];
    /*
    UIViewController *detailViewController = [[NSClassFromString([dic objectForKey:@"className"]) alloc] initWithNibName:nil bundle:nil];
    detailViewController.title = [dic objectForKey:@"title"];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
     */
    [self performSegueWithIdentifier:[dic objectForKey:@"className"] sender:dic];
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *vc = segue.destinationViewController;
    vc.title = [sender objectForKey:@"title"];
}
@end
