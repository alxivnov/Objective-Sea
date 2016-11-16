//
//  UIView+Convenience.h
//  Ringtonic
//
//  Created by Alexander Ivanov on 14.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ANIMATION_DURATION 0.6
#define ANIMATION_VELOCITY 0.0
#define ANIMATION_DAMPING 1.0
#define ANIMATION_OPTIONS UIViewAnimationOptionCurveEaseInOut

@interface UIView (Convenience)

- (void)hideSubviews;
- (void)showSubviews;

- (__kindof UIView *)root;

- (__kindof UIView *)subview:(BOOL (^)(UIView *subview))block;
- (__kindof UIView *)subviewKindOfClass:(Class)aClass;
- (__kindof UIView *)subviewMemberOfClass:(Class)aClass;

- (UIViewController *)embedInViewController;

- (UIColor *)calculatedBackgroundColor;

@end

#define UIPositionHorizontal(a) (a & (UIPositionLeft | UIPositionRight))
#define UIPositionVertical(a) (a & (UIPositionBottom | UIPositionTop))

typedef NS_OPTIONS(NSUInteger, UIDirection) {
	UIDirectionDown = (1 << 0),
	UIDirectionUp = (1 << 1),
	UIDirectionRight = (1 << 2),
	UIDirectionLeft = (1 << 3),
};

typedef NS_OPTIONS(NSUInteger, UIPosition) {
	UIPositionTop = (1 << 0),
	UIPositionBottom = (1 << 1),
	UIPositionLeft = (1 << 2),
	UIPositionRight = (1 << 3),
};

@interface UIView (Position)

+ (UIPosition)invertPosition:(UIPosition)position;

- (void)setOriginWithX:(CGFloat)x andY:(CGFloat)y;
- (void)setOffsetWithX:(CGFloat)x andY:(CGFloat)y;
- (void)setOrigin:(CGPoint)origin;
- (void)setOffset:(CGPoint)offset;

- (void)setOriginX:(CGFloat)x;
- (void)setOriginY:(CGFloat)y;

- (void)setSizeWithWidth:(CGFloat)width andHeight:(CGFloat)height;
- (void)setSize:(CGSize)size;
- (void)setWidth:(CGFloat)width;
- (void)setHeight:(CGFloat)height;

- (CGRect)centerRectWithWidth:(CGFloat)width andHeight:(CGFloat)height;
- (CGRect)centerRectWithSize:(CGSize)size;

- (void)setCenterX:(CGFloat)x;
- (void)setCenterY:(CGFloat)y;
- (void)offsetByX:(CGFloat)x;
- (void)offsetByY:(CGFloat)y;

- (CGPoint)boundsCenter;

- (BOOL)centerSubview:(UIView *)subview;
- (BOOL)centerInSuperview:(UIView *)superview;
- (BOOL)centerInSuperview;

- (void)dock:(UIPosition)position inside:(BOOL)inside margin:(CGFloat)margin view:(UIView *)view;
- (void)dock:(UIPosition)position inside:(BOOL)inside margin:(CGFloat)margin;
- (void)dock:(UIPosition)position inside:(BOOL)inside;
- (void)dock:(UIPosition)position;

- (void)bringToFront;

@end
