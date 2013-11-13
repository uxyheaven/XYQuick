//  Created by Heaven on 13-4-3.
//
//

#import "XYAnimationView.h"

@implementation XYAnimationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)dealloc{
    self.imagesNameArray = nil;
    self.tapGesture = nil;
    self.pinchGesture = nil;
    self.panGesture = nil;
    self.longGesture = nil;
    self.swipeGesture = nil;
    self.rotationGesture = nil;
    
    [super dealloc];
}
#pragma mark - 手势
// 手势
-(void)addGestureTap{
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    self.tapGesture = gesture;
    if (![gesture respondsToSelector:@selector(locationInView:)]) {
        [gesture release];
        gesture = nil;
    }else {
        gesture.delegate = self;
        gesture.numberOfTapsRequired = 1; // The default value is 1.
        gesture.numberOfTouchesRequired = 1; // The default value is 1.
        [self addGestureRecognizer:gesture];
    }
}
- (void)handleTapGesture:(UIGestureRecognizer *)gestureRecognizer
{
    UIView *view = [gestureRecognizer view]; // 这个view是手势所属的view，也就是增加手势的那个view
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateEnded:{
            // UIGestureRecognizerStateRecognized = UIGestureRecognizerStateEnded // 正常情况下只响应这个消息
            NSLog(@"======UIGestureRecognizerStateEnded || UIGestureRecognizerStateRecognized");
            break;
        }
        case UIGestureRecognizerStateFailed:{ //
            NSLog(@"======UIGestureRecognizerStateFailed");
            break;
        }
        case UIGestureRecognizerStatePossible:{ //
            NSLog(@"======UIGestureRecognizerStatePossible");
            break;
        }
        default:{
            NSLog(@"======Unknow gestureRecognizer");
            break;
        }
    }
}

// 询问一个手势接收者是否应该开始解释执行一个触摸接收事件
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    //    CGPoint currentPoint = [gestureRecognizer locationInView:self.view];
    //    if (CGRectContainsPoint(CGRectMake(0, 0, 100, 100), currentPoint) ) {
    //        return YES;
    //    }
    //
    //    return NO;
    
    return YES;
}

// 询问delegate，两个手势是否同时接收消息，返回YES同事接收。返回NO，不同是接收（如果另外一个手势返回YES，则并不能保证不同时接收消息）the default implementation returns NO。
// 这个函数一般在一个手势接收者要阻止另外一个手势接收自己的消息的时候调用
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return NO;
}

// 询问delegate是否允许手势接收者接收一个touch对象
// 返回YES，则允许对这个touch对象审核，NO，则不允许。
// 这个方法在touchesBegan:withEvent:之前调用，为一个新的touch对象进行调用
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return YES;
}

-(void)addGesturePinch{
    UIPinchGestureRecognizer *gesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    self.pinchGesture = gesture;
    if (![gesture respondsToSelector:@selector(locationInView:)]) {
        [gesture release];
        gesture = nil;
    }else {
        gesture.delegate = self;
        [self addGestureRecognizer: gesture];
    }
}

- (void)handlePinchGesture:(UIPinchGestureRecognizer *)gestureRecognizer
{
    UIView *view = [gestureRecognizer view]; // 这个view是手势所属的view，也就是增加手势的那个view

    CGFloat scale = gestureRecognizer.scale;
    NSLog(@"======scale: %f", scale);
    
    CGFloat velocity = gestureRecognizer.velocity;
    NSLog(@"======scvelocityale: %f", velocity);

    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateEnded:{ // UIGestureRecognizerStateRecognized = UIGestureRecognizerStateEnded
            NSLog(@"======UIGestureRecognizerStateEnded || UIGestureRecognizerStateRecognized");
            break;
        }
        case UIGestureRecognizerStateBegan:{ //
            NSLog(@"======UIGestureRecognizerStateBegan");
            break;
        }
        case UIGestureRecognizerStateChanged:{ //
            NSLog(@"======UIGestureRecognizerStateChanged");
            
            gestureRecognizer.view.transform = CGAffineTransformScale(gestureRecognizer.view.transform, gestureRecognizer.scale, gestureRecognizer.scale);
            gestureRecognizer.scale = 1; // 重置，很重要！！！
            
            break;
        }
        case UIGestureRecognizerStateCancelled:{ //
            NSLog(@"======UIGestureRecognizerStateCancelled");
            break;
        }
        case UIGestureRecognizerStateFailed:{ //
            NSLog(@"======UIGestureRecognizerStateFailed");
            break;
        }
        case UIGestureRecognizerStatePossible:{ //
            NSLog(@"======UIGestureRecognizerStatePossible");
            break;
        }
        default:{
            NSLog(@"======Unknow gestureRecognizer");
            break;
        }
    }
}

-(void)addGesturePan{
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    self.panGesture = gesture;
    if (![gesture respondsToSelector:@selector(locationInView:)]) {
        [gesture release];
        gesture = nil;
    }else {
        gesture.delegate = self;
        gesture.maximumNumberOfTouches = NSUIntegerMax;// The default value is NSUIntegerMax.
        /*
         NSUIntegerMax : The maximum value for an NSUInteger.
         */
        gesture.minimumNumberOfTouches = 1;// The default value is 1.
        [self addGestureRecognizer:gesture];
    }
}

// 拖拽手势
- (void)handlePanGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    UIView *view = [gestureRecognizer view]; // 这个view是手势所属的view，也就是增加手势的那个view 
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:{
            NSLog(@"======UIGestureRecognizerStateBegan");
            break;
        }
        case UIGestureRecognizerStateChanged:{
            NSLog(@"======UIGestureRecognizerStateChanged");
            
            /*
             让view跟着手指移动
             
             1.获取每次系统捕获到的手指移动的偏移量translation
             2.根据偏移量translation算出当前view应该出现的位置
             3.设置view的新frame
             4.将translation重置为0（十分重要。否则translation每次都会叠加，很快你的view就会移除屏幕！）
             */
            
            CGPoint translation = [gestureRecognizer translationInView:self];
            self.center = CGPointMake(gestureRecognizer.view.center.x + translation.x, gestureRecognizer.view.center.y + translation.y);
            [gestureRecognizer setTranslation:CGPointMake(0, 0) inView:self];            break;
        }
        case UIGestureRecognizerStateCancelled:{
            NSLog(@"======UIGestureRecognizerStateCancelled");
            break;
        }
        case UIGestureRecognizerStateFailed:{
            NSLog(@"======UIGestureRecognizerStateFailed");
            break;
        }
        case UIGestureRecognizerStatePossible:{
            NSLog(@"======UIGestureRecognizerStatePossible");
            break;
        }
        case UIGestureRecognizerStateEnded:{ // UIGestureRecognizerStateRecognized = UIGestureRecognizerStateEnded
            /*
             当手势结束后，view的减速缓冲效果
             
             模拟减速写的一个很简单的方法。它遵循如下策略：
             计算速度向量的长度（i.e. magnitude）
             如果长度小于200，则减少基本速度，否则增加它。
             基于速度和滑动因子计算终点
             确定终点在视图边界内
             让视图使用动画到达最终的静止点
             使用“Ease out“动画参数，使运动速度随着时间降低
             */
            
            NSLog(@"======UIGestureRecognizerStateEnded || UIGestureRecognizerStateRecognized");
            
            CGPoint velocity = [gestureRecognizer velocityInView:self];// 分别得出x，y轴方向的速度向量长度（velocity代表按照当前速度，每秒可移动的像素个数，分xy轴两个方向）
            CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));// 根据直角三角形的算法算出综合速度向量长度
            
            // 如果长度小于200，则减少基本速度，否则增加它。
            CGFloat slideMult = magnitude / 200;
            
            NSLog(@"magnitude: %f, slideMult: %f", magnitude, slideMult);
            float slideFactor = 0.1 * slideMult; // Increase for more of a slide
            
            // 基于速度和滑动因子计算终点
            CGPoint finalPoint = CGPointMake(view.center.x + (velocity.x * slideFactor),
                                             view.center.y + (velocity.y * slideFactor));
            
            // 确定终点在视图边界内
            finalPoint.x = MIN(MAX(finalPoint.x, 0), self.bounds.size.width);
            finalPoint.y = MIN(MAX(finalPoint.y, 0), self.bounds.size.height);
            
            [UIView animateWithDuration:slideFactor*2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                view.center = finalPoint;
            } completion:nil];
            
            break;
        }
        default:{
            NSLog(@"======Unknow gestureRecognizer");
            break;
        }
    } 
}
-(void)addGestureLong{
    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongGesture:)];
    self.longGesture = gesture;
    if (![gesture respondsToSelector:@selector(locationInView:)]) {
        [gesture release];
        gesture = nil;
    }else {
        gesture.delegate = self;
        gesture.numberOfTapsRequired = 0;      // The default number of taps is 0.
        gesture.minimumPressDuration = 0.5f;    // The default duration is is 0.5 seconds.
        gesture.numberOfTouchesRequired = 1;   // The default number of fingers is 1.
        gesture.allowableMovement = 10;        // The default distance is 10 pixels.
        [self addGestureRecognizer:gesture];
    }
}

- (void)handleLongGesture:(UIGestureRecognizer *)gestureRecognizer
{
    UIView *view = [gestureRecognizer view]; // 这个view是手势所属的view，也就是增加手势的那个view
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateEnded:{ // UIGestureRecognizerStateRecognized = UIGestureRecognizerStateEnded
            NSLog(@"======UIGestureRecognizerStateEnded || UIGestureRecognizerStateRecognized");
            break;
        }
        case UIGestureRecognizerStateBegan:{ //
            NSLog(@"======UIGestureRecognizerStateBegan");
            break;
        }
        case UIGestureRecognizerStateChanged:{ //
            NSLog(@"======UIGestureRecognizerStateChanged");
            break;
        }
        case UIGestureRecognizerStateCancelled:{ //
            NSLog(@"======UIGestureRecognizerStateCancelled");
            break;
        }
        case UIGestureRecognizerStateFailed:{ //
            NSLog(@"======UIGestureRecognizerStateFailed");
            break;
        }
        case UIGestureRecognizerStatePossible:{ //
            NSLog(@"======UIGestureRecognizerStatePossible");
            break;
        }
        default:{
            NSLog(@"======Unknow gestureRecognizer");
            break;
        }
    }
}
/*
// 询问一个手势接收者是否应该开始解释执行一个触摸接收事件
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    CGPoint currentPoint = [gestureRecognizer locationInView:self.view];
    if (CGRectContainsPoint(CGRectMake(0, 0, 100, 100), currentPoint) ) {
        return YES;
    }
    
    return NO;
}

// 询问delegate，两个手势是否同时接收消息，返回YES同事接收。返回NO，不同是接收（如果另外一个手势返回YES，则并不能保证不同时接收消息）the default implementation returns NO。
// 这个函数一般在一个手势接收者要阻止另外一个手势接收自己的消息的时候调用
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return NO;
}

// 询问delegate是否允许手势接收者接收一个touch对象
// 返回YES，则允许对这个touch对象审核，NO，则不允许。
// 这个方法在touchesBegan:withEvent:之前调用，为一个新的touch对象进行调用
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return YES;
}
 */
-(void)addGestureSwipe{
    
}

-(void)addGestureRotation{
    UIRotationGestureRecognizer *gesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotationGesture:)];
    self.rotationGesture = gesture;
    if (![gesture respondsToSelector:@selector(locationInView:)]) {
        [gesture release];
        gesture = nil;
    }else {
        gesture.delegate = self;
        [self addGestureRecognizer:gesture];
    }
}

- (void)handleRotationGesture:(UIRotationGestureRecognizer *)gestureRecognizer
{
    UIView *view = [gestureRecognizer view]; // 这个view是手势所属的view，也就是增加手势的那个view 
    /*
     rotation属性： 可以理解为两手指之间的旋转的角度，其实是个比例，相对角度，不是绝对角度
     以刚开始的两个手指对应的两个point的之间的那条直线为标准，此时rotation=1.
     向顺时针旋转，则rotation为正数且不断变大，当旋转360度时，rotation大概为6左右，如果继续顺时针旋转，则角度会不断增加，两圈为12左右，此时若逆时针旋转，角度则不断变小
     向逆时针旋转，则rotation为负数且不断变小，当旋转360度时，rotation大概为-6左右
     
     velocity属性： 可以理解为两手指之间的移动速度，其实是个速度比例，相对速度，不是绝对速度
     以刚开始的两个手指对应的两个point的之间的距离为标准，此时velocity=0.
     若两手指向顺时针旋转，则velocity为正数，从0开始，随着手指向里捏合的速度越快，值越大，没有上限
     若两手指向逆时针旋转，则velocity为负数数，没有上限，从-0开始，随着手指向外捏合的速度越快，值越小，没有上限
     */
    CGFloat rotation = gestureRecognizer.rotation;
    NSLog(@"===rotation: %f", rotation);
    
    CGFloat velocity = gestureRecognizer.velocity;
    NSLog(@"======velocity: %f", velocity);

    /*
     旋转手势
     
     这个一般情况下只响应
     UIGestureRecognizerStateBegan、
     UIGestureRecognizerStateEnded || UIGestureRecognizerStateRecognized、
     UIGestureRecognizerStateChanged消息，
     一个UIGestureRecognizerStateBegan，接下去是N多的UIGestureRecognizerStateChanged，scale的值此时会不断的变化，当手指离开时，响应UIGestureRecognizerStateEnded || UIGestureRecognizerStateRecognized
     */
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateEnded:{ // UIGestureRecognizerStateRecognized = UIGestureRecognizerStateEnded
            NSLog(@"======UIGestureRecognizerStateEnded || UIGestureRecognizerStateRecognized");
            break;
        }
        case UIGestureRecognizerStateBegan:{ //
            NSLog(@"======UIGestureRecognizerStateBegan");
            break;
        }
        case UIGestureRecognizerStateChanged:{ //
            NSLog(@"======UIGestureRecognizerStateChanged");
            
            gestureRecognizer.view.transform = CGAffineTransformRotate(gestureRecognizer.view.transform, gestureRecognizer.rotation);
            gestureRecognizer.rotation = 0; // 重置 这个相当重要！！！
            
            break;
        }
        case UIGestureRecognizerStateCancelled:{ //
            NSLog(@"======UIGestureRecognizerStateCancelled");
            break;
        }
        case UIGestureRecognizerStateFailed:{ //
            NSLog(@"======UIGestureRecognizerStateFailed");
            break;
        }
        case UIGestureRecognizerStatePossible:{ //
            NSLog(@"======UIGestureRecognizerStatePossible");
            break;
        }
        default:{
            NSLog(@"======Unknow gestureRecognizer");
            break;
        }
    } 
}
@end
