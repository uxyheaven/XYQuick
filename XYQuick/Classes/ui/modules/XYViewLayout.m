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
//  This file Copy from ios-view-frame-builder.

#import "XYViewLayout.h"

#ifndef NS_ENUM
#define NS_ENUM(_type, _name) enum _name : _type _name; enum _name : _type
#endif

typedef NS_ENUM(NSUInteger, XYViewFrameBuilderEdge) {
    XYViewFrameBuilderEdgeTop,
    XYViewFrameBuilderEdgeBottom,
    XYViewFrameBuilderEdgeLeft,
    XYViewFrameBuilderEdgeRight,
};
static inline CGRect XYRectInsets(CGRect rect, CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
{
    return UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(top, left, bottom, right));
}

static inline CGRect XYRectWithSize(CGRect rect, CGFloat width, CGFloat height) {
    rect.size.width = width;
    rect.size.height = height;
    
    return rect;
}

static inline CGRect XYRectFromSize(CGFloat width, CGFloat height)
{
    return XYRectWithSize(CGRectZero, width, height);
}


static inline CGRect XYRectWithWidth(CGRect rect, CGFloat width)
{
    rect.size.width = width;
    
    return rect;
}

static inline CGRect XYRectWithHeight(CGRect rect, CGFloat height)
{
    rect.size.height = height;
    
    return rect;
}

static inline CGRect XYRectWithOrigin(CGRect rect, CGFloat x, CGFloat y)
{
    rect.origin.x = x;
    rect.origin.y = y;
    
    return rect;
}

static inline CGRect XYRectWithX(CGRect rect, CGFloat x)
{
    rect.origin.x = x;
    
    return rect;
}

static inline CGRect XYRectWithY(CGRect rect, CGFloat y)
{
    rect.origin.y = y;
    
    return rect;
}

static inline CGPoint XYPointWithOffset(CGPoint p, CGFloat dx, CGFloat dy)
{
    return CGPointMake(p.x + dx, p.y + dy);
}

static inline CGPoint XYPointCenterInSize(CGSize s)
{
    return CGPointMake(roundf(s.width / 2), roundf(s.height / 2));
}

static inline CGPoint XYPointIntegral(CGPoint point)
{
    point.x = floorf(point.x);
    point.y = floorf(point.y);
    return point;
}

static inline CGPoint XYRectCenter(CGRect rect)
{
    return XYPointIntegral((CGPoint){
        .x = CGRectGetMidX(rect),
        .y = CGRectGetMidY(rect)
    });
}

static inline CGRect XYRectMove(CGRect rect, CGFloat dx, CGFloat dy)
{
    rect.origin.x += dx;
    rect.origin.y += dy;
    
    return rect;
}

static inline CGSize XYEdgeInsetsInsetSize(CGSize size, UIEdgeInsets insets)
{
    size.width  -= (insets.left + insets.right);
    size.height -= (insets.top  + insets.bottom);

    return size;
}

static inline UIEdgeInsets XYEdgeInsetsUnion(UIEdgeInsets insets1, UIEdgeInsets insets2)
{
    insets1.top    += insets2.top;
    insets1.left   += insets2.left;
    insets1.bottom += insets2.bottom;
    insets1.right  += insets2.right;
    
    return insets1;
}

#pragma mark- XYViewFrameBuilder
@interface XYViewFrameBuilder ()

@property (nonatomic) CGRect frame;

@end

@implementation XYViewFrameBuilder

- (id)initWithView:(UIView *)view
{
    self = [super init];
    if (self)
    {
        _view = view;
        _frame = view.frame;
        _automaticallyCommitChanges = YES;
    }
    
    return self;
}

+ (XYViewFrameBuilder *)frameBuilderForView:(UIView *)view
{
    return [[[self class] alloc] initWithView:view];
}

#pragma mark - setter

- (void)setFrame:(CGRect)frame
{
    _frame = frame;
    
    if (self.automaticallyCommitChanges)
    {
        [self commit];
    }
}

#pragma mark - Impl

- (void)commit
{
    self.view.frame = self.frame;
}

- (void)reset
{
    self.frame = self.view.frame;
}

- (void)update:(void (^)(XYViewFrameBuilder *builder))block
{
    [self disableAutoCommit];
    block(self);
    [self commit];
}

- (XYViewFrameBuilder *)performChangesInGroupWithBlock:(void (^)(void))block
{
    BOOL automaticCommitEnabled = self.automaticallyCommitChanges;
    
    self.automaticallyCommitChanges = NO;
    block();
    self.automaticallyCommitChanges = automaticCommitEnabled;
    
    if (self.automaticallyCommitChanges)
    {
        [self commit];
    }
    
    return self;
}

#pragma mark - Configure

- (XYViewFrameBuilder *)enableAutoCommit
{
    self.automaticallyCommitChanges = YES;
    
    return self;
}

- (XYViewFrameBuilder *)disableAutoCommit
{
    self.automaticallyCommitChanges = NO;
    
    return self;
}

#pragma mark - Move

- (XYViewFrameBuilder *)setX:(CGFloat)x
{
    self.frame = XYRectWithX(self.frame, x);
    
    return self;
}

- (XYViewFrameBuilder *)setY:(CGFloat)y
{
    self.frame = XYRectWithY(self.frame, y);
    
    return self;
}

- (XYViewFrameBuilder *)setOriginWithX:(CGFloat)x y:(CGFloat)y
{
    return [self performChangesInGroupWithBlock:^{
        [[self setX:x] setY:y];
    }];
}

- (XYViewFrameBuilder *)moveWithOffsetX:(CGFloat)offsetX
{
    self.frame = XYRectWithX(self.frame, self.frame.origin.x + offsetX);
    
    return self;
}

- (XYViewFrameBuilder *)moveWithOffsetY:(CGFloat)offsetY
{
    self.frame = XYRectWithY(self.frame, self.frame.origin.y + offsetY);
    
    return self;
}

- (XYViewFrameBuilder *)moveWithOffsetX:(CGFloat)offsetX offsetY:(CGFloat)offsetY
{
    return [self performChangesInGroupWithBlock:^{
        [[self moveWithOffsetX:offsetX] moveWithOffsetY:offsetY];
    }];
}

- (XYViewFrameBuilder *)centerInSuperview
{
    return [self performChangesInGroupWithBlock:^{
        [[self centerHorizontallyInSuperview] centerVerticallyInSuperview];
    }];
}

- (XYViewFrameBuilder *)centerHorizontallyInSuperview
{
    if (!self.view.superview)
    {
        return self;
    }
    
    self.frame = XYRectWithX(self.frame, roundf((self.view.superview.bounds.size.width - self.frame.size.width) / 2));
    
    return self;
}

- (XYViewFrameBuilder *)centerVerticallyInSuperview
{
    if (!self.view.superview)
    {
        return self;
    }
    
    self.frame = XYRectWithY(self.frame, roundf((self.view.superview.bounds.size.height - self.frame.size.height) / 2));
    
    return self;
}

- (XYViewFrameBuilder *)alignToTopInSuperviewWithInset:(CGFloat)inset
{
    [self alignToTopInSuperviewWithInsets:UIEdgeInsetsMake(inset, 0.0f, 0.0f, 0.0f)];
    
    return self;
}

- (XYViewFrameBuilder *)alignToBottomInSuperviewWithInset:(CGFloat)inset
{
    [self alignToBottomInSuperviewWithInsets:UIEdgeInsetsMake(0.0f, 0.0f, inset, 0.0f)];
    
    return self;
}

- (XYViewFrameBuilder *)alignLeftInSuperviewWithInset:(CGFloat)inset
{
    [self alignLeftInSuperviewWithInsets:UIEdgeInsetsMake(0.0f, inset, 0.0f, 0.0f)];
    
    return self;
    
}

- (XYViewFrameBuilder *)alignRightInSuperviewWithInset:(CGFloat)inset
{
    [self alignRightInSuperviewWithInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, inset)];
    
    return self;
}

- (XYViewFrameBuilder *)alignToTopInSuperviewWithInsets:(UIEdgeInsets)insets
{
    self.frame = XYRectWithOrigin(self.frame,
                                  self.frame.origin.x + insets.left - insets.right,
                                  insets.top - insets.bottom);
    
    return self;
}

- (XYViewFrameBuilder *)alignToBottomInSuperviewWithInsets:(UIEdgeInsets)insets
{
    self.frame = XYRectWithOrigin(self.frame,
                                  self.frame.origin.x + insets.left - insets.right,
                                  self.view.superview.bounds.size.height - self.frame.size.height + insets.top - insets.bottom);
    
    return self;
}

- (XYViewFrameBuilder *)alignLeftInSuperviewWithInsets:(UIEdgeInsets)insets
{
    self.frame = XYRectWithOrigin(self.frame,
                                  insets.left - insets.right,
                                  self.frame.origin.y + insets.top - insets.bottom);
    
    return self;
}

- (XYViewFrameBuilder *)alignRightInSuperviewWithInsets:(UIEdgeInsets)insets
{
    self.frame = XYRectWithOrigin(self.frame,
                                  self.view.superview.bounds.size.width - self.frame.size.width + insets.left - insets.right,
                                  self.frame.origin.y + insets.top - insets.bottom);
    
    return self;
}

- (XYViewFrameBuilder *)alignToView:(UIView *)view edge:(XYViewFrameBuilderEdge)edge offset:(CGFloat)offset
{
    CGRect viewFrame = [view.superview convertRect:view.frame toView:self.view.superview];
    
    switch (edge)
    {
        case XYViewFrameBuilderEdgeTop:
            self.frame = XYRectWithY(self.frame, viewFrame.origin.y - offset - self.frame.size.height);
            break;
        case XYViewFrameBuilderEdgeBottom:
            self.frame = XYRectWithY(self.frame, CGRectGetMaxY(viewFrame) + offset);
            break;
        case XYViewFrameBuilderEdgeLeft:
            self.frame = XYRectWithX(self.frame, viewFrame.origin.x - offset - self.frame.size.width);
            break;
        case XYViewFrameBuilderEdgeRight:
            self.frame = XYRectWithX(self.frame, CGRectGetMaxX(viewFrame) + offset);
            break;
        default:
            break;
    }
    
    return self;
}

- (XYViewFrameBuilder *)alignToTopOfView:(UIView *)view offset:(CGFloat)offset
{
    return [self alignToView:view edge:XYViewFrameBuilderEdgeTop offset:offset];
}

- (XYViewFrameBuilder *)alignToBottomOfView:(UIView *)view offset:(CGFloat)offset
{
    return [self alignToView:view edge:XYViewFrameBuilderEdgeBottom offset:offset];
}

- (XYViewFrameBuilder *)alignLeftOfView:(UIView *)view offset:(CGFloat)offset
{
    return [self alignToView:view edge:XYViewFrameBuilderEdgeLeft offset:offset];
}

- (XYViewFrameBuilder *)alignRightOfView:(UIView *)view offset:(CGFloat)offset
{
    return [self alignToView:view edge:XYViewFrameBuilderEdgeRight offset:offset];
}

+ (void)alignViews:(NSArray *)views direction:(XYViewFrameBuilderDirection)direction spacing:(CGFloat)spacing {
    return [self alignViews:views direction:direction spacingWithBlock:^CGFloat(UIView *firstView, UIView *secondView) {
        return spacing;
    }];;
}

+ (void)alignViews:(NSArray *)views direction:(XYViewFrameBuilderDirection)direction spacingWithBlock:(CGFloat (^)(UIView *firstView, UIView *secondView))block
{
    UIView *previousView = nil;
    for (UIView *view in views)
    {
        if (previousView)
        {
            CGFloat spacing = block != nil ? block(previousView, view) : 0.0f;
            
            switch (direction)
            {
                case XYViewFrameBuilderDirectionRight:
                    [[[self class] frameBuilderForView:view] alignRightOfView:previousView offset:spacing];
                    break;
                case XYViewFrameBuilderDirectionLeft:
                    [[[self class] frameBuilderForView:view] alignLeftOfView:previousView offset:spacing];
                    break;
                case XYViewFrameBuilderDirectionUp:
                    [[[self class] frameBuilderForView:view] alignToTopOfView:previousView offset:spacing];
                    break;
                case XYViewFrameBuilderDirectionDown:
                    [[[self class] frameBuilderForView:view] alignToBottomOfView:previousView offset:spacing];
                    break;
                default:
                    break;
            }
        }
        
        previousView = view;
    }
}

+ (void)alignViewsVertically:(NSArray *)views spacing:(CGFloat)spacing
{
    [self alignViewsVertically:views spacingWithBlock:^CGFloat(UIView *firstView, UIView *secondView) {
        return spacing;
    }];
}

+ (void)alignViewsVertically:(NSArray *)views spacingWithBlock:(CGFloat (^)(UIView *firstView, UIView *secondView))block
{
    [self alignViews:views direction:XYViewFrameBuilderDirectionDown spacingWithBlock:block];
}

+ (void)alignViewsHorizontally:(NSArray *)views spacing:(CGFloat)spacing
{
    [self alignViewsHorizontally:views spacingWithBlock:^CGFloat(UIView *firstView, UIView *secondView) {
        return spacing;
    }];
}

+ (void)alignViewsHorizontally:(NSArray *)views spacingWithBlock:(CGFloat (^)(UIView *firstView, UIView *secondView))block
{
    [self alignViews:views direction:XYViewFrameBuilderDirectionRight spacingWithBlock:block];
}

+ (CGFloat)heightForViewsAlignedVertically:(NSArray *)views spacing:(CGFloat)spacing
{
    return [self heightForViewsAlignedVertically:views constrainedToWidth:0.0f spacing:spacing];
}

+ (CGFloat)heightForViewsAlignedVertically:(NSArray *)views spacingWithBlock:(CGFloat (^)(UIView *firstView, UIView *secondView))block
{
    return [self heightForViewsAlignedVertically:views constrainedToWidth:0.0f spacingWithBlock:block];
}

+ (CGFloat)heightForViewsAlignedVertically:(NSArray *)views constrainedToWidth:(CGFloat)constrainedWidth spacing:(CGFloat)spacing
{
    return [self heightForViewsAlignedVertically:views constrainedToWidth:constrainedWidth spacingWithBlock:^CGFloat(UIView *firstView, UIView *secondView) {
        return spacing;
    }];
}

+ (CGFloat)heightForViewsAlignedVertically:(NSArray *)views constrainedToWidth:(CGFloat)constrainedWidth spacingWithBlock:(CGFloat (^)(UIView *firstView, UIView *secondView))block
{
    CGFloat height = 0.0f;
    
    UIView *previousView = nil;
    for (UIView *view in views)
    {
        if (constrainedWidth > FLT_EPSILON)
        {
            height += [view sizeThatFits:CGSizeMake(constrainedWidth, CGFLOAT_MAX)].height;
        }
        else
        {
            height += view.bounds.size.height;
        }
        
        if (previousView)
        {
            height += block != nil ? block(previousView, view) : 0.0f;
        }
        
        previousView = view;
    }
    
    return height;
}

#pragma mark - Resize

- (XYViewFrameBuilder *)setWidth:(CGFloat)width
{
    self.frame = XYRectWithWidth(self.frame, width);
    
    return self;
}

- (XYViewFrameBuilder *)setHeight:(CGFloat)height
{
    self.frame = XYRectWithHeight(self.frame, height);
    
    return self;
}

- (XYViewFrameBuilder *)setSize:(CGSize)size
{
    self.frame = XYRectWithSize(self.frame, size.width, size.height);
    
    return self;
}

- (XYViewFrameBuilder *)setSizeWithWidth:(CGFloat)width height:(CGFloat)height
{
    return [self performChangesInGroupWithBlock:^{
        [[self setWidth:width] setHeight:height];
    }];
}

- (XYViewFrameBuilder *)setSizeToFitWidth
{
    CGRect frame = self.frame;
    frame.size.width = [self.view sizeThatFits:CGSizeMake(CGFLOAT_MAX, self.frame.size.height)].width;
    self.frame = frame;
    
    return self;
}

- (XYViewFrameBuilder *)setSizeToFitHeight
{
    CGRect frame = self.frame;
    frame.size.height = [self.view sizeThatFits:CGSizeMake(self.frame.size.width, CGFLOAT_MAX)].height;
    self.frame = frame;
    
    return self;
}

- (XYViewFrameBuilder *)setSizeToFit
{
    CGSize size = [self.view sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    
    CGRect frame = self.frame;
    frame.size.height = size.height;
    frame.size.width = size.width;
    self.frame = frame;
    
    return self;
}

+ (void)sizeToFitViews:(NSArray *)views
{
    for (UIView *view in views)
    {
        [view sizeToFit];
    }
}

+ (void)__test
{
    XYRectInsets(CGRectZero, 0, 0, 0, 0);
    XYRectWithSize(CGRectZero, 0, 0);
    XYRectFromSize(0, 0);
    XYRectWithWidth(CGRectZero, 0);
    XYRectWithHeight(CGRectZero, 0);
    XYRectWithOrigin(CGRectZero, 0, 0);
    XYRectWithX(CGRectZero, 0);
    XYRectWithY(CGRectZero, 0);
    XYPointWithOffset(CGPointZero, 0, 0);
    XYPointCenterInSize(CGSizeZero);
    XYPointIntegral(CGPointZero);
    XYRectCenter(CGRectZero);
    XYRectMove(CGRectZero, 0, 0);
    XYEdgeInsetsInsetSize(CGSizeZero, UIEdgeInsetsZero);
    XYEdgeInsetsUnion(UIEdgeInsetsZero, UIEdgeInsetsZero);
}

@end


@implementation UIView (uxy_frameBuilder)

- (XYViewFrameBuilder *)uxy_frameBuilder
{
    return [XYViewFrameBuilder frameBuilderForView:self];
}

@end

@implementation UIView (uxy_positioning)

@dynamic uxy_x;
@dynamic uxy_y;
@dynamic uxy_width;
@dynamic uxy_height;
@dynamic uxy_origin;
@dynamic uxy_size;

// Setters
- (void)setUxy_x:(CGFloat)x
{
    CGRect r        = self.frame;
    r.origin.x      = x;
    self.frame      = r;
}

- (void)setUxy_y:(CGFloat)y
{
    CGRect r        = self.frame;
    r.origin.y      = y;
    self.frame      = r;
}

- (void)setUxy_width:(CGFloat)width
{
    CGRect r        = self.frame;
    r.size.width    = width;
    self.frame      = r;
}

- (void)setUxy_height:(CGFloat)height
{
    CGRect r        = self.frame;
    r.size.height   = height;
    self.frame      = r;
}

- (void)setUxy_origin:(CGPoint)origin
{
    self.uxy_x          = origin.x;
    self.uxy_y          = origin.y;
}

- (void)setUxy_size:(CGSize)size
{
    self.uxy_width      = size.width;
    self.uxy_height     = size.height;
}

- (void)setUxy_right:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (void)setUxy_bottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (void)setUxy_centerX:(CGFloat)centerX
{
    self.center = CGPointMake(centerX, self.center.y);
}

- (void)setUxy_centerY:(CGFloat)centerY
{
    self.center = CGPointMake(self.center.x, centerY);
}

// Getters
- (CGFloat)uxy_x
{
    return self.frame.origin.x;
}

- (CGFloat)uxy_y
{
    return self.frame.origin.y;
}

- (CGFloat)uxy_width
{
    return self.frame.size.width;
}

- (CGFloat)uxy_height
{
    return self.frame.size.height;
}

- (CGPoint)uxy_origin
{
    return CGPointMake(self.uxy_x, self.uxy_y);
}

- (CGSize)uxy_size
{
    return CGSizeMake(self.uxy_width, self.uxy_height);
}

- (CGFloat)uxy_right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)uxy_bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat)uxy_centerX
{
    return self.center.x;
}

- (CGFloat)uxy_centerY
{
    return self.center.y;
}

- (UIView *)uxy_lastSubviewOnX
{
    if (self.subviews.count > 0)
    {
        UIView *outView = self.subviews[0];
        
        for(UIView *v in self.subviews)
        {
            if(v.uxy_x > outView.uxy_x)
                outView = v;
        }
        
        return outView;
    }
    
    return nil;
}

- (UIView *)uxy_lastSubviewOnY
{
    if(self.subviews.count > 0)
    {
        UIView *outView = self.subviews[0];
        
        for(UIView *v in self.subviews)
        {
            if(v.uxy_y > outView.uxy_y)
                outView = v;
        }
        
        return outView;
    }
    
    return nil;
}

@end
