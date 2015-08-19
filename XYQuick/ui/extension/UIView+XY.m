//
//  UIView+XY.m
//  TWP_SkyBookShelf
//
//  Created by Heaven on 13-7-31.
//
//

#import "UIView+XY.h"
#import "XYQuick_Predefine.h"
#import "XYSystemInfo.h"
#import "UIImage+XY.h"
#import "NSObject+XY.h"

DUMMY_CLASS(UIView_XY);

#define UIView_key_tapBlock       "UIView.tapBlock"
#define UIView_key_longPressBlock "UIView.longPressBlock"

@implementation UIView (XY)

- (void)uxy_addTapGestureWithTarget:(id)target action:(SEL)action
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:tap];
}
- (void)uxy_removeTapGesture
{
    for (UIGestureRecognizer *gesture in self.gestureRecognizers)
    {
        if ([gesture isKindOfClass:[UITapGestureRecognizer class]])
        {
            [self removeGestureRecognizer:gesture];
        }
    }
}

- (void)uxy_addTapGestureWithBlock:(UIViewCategoryNormalBlock)aBlock
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap)];
    [self addGestureRecognizer:tap];
    
    [self uxy_copyAssociatedObject:aBlock forKey:UIView_key_tapBlock];
}

- (void)actionTap
{
    UIViewCategoryNormalBlock block = [self uxy_getAssociatedObjectForKey:UIView_key_tapBlock];
    
    if (block)
    {
        block(self);
    }
}

- (void)uxy_addLongPressGestureWithBlock:(UIViewCategoryNormalBlock)aBlock
{
    UILongPressGestureRecognizer *tap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(actionLongPress)];
    [self addGestureRecognizer:tap];
    
    [self uxy_copyAssociatedObject:aBlock forKey:UIView_key_longPressBlock];
}

- (void)uxy_removeLongPressGesture
{
    for (UIGestureRecognizer *gesture in self.gestureRecognizers)
    {
        if ([gesture isKindOfClass:[UILongPressGestureRecognizer class]])
        {
            [self removeGestureRecognizer:gesture];
        }
    }
}

- (void)actionLongPress
{
    UIViewCategoryNormalBlock block = objc_getAssociatedObject(self, UIView_key_tapBlock);
    
    if (block)
    {
        block(self);
    }
}
/////////////////////////////////////////////////////////////
- (void)uxy_addShadeWithTarget:(id)target action:(SEL)action color:(UIColor *)aColor alpha:(float)aAlpha
{
    UIView *tmpView = [self uxy_shadeView];
    if (aColor)
    {
        tmpView.backgroundColor = aColor;
    }
    else
    {
        tmpView.backgroundColor = [UIColor blackColor];
    }
    tmpView.alpha = aAlpha;
    [self addSubview:tmpView];
    
    [tmpView uxy_addTapGestureWithTarget:target action:action];
}
- (void)uxy_addShadeWithBlock:(UIViewCategoryNormalBlock)aBlock color:(UIColor *)aColor alpha:(float)aAlpha
{
    UIView *tmpView = [self uxy_shadeView];
    if (aColor)
    {
        tmpView.backgroundColor = aColor;
    }
    else
    {
        tmpView.backgroundColor = [UIColor blackColor];
    }
    tmpView.alpha = aAlpha;
    [self addSubview:tmpView];
    
    if (aBlock)
    {
        [tmpView uxy_addTapGestureWithBlock:aBlock];
    }
}
- (void)uxy_removeShade{
    UIView *view = [self viewWithTag:UIView_shadeTag];
    if (view)
    {
        [UIView animateWithDuration:UIView_animation_instant delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            view.alpha = 0;
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }
}

- (UIView *)uxy_shadeView{
    UIView * view = [self viewWithTag:UIView_shadeTag];
    if (view == nil) {
        view = [[UIView alloc] initWithFrame:self.bounds];
        view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        view.tag = UIView_shadeTag;
    }
    
    return view;
}

// 增加毛玻璃背景
- (void)uxy_addBlurWithTarget:(id)target action:(SEL)action level:(int)lv
{
    UIView *tmpView = [self uxy_shadeView];
    [self addSubview:tmpView];
    tmpView.alpha = 0;
    //  BACKGROUND_BEGIN
    UIImage *img = [[self uxy_snapshot] uxy_stackBlur:lv];
    //   FOREGROUND_BEGIN
    tmpView.layer.contents = (id)img.CGImage;
    [UIView animateWithDuration:0.05 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        tmpView.alpha = 1;
    } completion:nil];
    //   FOREGROUND_COMMIT
    //   BACKGROUND_COMMIT
    [tmpView uxy_addTapGestureWithTarget:target action:action];
}
- (void)uxy_addBlurWithTarget:(id)target action:(SEL)action
{
    [self uxy_addBlurWithTarget:target action:action level:5];
}

- (void)uxy_addBlurWithBlock:(UIViewCategoryNormalBlock)aBlock level:(int)lv
{
    UIView *tmpView = [self uxy_shadeView];
    UIImage *img = [[self uxy_snapshot] uxy_stackBlur:lv];
    tmpView.layer.contents = (id)img.CGImage;
    [self addSubview:tmpView];
    
    if (aBlock)
    {
        [tmpView uxy_addTapGestureWithBlock:aBlock];
    }
}
- (void)uxy_addBlurWithBlock:(UIViewCategoryNormalBlock)aBlock
{
    [self uxy_addBlurWithBlock:aBlock level:10];
}

/////////////////////////////////////////////////////////////
- (instancetype)uxy_bg:(NSString *)str
{
    UIImage *image = [UIImage uxy_imageWithFileName:str];
    self.layer.contents = (id) image.CGImage;
    
    return self;
}

- (instancetype)uxy_rounded
{
    self.clipsToBounds = YES;
    self.layer.cornerRadius = self.bounds.size.width / 2;
    
    return self;
}

- (instancetype)uxy_rounded2
{
    CAShapeLayer *aCircle = [CAShapeLayer layer];
    aCircle.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.frame.size.height/2].CGPath;
    aCircle.fillColor = [UIColor blackColor].CGColor;
    self.layer.mask = aCircle;
    
    return self;
}

- (instancetype)uxy_roundedRectWith:(CGFloat)radius{
    self.clipsToBounds = YES;
    self.layer.cornerRadius = radius;
    
    return self;
}
- (instancetype)uxy_roundedRectWith:(CGFloat)radius byRoundingCorners:(UIRectCorner)corners
{
    UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer * maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    
    return self;
}

- (instancetype)uxy_borderWidth:(CGFloat)width color:(UIColor *)color
{
    self.layer.borderWidth = width;
    if (color)
    {
        self.layer.borderColor = color.CGColor;
    }
    
    return self;
}
/////////////////////////////////////////////////////////////
- (UIActivityIndicatorView *)uxy_activityIndicatorViewShow
{
    UIActivityIndicatorView *aView = (UIActivityIndicatorView *)[self viewWithTag:UIView_activityIndicatorViewTag];
    if (aView == nil)
    {
        aView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        aView.center = CGPointMake(self.bounds.size.width * .5, self.bounds.size.height * .5);
        aView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        aView.tag = UIView_activityIndicatorViewTag;
    }
    
    [self addSubview:aView];
    [aView startAnimating];
    
    aView.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        aView.alpha = 1;
    }];
    
    return aView;
}

- (void)uxy_activityIndicatorViewHidden
{
    UIActivityIndicatorView *aView = (UIActivityIndicatorView *)[self viewWithTag:UIView_activityIndicatorViewTag];
    if (aView)
    {
        [aView stopAnimating];
        aView.alpha = 1;
        
        [UIView animateWithDuration:.35 animations:^{
            aView.alpha = 0;
        } completion:^(BOOL finished) {
            [aView removeFromSuperview];
        }];
        
    }
}
/////////////////////////////////////////////////////////////
- (UIImage *)uxy_snapshot
{
    UIGraphicsBeginImageContext(self.bounds.size);
    if (UXY_IOS7_OR_LATER)
    {
        // 这个方法比ios6下的快15倍
        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    }
    else
    {
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (instancetype)uxy_rotate:(CGFloat)angle
{
    self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI * angle);
    
    return self;
}


- (void)uxy_showDataWithDic:(NSDictionary *)dic
{
    if (dic)
    {
        [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
            id tempObj = [self valueForKeyPath:key];
            if ([tempObj isKindOfClass:[UILabel class]])
            {
                NSString *str = [obj asNSString];
                [tempObj setText:str];
                
            }
            else if([tempObj isKindOfClass:[UIImageView class]])
            {
                if ([obj isKindOfClass:[UIImage class]])
                {
                    [tempObj setValue:obj forKey:@"image"];
                }
                else if ([obj isKindOfClass:[NSString class]])
                {
                    UIImage *tempImg = [UIImage uxy_imageWithFileName:obj];
                    [tempObj setValue:tempImg forKey:@"image"];
                }
            }
            else if (1)
            {
                [self setValue:obj forKeyPath:key];
            }
            
        }];
    }
}
// 子类需要重新此方法
- (void)setupDataBind:(NSMutableDictionary *)dic
{
    
}

- (void)uxy_removeFromSuperviewWithCrossfade
{
    self.alpha = 0;
    
    CAAnimation *animation = [NSClassFromString(@"CATransition") animation];
    [animation setValue:@"kCATransitionFade" forKey:@"type"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    animation.duration = .3;
    [self.layer addAnimation:animation forKey:nil];
    
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:.3];
}

- (void)uxy_removeAllSubviews
{
    for (UIView *temp in self.subviews)
    {
        [temp removeFromSuperview];
    }
}

- (void)uxy_removeSubviewWithTag:(NSInteger)tag
{
    for (UIView *temp in self.subviews)
    {
        if (temp.tag == tag)
        {
            [temp removeFromSuperview];
        }
    }
}

- (void)uxy_removeSubviewExceptTag:(NSInteger)tag
{
    for (UIView *temp in self.subviews)
    {
        if (temp.tag != tag)
        {
            [temp removeFromSuperview];
        }
    }
}

- (BOOL)uxy_isDisplayedInScreen
{
    CGRect screenRect = [UIScreen mainScreen].bounds;
    
    // 转换view对应window的Rect
    CGRect rect = [self convertRect:self.frame fromView:nil];
    if (CGRectIsEmpty(rect) || CGRectIsNull(rect)) {
        return FALSE;
    }
    
    // 若view 隐藏
    if (self.hidden) {
        return FALSE;
    }
    
    // 若没有superview
    if (self.superview == nil) {
        return FALSE;
    }
    
    // 若size为CGrectZero
    if (CGSizeEqualToSize(rect.size, CGSizeZero)) {
        return  FALSE;
    }
    
    // 获取 该view与window 交叉的 Rect
    CGRect intersectionRect = CGRectIntersection(rect, screenRect);
    if (CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect)) {
        return FALSE;
    }
    
    return YES;
}

#pragma mark - animation
- (void)uxy_animationCrossfadeWithDuration:(NSTimeInterval)duration
{
    //jump through a few hoops to avoid QuartzCore framework dependency
    CAAnimation *animation = [NSClassFromString(@"CATransition") animation];
    [animation setValue:@"kCATransitionFade" forKey:@"type"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    animation.duration = duration;
    [self.layer addAnimation:animation forKey:nil];
}

- (void)uxy_animationCrossfadeWithDuration:(NSTimeInterval)duration completion:(UIViewCategoryAnimationBlock)completion
{
    [self uxy_animationCrossfadeWithDuration:duration];
    if (completion)
    {
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC));
        dispatch_after(time, dispatch_get_main_queue(), completion);
    }
}

- (void)uxy_animationCubeWithDuration:(NSTimeInterval)duration direction:(NSString *)direction
{
    CATransition *transtion = [CATransition animation];
    transtion.duration = duration;
    [transtion setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [transtion setType:@"cube"];
    [transtion setSubtype:direction];
    [self.layer addAnimation:transtion forKey:@"transtionKey"];
}

- (void)uxy_animationCubeWithDuration:(NSTimeInterval)duration direction:(NSString *)direction completion:(UIViewCategoryAnimationBlock)completion
{
    [self uxy_animationCubeWithDuration:duration direction:direction];
    if (completion)
    {
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC));
        dispatch_after(time, dispatch_get_main_queue(), completion);
    }
}

- (void)uxy_animationOglFlipWithDuration:(NSTimeInterval)duration direction:(NSString *)direction
{
    CATransition *transtion = [CATransition animation];
    transtion.duration = duration;
    [transtion setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [transtion setType:@"oglFlip"];
    [transtion setSubtype:direction];
    [self.layer addAnimation:transtion forKey:@"transtionKey"];
}

- (void)uxy_animationOglFlipWithDuration:(NSTimeInterval)duration direction:(NSString *)direction completion:(void (^)(void))completion
{
    [self uxy_animationOglFlipWithDuration:duration direction:direction];
    if (completion)
    {
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC));
        dispatch_after(time, dispatch_get_main_queue(), completion);
    }
}

- (void)uxy_animationMoveInWithDuration:(NSTimeInterval)duration direction:(NSString *)direction
{
    CATransition *transtion = [CATransition animation];
    transtion.duration = duration;
    [transtion setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [transtion setType:kCATransitionMoveIn];
    [transtion setSubtype:direction];
    [self.layer addAnimation:transtion forKey:@"transtionKey"];
}

- (void)uxy_animationMoveInWithDuration:(NSTimeInterval)duration direction:(NSString *)direction completion:(UIViewCategoryAnimationBlock)completion
{
    [self uxy_animationMoveInWithDuration:duration direction:direction];
    if (completion)
    {
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC));
        dispatch_after(time, dispatch_get_main_queue(), completion);
    }
}

- (void)uxy_animationShake
{
    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //设置抖动幅度
    shake.fromValue    = [NSNumber numberWithFloat:-0.1];
    shake.toValue      = [NSNumber numberWithFloat:+0.1];
    shake.duration     = 0.06;
    shake.autoreverses = YES;//是否重复
    shake.repeatCount  = 3;
    [self.layer addAnimation:shake forKey:@"XYShake"];
}

- (UIViewController *)uxy_currentViewController
{
    id viewController = [self nextResponder];
    UIView *view      = self;
    
    while (viewController && ![viewController isKindOfClass:[UIViewController class]])
    {
        view           = [view superview];
        viewController = [view nextResponder];
    }
    
    return viewController;
}

@end


