//
//  DomeTableViewController.m
//  JoinShow
//
//  Created by Heaven on 13-8-23.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import "DemoTableViewController.h"
#import "XYQuick.h"

@interface DemoTableViewController ()

@end

@implementation DemoTableViewController

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
        NSArray *array = [NSObject uxy_classesWithProtocol:@"ViewControllerDemo"];
        NSMutableArray *mArray = [@[] mutableCopy];
        for (NSInteger i = 0; i < array.count; i++)
        {
            [mArray addObject:@{@"title" : [NSClassFromString(array[i]) title], @"classType" : array[i]}];
        }
        self.list = mArray;
    }
    return self;
}
- (void)dealloc
{
    NSLogDD;
    self.list = nil;
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]  initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(clickRight:)];
    self.navigationItem.rightBarButtonItem = item;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}
- (void)viewWillAppear:(BOOL)animated{
    
}
- (void)viewDidAppear:(BOOL)animated{
    
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
   // cell.rowHeight = 44;
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
// ios7 下执行2次?
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
    CGFloat height = 44;
    tableView.delegate = nil;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell)
    {
        height = cell.rowHeight;
    }
    tableView.delegate = self;
    return height;
     */
    //NSLogD(@"%@", indexPath);
    float f = [UITableViewCell uxy_heightForRowWithData:@"test"];
    return f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    NSDictionary *dic = [self.list objectAtIndex:indexPath.row];
    @try {
        // 故事版加载
        [self performSegueWithIdentifier:[dic objectForKey:@"classType"] sender:dic];
    }
    @catch (NSException *exception) {
        NSLog(@"Segue not found: %@", exception);
        
        UIViewController *vc = [[NSClassFromString([dic objectForKey:@"classType"]) alloc] init];
        vc.title = [dic objectForKey:@"title"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *vc = segue.destinationViewController;
    vc.title = [sender objectForKey:@"title"];
}
- (void)clickRight:(id)sender{
    [self.tableView uxy_reloadData:YES];
}
@end
