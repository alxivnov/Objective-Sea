//
//  UIView+Convenience.h
//  Ringtonic
//
//  Created by Alexander Ivanov on 14.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIStepperWidth 94.0
#define UIStepperHeight 29.0
#define UISwitchWidth 51.0
#define UISwitchHeight 31.0

//#import "CoreGraphics+Convenience.h"
#import "UIImage+Convenience.h"

#define ANIMATION_DURATION 0.6
#define ANIMATION_VELOCITY 0.0
#define ANIMATION_DAMPING 1.0
#define ANIMATION_OPTIONS UIViewAnimationOptionCurveEaseInOut

#define UISubviewKindOfClass(cls) ^BOOL(UIView *__subview) { return [__subview isKindOfClass:[cls class]]; }
#define UISubviewMemberOfClass(cls) ^BOOL(UIView *__subview) { return [__subview isMemberOfClass:[cls class]]; }

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

#define UIDirectionInvert(direction) (direction == UIDirectionDown ? UIDirectionUp : direction == UIDirectionUp ? UIDirectionDown : direction == UIDirectionLeft ? UIDirectionRight : UIDirectionLeft)
#define UIPositionInvert(position) (position == UIPositionBottom ? UIPositionTop : position == UIPositionTop ? UIPositionBottom : position == UIPositionLeft ? UIPositionRight : UIPositionLeft)

#define UIPositionHorizontal(a) (a & (UIPositionLeft | UIPositionRight))
#define UIPositionVertical(a) (a & (UIPositionBottom | UIPositionTop))

#define UIViewIsKindOfClass(cls) ^BOOL(UIView *view) { return [view isKindOfClass:[cls class]]; }

@interface UIView (Convenience)

- (void)hideSubviews;
- (void)showSubviews;

- (__kindof UIView *)rootview;

- (__kindof UIView *)superview:(BOOL (^)(UIView *superview))block;
- (__kindof UIView *)subview:(BOOL (^)(UIView *subview))block;

- (UIColor *)rootBackgroundColor;

- (BOOL)centerSubview:(UIView *)subview;
- (BOOL)centerInSuperview:(UIView *)superview;
- (BOOL)centerInSuperview;

- (void)bringToFront;

- (void)dock:(UIPosition)position inside:(BOOL)inside margin:(CGFloat)margin view:(UIView *)view;
- (void)dock:(UIPosition)position inside:(BOOL)inside margin:(CGFloat)margin;
- (void)dock:(UIPosition)position inside:(BOOL)inside;
- (void)dock:(UIPosition)position;

- (UIImage *)snapshotImageAfterScreenUpdates:(BOOL)afterUpdates;
- (UIImage *)snapshotImage;
- (UIView *)snapshotView;

- (UIViewController *)embedInViewController;

- (void)setHidden:(BOOL)hidden duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion;
- (void)setHidden:(BOOL)hidden duration:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion;

- (void)shake:(UIDirection)direction duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion;
- (void)shake:(UIDirection)direction duration:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion;

- (void)burst:(CGFloat)scale duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion;
- (void)burst:(CGFloat)scale duration:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion;

- (void)blink:(UIColor *)color duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion;
- (void)blink:(UIColor *)color duration:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion;

- (void)animate:(CGAffineTransform)transform duration:(NSTimeInterval)duration damping:(CGFloat)damping velocity:(CGFloat)velocity options:(UIViewAnimationOptions)options completion:(void (^)(BOOL finished))completion;
- (void)animate:(CGAffineTransform)transform duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options completion:(void (^)(BOOL finished))completion;

@property (assign, nonatomic, readonly) BOOL iPad;
@property (assign, nonatomic, readonly) BOOL iPhone;

@end
