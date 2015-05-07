//
//  UIView+XY_coordinate.h
//  JoinShow
//
//  Created by Heaven on 14-2-14.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//  copy by https://github.com/podio/ios-view-frame-builder

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, XYViewFrameBuilderDirection) {
    XYViewFrameBuilderDirectionRight = 0,
    XYViewFrameBuilderDirectionLeft,
    XYViewFrameBuilderDirectionUp,
    XYViewFrameBuilderDirectionDown,
};

@interface XYViewFrameBuilder : NSObject

@property (nonatomic, assign, readonly) UIView *view;
@property (nonatomic) BOOL automaticallyCommitChanges; // Default is YES

- (id)initWithView:(UIView *)view;

+ (XYViewFrameBuilder *)frameBuilderForView:(UIView *)view;

- (void)commit;
- (void)reset;
- (void)update:(void (^)(XYViewFrameBuilder *builder))block;

// Configure
- (XYViewFrameBuilder *)enableAutoCommit;
- (XYViewFrameBuilder *)disableAutoCommit;

// Move
- (XYViewFrameBuilder *)setX:(CGFloat)x;
- (XYViewFrameBuilder *)setY:(CGFloat)y;
- (XYViewFrameBuilder *)setOriginWithX:(CGFloat)x y:(CGFloat)y;

- (XYViewFrameBuilder *)moveWithOffsetX:(CGFloat)offsetX;
- (XYViewFrameBuilder *)moveWithOffsetY:(CGFloat)offsetY;
- (XYViewFrameBuilder *)moveWithOffsetX:(CGFloat)offsetX offsetY:(CGFloat)offsetY;

- (XYViewFrameBuilder *)centerInSuperview;
- (XYViewFrameBuilder *)centerHorizontallyInSuperview;
- (XYViewFrameBuilder *)centerVerticallyInSuperview;

- (XYViewFrameBuilder *)alignToTopInSuperviewWithInset:(CGFloat)inset;
- (XYViewFrameBuilder *)alignToBottomInSuperviewWithInset:(CGFloat)inset;
- (XYViewFrameBuilder *)alignLeftInSuperviewWithInset:(CGFloat)inset;
- (XYViewFrameBuilder *)alignRightInSuperviewWithInset:(CGFloat)inset;

- (XYViewFrameBuilder *)alignToTopInSuperviewWithInsets:(UIEdgeInsets)insets;
- (XYViewFrameBuilder *)alignToBottomInSuperviewWithInsets:(UIEdgeInsets)insets;
- (XYViewFrameBuilder *)alignLeftInSuperviewWithInsets:(UIEdgeInsets)insets;
- (XYViewFrameBuilder *)alignRightInSuperviewWithInsets:(UIEdgeInsets)insets;

- (XYViewFrameBuilder *)alignToTopOfView:(UIView *)view offset:(CGFloat)offset;
- (XYViewFrameBuilder *)alignToBottomOfView:(UIView *)view offset:(CGFloat)offset;
- (XYViewFrameBuilder *)alignLeftOfView:(UIView *)view offset:(CGFloat)offset;
- (XYViewFrameBuilder *)alignRightOfView:(UIView *)view offset:(CGFloat)offset;

+ (void)alignViews:(NSArray *)views direction:(XYViewFrameBuilderDirection)direction spacing:(CGFloat)spacing;
+ (void)alignViews:(NSArray *)views direction:(XYViewFrameBuilderDirection)direction spacingWithBlock:(CGFloat (^)(UIView *firstView, UIView *secondView))block;

+ (void)alignViewsVertically:(NSArray *)views spacing:(CGFloat)spacing;
+ (void)alignViewsVertically:(NSArray *)views spacingWithBlock:(CGFloat (^)(UIView *firstView, UIView *secondView))block;
+ (void)alignViewsHorizontally:(NSArray *)views spacing:(CGFloat)spacing;
+ (void)alignViewsHorizontally:(NSArray *)views spacingWithBlock:(CGFloat (^)(UIView *firstView, UIView *secondView))block;

+ (CGFloat)heightForViewsAlignedVertically:(NSArray *)views spacing:(CGFloat)spacing;
+ (CGFloat)heightForViewsAlignedVertically:(NSArray *)views spacingWithBlock:(CGFloat (^)(UIView *firstView, UIView *secondView))block;

+ (CGFloat)heightForViewsAlignedVertically:(NSArray *)views constrainedToWidth:(CGFloat)constrainedWidth spacing:(CGFloat)spacing;
+ (CGFloat)heightForViewsAlignedVertically:(NSArray *)views constrainedToWidth:(CGFloat)constrainedWidth spacingWithBlock:(CGFloat (^)(UIView *firstView, UIView *secondView))block;

// Resize
- (XYViewFrameBuilder *)setWidth:(CGFloat)width;
- (XYViewFrameBuilder *)setHeight:(CGFloat)height;
- (XYViewFrameBuilder *)setSize:(CGSize)size;
- (XYViewFrameBuilder *)setSizeWithWidth:(CGFloat)width height:(CGFloat)height;
- (XYViewFrameBuilder *)setSizeToFitWidth;
- (XYViewFrameBuilder *)setSizeToFitHeight;
- (XYViewFrameBuilder *)setSizeToFit;

+ (void)sizeToFitViews:(NSArray *)views;

@end


@interface UIView (uxy_frameBuilder)

- (XYViewFrameBuilder *)uxy_frameBuilder;

@end


@interface UIView (uxy_positioning)

@property (nonatomic, assign) CGFloat   uxy_x;
@property (nonatomic, assign) CGFloat   uxy_y;
@property (nonatomic, assign) CGFloat   uxy_width;
@property (nonatomic, assign) CGFloat   uxy_height;
@property (nonatomic, assign) CGPoint   uxy_origin;
@property (nonatomic, assign) CGSize    uxy_size;
@property (nonatomic, assign) CGFloat   uxy_bottom;
@property (nonatomic, assign) CGFloat   uxy_right;
@property (nonatomic, assign) CGFloat   uxy_centerX;
@property (nonatomic, assign) CGFloat   uxy_centerY;
@property (nonatomic, weak, readonly) UIView *uxy_lastSubviewOnX;
@property (nonatomic, weak, readonly) UIView *uxy_lastSubviewOnY;

@end

