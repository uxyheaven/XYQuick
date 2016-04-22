//
//  __  __          ____           _          _
//  \ \/ / /\_/\   /___ \  _   _  (_)   ___  | | __
//   \  /  \_ _/  //  / / | | | | | |  / __| | |/ /
//   /  \   / \  / \_/ /  | |_| | | | | (__  |   <
//  /_/\_\  \_/  \___,_\   \__,_| |_|  \___| |_|\_\
//
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

#import "XYTabBar.h"
#define kXYTabBar_itemStartTag  23200

@interface XYTabBar ()

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) UIImageView *backgroundView;

@end

@implementation XYTabBar

- (id)initWithFrame:(CGRect)frame items:(NSArray *)items
{
    self = [super initWithFrame:frame];
    if (self)
	{
		self.backgroundColor = [UIColor groupTableViewBackgroundColor];
		_backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
		[self addSubview:_backgroundView];
        
		self.items = [NSMutableArray arrayWithCapacity:[items count]];
		UIButton *btn;

		for (int i = 0; i < [items count]; i++)
        {
			btn = [UIButton buttonWithType:UIButtonTypeCustom];
			//btn.showsTouchWhenHighlighted = YES;
			btn.tag = i + kXYTabBar_itemStartTag;
            UIImage *image = nil;
            NSDictionary *item = [items objectAtIndex:i];
            
            // 设置图片
            image = [UIImage imageNamed:item[@"normal"]];
            if (image)
            {
                [btn setImage:image forState:UIControlStateNormal];
            }
            
            image = [UIImage imageNamed:item[@"highlighted"]];
            if (image)
            {
                [btn setImage:image forState:UIControlStateHighlighted];
            }
            
            image = [UIImage imageNamed:item[@"selected"]];
            if (image)
            {
                [btn setImage:image forState:UIControlStateSelected];
            }
            
            image = [UIImage imageNamed:item[@"disabled"]];
            if (image)
            {
                [btn setImage:image forState:UIControlStateDisabled];
            }
            
            // 设置文字
            NSString *text = item[@"text"];
            if (text)
            {
                [btn setTitle:text forState:UIControlStateNormal];
                btn.titleLabel.textAlignment = NSTextAlignmentCenter;
                btn.titleLabel.adjustsFontSizeToFitWidth = YES;
                //btn.titleLabel.numberOfLines = 0;
            }
            
			[btn addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
			[self.items addObject:btn];
			[self addSubview:btn];
            
            UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectZero];
            self.animatedView = view;
            [self addSubview:view];
            
		}
    }
    
    return self;
}

- (void)dealloc
{
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)setBackgroundImage:(UIImage *)img
{
    [_backgroundView setImage:img];
}

- (void)setAnimatedView:(UIImageView *)view
{
    if (_animatedView != view)
    {
        _animatedView = view;
        [self addSubview:_animatedView];
    }
}
- (void)setupItem:(UIButton *)item index:(NSInteger)index
{
    // 设置尺寸
    float w = self.bounds.size.width / self.items.count;
    item.frame = CGRectMake(0 + w * index, 0, w, self.frame.size.height);
    [item setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    item.titleLabel.font = [UIFont systemFontOfSize:12];
    
    // 设置图片和文字位置
    float imgW = 30;
    item.imageEdgeInsets = UIEdgeInsetsMake(0, (w - imgW) * .5 , self.bounds.size.height - imgW, (w - imgW) * .5);
    
    CGPoint buttonBoundsCenter = CGPointMake(CGRectGetMidX(item.bounds), CGRectGetMidY(item.bounds));
    // 找出titleLabel最终的center
    CGPoint endTitleLabelCenter = CGPointMake(buttonBoundsCenter.x, CGRectGetHeight(item.bounds) - CGRectGetMidY(item.titleLabel.bounds));
    // 取得titleLabel最初的center
    CGPoint startTitleLabelCenter = item.titleLabel.center;
    // 设置titleEdgeInsets
   // CGFloat titleEdgeInsetsTop = endTitleLabelCenter.y - startTitleLabelCenter.y;
    CGFloat titleEdgeInsetsLeft = endTitleLabelCenter.x - startTitleLabelCenter.x;
   // CGFloat titleEdgeInsetsBottom = -titleEdgeInsetsTop;
    CGFloat titleEdgeInsetsRight = -titleEdgeInsetsLeft;
    
    item.titleEdgeInsets = UIEdgeInsetsMake(imgW, titleEdgeInsetsLeft, 0, titleEdgeInsetsRight);
}
- (void)resetAnimatedView:(UIImageView *)animatedView index:(NSInteger)index
{
    UIButton *item = _items[index];
    
    [UIView animateWithDuration:0.1f animations:^{
        animatedView.frame = CGRectMake(item.frame.origin.x, item.frame.origin.y, item.frame.size.width, item.frame.size.height);
    }];
}
- (void)tabBarButtonClicked:(id)sender
{
    UIButton *btn = sender;
    NSInteger index = btn.tag - kXYTabBar_itemStartTag;
    if ([_delegate respondsToSelector:@selector(tabBar:shouldSelectIndex:)])
    {
        if (![_delegate tabBar:self shouldSelectIndex:index])
            return;
    }
    
    [self selectTabAtIndex:index];
}

- (void)selectTabAtIndex:(NSInteger)index
{
	for (int i = 0; i < [self.items count]; i++)
    {
		UIButton *btn = [self.items objectAtIndex:i];
		btn.selected = NO;
	}
    
	UIButton *btn = [self.items objectAtIndex:index];
	btn.selected = YES;
    
    if ([_delegate respondsToSelector:@selector(tabBar:didSelectIndex:)])
    {
        [_delegate tabBar:self didSelectIndex:index];
    }

    //NSLog(@"Select index: %ld",btn.tag);
    /*
    if (_animatedView && [_delegate respondsToSelector:@selector(tabBar:animatedView:item:index:)]) {
        [_delegate tabBar:self animatedView:_animatedView item:btn index:index];
    }
     */
}

@end

