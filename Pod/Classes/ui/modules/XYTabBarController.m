//
//  __  __          ____           _          _
//  \ \/ / /\_/\   /___ \  _   _  (_)   ___  | | __
//   \  /  \_ _/  //  / / | | | | | |  / __| | |/ /
//   /  \   / \  / \_/ /  | |_| | | | | (__  |   <
//  /_/\_\  \_/  \___,_\   \__,_| |_|  \___| |_|\_\
// //
//  Copyright (C) Heaven.
//
//	https://github.com/uxyheaven/XYQuick
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.
//

#import "XYTabBarController.h"

@interface XYTabBarController ()

@property (nonatomic, strong) NSArray *viewControllers;
@property (nonatomic, strong) NSArray *tempItems;
@property (nonatomic, strong) UIView *contentView;

@end

@implementation XYTabBarController

- (id)initWithViewControllers:(NSArray *)vcs items:(NSArray *)items
{
    self = [super init];
    if (self)
    {
        self.viewControllers = vcs;
        self.tempItems       = items;
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
- (void)uxy_createFields
{
    _tabBarFrame  = CGRectMake(0, self.view.bounds.size.height - 49, self.view.bounds.size.width, 49);
    _contentFrame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 49);
}

- (void)uxy_destroyFields
{
}

- (void)uxy_createViews
{
    _contentView = [[UIView alloc] initWithFrame:_contentFrame];
    [self.view
     addSubview:_contentView];

    _tabBar = [[XYTabBar alloc] initWithFrame:_tabBarFrame
                                        items:_tempItems];
    [self.view
     addSubview:_tabBar];

    self.tempItems = nil;

    for (int i = 0; i < _tabBar.items.count; i++)
    {
        [self setupItem:_tabBar.items[i]
                  index:i];
    }

    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectZero];
    view.alpha           = 1;
    view.backgroundColor = [UIColor yellowColor];
    _tabBar.animatedView = view;
    [_tabBar addSubview:view];
}

- (void)uxy_destroyViews
{
}

- (void)uxy_createEvents
{
    _tabBar.delegate = self;
}

- (void)uxy_destroyEvents
{
}

- (void)uxy_loadData
{
    self.selectedIndex = 0;
}

- (UIViewController *)selectedViewController
{
    return [_viewControllers objectAtIndex:_selectedIndex];
}

- (void)setSelectedIndex:(NSUInteger)index
{
    [self displayViewAtIndex:index];
    [_tabBar selectTabAtIndex:index];
}

- (void)setupItem:(UIButton *)item index:(NSInteger)index
{
    [_tabBar setupItem:item
                 index:index];
}

- (void)resetAnimatedView:(UIImageView *)animatedView index:(NSInteger)index
{
    static BOOL isFirst = NO;
    if (!isFirst)
    {
        animatedView.backgroundColor = [UIColor orangeColor];
        animatedView.alpha           = 0.5;
        isFirst                      = YES;
    }

    [_tabBar resetAnimatedView:animatedView
                         index:index];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
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
    UIViewController<XYTabBarControllerProtocol> *targetViewController = [self.viewControllers
                                                                          objectAtIndex:index];
    // If target index is equal to current index.
    if (_selectedIndex == index && [[_contentView subviews] count] != 0)
    {
        if ([targetViewController isKindOfClass:[UINavigationController class]])
        {
            [(UINavigationController *)targetViewController
             popToRootViewControllerAnimated:YES];
        }
        return;
    }

    _selectedIndex = index;

    [_contentView.subviews
     makeObjectsPerformSelector:@selector(removeFromSuperview)
                     withObject:nil];
    targetViewController.view.frame = _contentView.bounds;
    [self addChildViewController:targetViewController];
    [_contentView addSubview:targetViewController.view];

    if ([targetViewController isKindOfClass:[UINavigationController class]])
    {
        UIViewController<XYTabBarControllerProtocol> *vc = (UIViewController<XYTabBarControllerProtocol> *)((UINavigationController *)targetViewController).topViewController;
        if ([vc respondsToSelector:@selector(tabBarController:didSelectViewController:)])
        {
            [vc tabBarController:self
             didSelectViewController:[self.viewControllers
                                      objectAtIndex:index]];
        }
    }

    if ([targetViewController respondsToSelector:@selector(tabBarController:didSelectViewController:)])
    {
        [targetViewController tabBarController:self
                       didSelectViewController:targetViewController];
    }
}

#pragma mark - 响应 model 的地方
#pragma mark 1 notification


#pragma mark 2 KVO


#pragma mark - 响应 view 的地方
#pragma mark 1 target-action


#pragma mark 2 delegate

#pragma mark XYTabBarDelegate
- (BOOL)tabBar:(XYTabBar *)tabBar shouldSelectIndex:(NSInteger)index
{
    UIViewController<XYTabBarControllerProtocol> *targetViewController = [self.viewControllers
                                                                          objectAtIndex:index];

    if ([targetViewController isKindOfClass:[UINavigationController class]])
    {
        UIViewController<XYTabBarControllerProtocol> *vc = (UIViewController<XYTabBarControllerProtocol> *)((UINavigationController *)targetViewController).topViewController;
        if ([vc respondsToSelector:@selector(tabBarController:shouldSelectViewController:)])
        {
            return [vc tabBarController:self
                    shouldSelectViewController:[self.viewControllers
                                                objectAtIndex:index]];
        }
    }

    if ([targetViewController respondsToSelector:@selector(tabBarController:shouldSelectViewController:)])
    {
        return [targetViewController tabBarController:self
                           shouldSelectViewController:[self.viewControllers
                                            objectAtIndex:index]];
    }

    return YES;
}

- (void)tabBar:(XYTabBar *)tabBar didSelectIndex:(NSInteger)index
{
    [self displayViewAtIndex:index];

    [self resetAnimatedView:_tabBar.animatedView
                      index:index];
}

#pragma mark 3 dataSource

@end


@implementation UIViewController (XYTabBarController)

- (XYTabBarController *)xyTabBarController
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
