//
//  XYBaseTabBarController.m
//  JoinShow
//
//  Created by Heaven on 14-4-25.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import "XYTabBarController.h"
#import "XYUISignal.h"

@interface XYTabBarController ()

@property (nonatomic, strong) NSMutableArray *viewControllers;
@property (nonatomic, strong) NSArray *tempItems;
@property (nonatomic, strong) UIView *contentView;

@end

@implementation XYTabBarController

-(id) initWithViewControllers:(NSArray *)vcs items:(NSArray *)items
{
    self = [super init];
    if (self)
    {
        self.viewControllers = vcs;
        self.tempItems = items;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)createFields
{
    _tabBarFrame = CGRectMake(0, self.view.bounds.size.height - 49, self.view.bounds.size.width, 49);
    _contentFrame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 49);
}

- (void)destroyFields
{

}

- (void)createViews
{
    _contentView = [[UIView alloc] initWithFrame:_contentFrame];
    [self.view addSubview:_contentView];
    
    _tabBar = [[XYTabBar alloc] initWithFrame:_tabBarFrame items:_tempItems];
    [self.view addSubview:_tabBar];

    self.tempItems = nil;
    
    for (int i = 0; i < _tabBar.items.count; i++)
    {
        [self setupItem:_tabBar.items[i] index:i];
    }
    
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectZero];
    view.alpha = 1;
    view.backgroundColor = [UIColor yellowColor];
    _tabBar.animatedView = view;
    [_tabBar addSubview:view];
}

- (void)destroyViews
{

}

- (void)createEvents
{
    _tabBar.delegate = self;
}

- (void)destroyEvents
{

}

- (void)loadData
{
    self.selectedIndex = 0;
}


- (UIViewController *)selectedViewController
{
    return [_viewControllers objectAtIndex:_selectedIndex];
}

-(void)setSelectedIndex:(NSUInteger)index
{
    [self displayViewAtIndex:index];
    [_tabBar selectTabAtIndex:index];
}
- (void)setupItem:(UIButton *)item index:(NSInteger)index
{
    [_tabBar setupItem:item index:index];
}

- (void)resetAnimatedView:(UIImageView *)animatedView index:(NSInteger)index
{
    static BOOL isFirst = NO;
    if (!isFirst)
    {
        animatedView.backgroundColor = [UIColor orangeColor];
        animatedView.alpha = 0.5;
        isFirst = YES;
    }
    
    [_tabBar resetAnimatedView:animatedView index:index];
}

#pragma mark - rewrite
// 额外的重写的父类的方法
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private
// 私有方法
- (void)displayViewAtIndex:(NSUInteger)index
{
    UIViewController<XYTabBarControllerProtocol> *targetViewController = [self.viewControllers objectAtIndex:index];
    // If target index is equal to current index.
    if (_selectedIndex == index && [[_contentView subviews] count] != 0)
    {
        if ([targetViewController isKindOfClass:[UINavigationController class]])
        {
            [(UINavigationController*)targetViewController popToRootViewControllerAnimated:YES];
        }
        return;
    }
    
    _selectedIndex = index;
    
    [_contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];
	targetViewController.view.frame = _contentView.bounds;
    [self addChildViewController:targetViewController];
    [_contentView addSubview:targetViewController.view];
    
    if ([targetViewController isKindOfClass:[UINavigationController class]]) {
        UIViewController<XYTabBarControllerProtocol> *vc = ((UINavigationController *)targetViewController).topViewController;
        if ([vc respondsToSelector:@selector(tabBarController:didSelectViewController:)])
        {
            [vc tabBarController:self didSelectViewController:[self.viewControllers objectAtIndex:index]];
        }
    }
    
    if ([targetViewController respondsToSelector:@selector(tabBarController:didSelectViewController:)])
    {
        [targetViewController tabBarController:self didSelectViewController:targetViewController];
    }
}
#pragma mark - 响应 model 的地方
#pragma mark 1 notification


#pragma mark 2 KVO


#pragma mark - 响应 view 的地方
#pragma mark 1 target-action


#pragma mark 2 delegate

#pragma mark XYTabBarDelegate
-(BOOL) tabBar:(XYTabBar *)tabBar shouldSelectIndex:(NSInteger)index
{
    UIViewController<XYTabBarControllerProtocol> *targetViewController = [self.viewControllers objectAtIndex:index];
    
    if ([targetViewController isKindOfClass:[UINavigationController class]])
    {
        UIViewController<XYTabBarControllerProtocol> *vc = ((UINavigationController *)targetViewController).topViewController;
        if ([vc respondsToSelector:@selector(tabBarController:shouldSelectViewController:)])
        {
            return [vc tabBarController:self shouldSelectViewController:[self.viewControllers objectAtIndex:index]];
        }
    }
    
    if ([targetViewController respondsToSelector:@selector(tabBarController:shouldSelectViewController:)])
    {
        return [targetViewController tabBarController:self shouldSelectViewController:[self.viewControllers objectAtIndex:index]];
    }
    
    return YES;
}

- (void)tabBar:(XYTabBar *)tabBar didSelectIndex:(NSInteger)index
{
	[self displayViewAtIndex:index];
    
    [self resetAnimatedView:_tabBar.animatedView index:index];
}

#pragma mark 3 dataSource

ON_SIGNAL( signal ){
    NSLogD(@"%@", signal);
}

@end


@implementation UIViewController (XYTabBarController)

-(XYTabBarController *) xyTabBarController
{
    UIViewController *vc = self.parentViewController;
    while (vc)
    {
        if ([vc isKindOfClass:[XYTabBarController class]])
        {
            return (XYTabBarController *)vc;
        }
        else if (vc.parentViewController && vc.parentViewController != vc)
        {
            vc = vc.parentViewController;
        }
        else
        {
            vc = nil;
        }
    }
    
    return nil;
}

@end
