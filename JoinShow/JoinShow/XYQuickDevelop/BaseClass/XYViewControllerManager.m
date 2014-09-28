//
//  XYViewControllerManager.m
//  ChildKing
//
//  Created by Heaven on 14-5-1.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import "XYViewControllerManager.h"
#import "UIView+XY.h"

@interface XYViewControllerManager ()
@property (nonatomic, strong, readonly) NSMutableDictionary *viewControllerSetupBlocks; // 创建viewControllers的block
@end

@implementation XYViewControllerManager


DEF_SINGLETON(XYViewControllerManager)

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _viewControllers           = [NSMutableDictionary dictionaryWithCapacity:4];
        _viewControllerSetupBlocks = [NSMutableDictionary dictionaryWithCapacity:4];
    }
    
    return self;
}

- (void)createViews
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIDeviceOrientationPortrait || orientation  == UIInterfaceOrientationPortraitUpsideDown)
    {
        // 竖屏
        _contentView = [[UIView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_contentView];
    }
    else
    {
        // 横屏
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.height, self.view.bounds.size.width)];
        [self.view addSubview:_contentView];
    }
}

- (void)loadData
{
    if (_firstKey)
    {
        self.selectedKey = _firstKey;
    }
}


#pragma mark - rewrite
// 额外的重写的父类的方法

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setSelectedKey:(NSString *)selectedKey
{
    [self displayViewWithKey:selectedKey];
}

- (void)addAViewController:(XYViewControllerManager_createVC_block)block key:(NSString *)key
{
    [_viewControllerSetupBlocks setObject:block forKey:key];
}

- (void)didRotateFromInterfaceOrientation: (UIInterfaceOrientation)fromInterfaceOrientation
{
    /* 在这里加入代码，处理方向变换之后的变化 */
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIDeviceOrientationPortrait || orientation  == UIInterfaceOrientationPortraitUpsideDown)
    {
        // 竖屏
        _contentView.frame = self.view.bounds;
    }
    else
    {
        // 横屏
        _contentView.frame = self.view.bounds;
    }
}
#pragma mark - private
// 私有方法
- (void)displayViewWithKey:(NSString *)key
{
    UIViewController *targetViewController = (_viewControllers[key]) ? _viewControllers[key] : ((XYViewControllerManager_createVC_block)_viewControllerSetupBlocks[key])();
    
    if ([_selectedKey isEqualToString:key] && (_contentView.subviews.count != 0))
    {
        if ([targetViewController isKindOfClass:[UINavigationController class]])
        {
            [(UINavigationController*)targetViewController popToRootViewControllerAnimated:YES];
        }
        return;
    }
    
    [self.selectedViewController removeFromParentViewController];
    [_contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];
    
    targetViewController.view.frame = _contentView.bounds;
    
    [self addChildViewController:targetViewController];
    [_contentView addSubview:targetViewController.view];
    
    [_viewControllers setObject:targetViewController forKey:key];
    _selectedViewController = targetViewController;
    _selectedKey = key;
    
    // 动画效果
    [self.view animationCrossfadeWithDuration:.3];
}

-(UIViewController *) selectedViewController
{
    return [_viewControllers objectForKey:_selectedKey];
}

- (void)clean
{
    [_viewControllers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (![_selectedKey isEqualToString:key])
        {
            [_viewControllers removeObjectForKey:key];
        }
    }];
}

@end


@implementation UIViewController (XYViewControllerManager)

-(XYViewControllerManager *) viewControllerManager
{
    return [XYViewControllerManager sharedInstance];
}

@end







