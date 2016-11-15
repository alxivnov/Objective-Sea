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

@interface UIView (Hierarchy)

- (void)hideSubviews;
- (void)showSubviews;

- (__kindof UIView *)root;

- (__kindof UIView *)subview:(BOOL (^)(UIView *subview))block;
- (__kindof UIView *)subviewKindOfClass:(Class)aClass;
- (__kindof UIView *)subviewMemberOfClass:(Class)aClass;

- (UIViewController *)embedInViewController;

- (UIColor *)calculatedBackgroundColor;

@end
