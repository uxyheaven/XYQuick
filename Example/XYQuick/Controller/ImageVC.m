//
//  ImageVC.m
//  JoinShow
//
//  Created by Heaven on 13-10-25.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import "ImageVC.h"
#import "XYQuick.h"


@interface ImageVC ()

@end

@implementation ImageVC

ViewControllerDemoTitle(Image)

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
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.originImg = [UIImage imageNamed:@"headportrait.jpg"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    self.originImg = nil;
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
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    //cell.backgroundColor = [UIColor lightGrayColor];
    
    // Configure the cell...
    NSDictionary *dic = [self getCellDataIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",@(indexPath.row), [dic objectForKey:@"title"]];
    cell.imageView.image = [dic objectForKey:@"img"];
    cell.imageView.bounds = CGRectMake(0, 0, 70, 70);
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */
-(NSDictionary *) getCellDataIndex:(NSInteger)i
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    switch (i) {
        case 0:
        {
            [dic setObject:@"original" forKey:@"title"];
            UIImage *tempImg = self.originImg;
            [dic setObject:tempImg forKey:@"img"];
            break;
        }
        case 1:
        {
            [dic setObject:@"GradientTint : orangeColor" forKey:@"title"];
            UIImage *tempImg = [[UIImage uxy_imageWithFileName:@"image.png"] uxy_imageWithGradientTintColor:[UIColor orangeColor]];
            [dic setObject:tempImg forKey:@"img"];
            break;
        }
        case 2:
        {
            [dic setObject:@"rounded" forKey:@"title"];
            UIImage *tempImg = [self.originImg uxy_rounded];
            [dic setObject:tempImg forKey:@"img"];
            break;
        }
        case 3:
        {
            [dic setObject:@"rounded(10, 10, 70, 70)" forKey:@"title"];
            UIImage *tempImg = [self.originImg uxy_rounded:CGRectMake(10, 10, 70, 70)];
            [dic setObject:tempImg forKey:@"img"];
            break;
        }
        case 4:
        {
            [dic setObject:@"stretched" forKey:@"title"];
            UIImage *tempImg = [[UIImage uxy_imageWithFileName:@"user_currentstandings.png"] uxy_stretched];
            [dic setObject:tempImg forKey:@"img"];
            break;
        }
        case 5:
        {
            [dic setObject:@"stretched(UIEdgeInsetsMake)" forKey:@"title"];
            UIImage *tempImg = [[UIImage uxy_imageWithFileName:@"user_currentstandings.png"] uxy_stretched:UIEdgeInsetsMake(12, 1, 2, 2)];
            [dic setObject:tempImg forKey:@"img"];
            break;
        }
        case 6:
        {
            [dic setObject:@"grayscale" forKey:@"title"];
            UIImage *tempImg = [[UIImage uxy_imageWithFileName:@"image.png"] uxy_grayscale];
            [dic setObject:tempImg forKey:@"img"];
            break;
        }
        case 7:
        {
            [dic setObject:@"imageInRect(0, 0, 40, 40)" forKey:@"title"];
            UIImage *tempImg = [self.originImg uxy_imageInRect:CGRectMake(0, 0, 40, 40)];
            [dic setObject:tempImg forKey:@"img"];
            break;
        }
        case 8:
        {
            [dic setObject:@"scaleToSize(20, 20)" forKey:@"title"];
            UIImage *tempImg = [self.originImg uxy_scaleToSize:CGSizeMake(20, 20)];
            [dic setObject:tempImg forKey:@"img"];
            break;
        }
        case 9:
        {
            [dic setObject:@"merge" forKey:@"title"];
            UIImage *img1 = [UIImage imageNamed:@"p31b0002.png"];
            UIImage *tempImg = [self.originImg uxy_merge:img1];
            [dic setObject:tempImg forKey:@"img"];
            break;
        }
        case 10:
        {
            [dic setObject:@"roundedRectWith:10" forKey:@"title"];
            UIImage *tempImg = [self.originImg uxy_roundedRectWith:10];
            [dic setObject:tempImg forKey:@"img"];
            break;
        }
        case 11:
        {
            [dic setObject:@"roundedRectWith:25 Bottom" forKey:@"title"];
            UIImage *tempImg = [self.originImg uxy_roundedRectWith:25 cornerMask:UXYImageRoundedCornerCornerBottomRight | UXYImageRoundedCornerCornerBottomLeft];
            [dic setObject:tempImg forKey:@"img"];
            break;
        }
        case 12:
        {
            [dic setObject:@"stackBlur:10" forKey:@"title"];
            UIImage *tempImg = [self.originImg uxy_stackBlur:10];
            [dic setObject:tempImg forKey:@"img"];
            break;
        }
        case 13:
        {
            [dic setObject:@"original" forKey:@"title"];
            UIImage *tempImg = [UIImage uxy_imageWithFileName:@"image.png"];
            [dic setObject:tempImg forKey:@"img"];
            break;
        }
        case 14:
        {
            [dic setObject:@"Tint : orangeColor" forKey:@"title"];
            UIImage *tempImg = [[UIImage uxy_imageWithFileName:@"image.png"] uxy_imageWithTintColor:[UIColor orangeColor]];
            [dic setObject:tempImg forKey:@"img"];
            break;
        }
        case 15:
        {
            [dic setObject:@"Color Image" forKey:@"title"];
            UIImage *tempImg = [UIImage uxy_imageWithColor:[UIColor blueColor] size:CGSizeMake(30, 30)];
            [dic setObject:tempImg forKey:@"img"];
            break;
        }
        default:
        {
            [dic setObject:@"normal" forKey:@"title"];
            UIImage *tempImg = self.originImg;
            [dic setObject:tempImg forKey:@"img"];
            break;
        }
    }
    return dic;
}
@end
