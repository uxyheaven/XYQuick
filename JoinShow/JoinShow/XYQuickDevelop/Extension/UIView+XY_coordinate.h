//
//  UIView+XY_coordinate.h
//  JoinShow
//
//  Created by Heaven on 14-2-14.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//  copy by https://github.com/podio/ios-view-frame-builder

#import <UIKit/UIKit.h>
// #define po_frameBuilder xy_frameBuilder
// #define POViewFrameBuilder XYViewFrameBuilder

typedef NS_ENUM(NSUInteger, POViewFrameBuilderDirection) {
    POViewFrameBuilderDirectionRight = 0,
    POViewFrameBuilderDirectionLeft,
    POViewFrameBuilderDirectionUp,
    POViewFrameBuilderDirectionDown,
};

@interface POViewFrameBuilder : NSObject

@property (nonatomic, assign, readonly) UIView *view;
@property (nonatomic) BOOL automaticallyCommitChanges; // Default is YES

- (id)initWithView:(UIView *)view;

+ (POViewFrameBuilder *)frameBuilderForView:(UIView *)view;

- (void)commit;
- (void)reset;
- (void)update:(void (^)(POViewFrameBuilder *builder))block;

// Configure
- (POViewFrameBuilder *)enableAutoCommit;
- (POViewFrameBuilder *)disableAutoCommit;

// Move
- (POViewFrameBuilder *)setX:(CGFloat)x;
- (POViewFrameBuilder *)setY:(CGFloat)y;
- (POViewFrameBuilder *)setOriginWithX:(CGFloat)x y:(CGFloat)y;

- (POViewFrameBuilder *)moveWithOffsetX:(CGFloat)offsetX;
- (POViewFrameBuilder *)moveWithOffsetY:(CGFloat)offsetY;
- (POViewFrameBuilder *)moveWithOffsetX:(CGFloat)offsetX offsetY:(CGFloat)offsetY;

- (POViewFrameBuilder *)centerInSuperview;
- (POViewFrameBuilder *)centerHorizontallyInSuperview;
- (POViewFrameBuilder *)centerVerticallyInSuperview;

- (POViewFrameBuilder *)alignToTopInSuperviewWithInset:(CGFloat)inset;
- (POViewFrameBuilder *)alignToBottomInSuperviewWithInset:(CGFloat)inset;
- (POViewFrameBuilder *)alignLeftInSuperviewWithInset:(CGFloat)inset;
- (POViewFrameBuilder *)alignRightInSuperviewWithInset:(CGFloat)inset;

- (POViewFrameBuilder *)alignToTopInSuperviewWithInsets:(UIEdgeInsets)insets;
- (POViewFrameBuilder *)alignToBottomInSuperviewWithInsets:(UIEdgeInsets)insets;
- (POViewFrameBuilder *)alignLeftInSuperviewWithInsets:(UIEdgeInsets)insets;
- (POViewFrameBuilder *)alignRightInSuperviewWithInsets:(UIEdgeInsets)insets;

- (POViewFrameBuilder *)alignToTopOfView:(UIView *)view offset:(CGFloat)offset;
- (POViewFrameBuilder *)alignToBottomOfView:(UIView *)view offset:(CGFloat)offset;
- (POViewFrameBuilder *)alignLeftOfView:(UIView *)view offset:(CGFloat)offset;
- (POViewFrameBuilder *)alignRightOfView:(UIView *)view offset:(CGFloat)offset;

+ (void)alignViews:(NSArray *)views direction:(POViewFrameBuilderDirection)direction spacing:(CGFloat)spacing;
+ (void)alignViews:(NSArray *)views direction:(POViewFrameBuilderDirection)direction spacingWithBlock:(CGFloat (^)(UIView *firstView, UIView *secondView))block;

+ (void)alignViewsVertically:(NSArray *)views spacing:(CGFloat)spacing;
+ (void)alignViewsVertically:(NSArray *)views spacingWithBlock:(CGFloat (^)(UIView *firstView, UIView *secondView))block;
+ (void)alignViewsHorizontally:(NSArray *)views spacing:(CGFloat)spacing;
+ (void)alignViewsHorizontally:(NSArray *)views spacingWithBlock:(CGFloat (^)(UIView *firstView, UIView *secondView))block;

+ (CGFloat)heightForViewsAlignedVertically:(NSArray *)views spacing:(CGFloat)spacing;
+ (CGFloat)heightForViewsAlignedVertically:(NSArray *)views spacingWithBlock:(CGFloat (^)(UIView *firstView, UIView *secondView))block;

+ (CGFloat)heightForViewsAlignedVertically:(NSArray *)views constrainedToWidth:(CGFloat)constrainedWidth spacing:(CGFloat)spacing;
+ (CGFloat)heightForViewsAlignedVertically:(NSArray *)views constrainedToWidth:(CGFloat)constrainedWidth spacingWithBlock:(CGFloat (^)(UIView *firstView, UIView *secondView))block;

// Resize
- (POViewFrameBuilder *)setWidth:(CGFloat)width;
- (POViewFrameBuilder *)setHeight:(CGFloat)height;
- (POViewFrameBuilder *)setSize:(CGSize)size;
- (POViewFrameBuilder *)setSizeWithWidth:(CGFloat)width height:(CGFloat)height;
- (POViewFrameBuilder *)setSizeToFitWidth;
- (POViewFrameBuilder *)setSizeToFitHeight;
- (POViewFrameBuilder *)setSizeToFit;

+ (void)sizeToFitViews:(NSArray *)views;

@end


@interface UIView (XY_frameBuilder)

- (POViewFrameBuilder *)po_frameBuilder;

@end


@interface UIView (XY_positioning)

@property (nonatomic, assign) CGFloat   x;
@property (nonatomic, assign) CGFloat   y;
@property (nonatomic, assign) CGFloat   width;
@property (nonatomic, assign) CGFloat   height;
@property (nonatomic, assign) CGPoint   origin;
@property (nonatomic, assign) CGSize    size;
@property (nonatomic, assign) CGFloat   bottom;
@property (nonatomic, assign) CGFloat   right;
@property (nonatomic, assign) CGFloat   centerX;
@property (nonatomic, assign) CGFloat   centerY;
@property (nonatomic, weak, readonly) UIView *lastSubviewOnX;
@property (nonatomic, weak, readonly) UIView *lastSubviewOnY;

@end

