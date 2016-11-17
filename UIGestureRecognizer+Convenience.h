//
//  UIGestureRecognizer+Convenience.h
//  Sleep Diary
//
//  Created by Alexander Ivanov on 17.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIGestureRecognizer (Convenience)

- (void)cancel;

@end

@interface UIPinchGestureRecognizer (Convenience)

- (BOOL)pinchIn;
- (BOOL)pinchOut;

@end

@interface UIView (UIGestureRecognizer)

- (IBAction)longPress:(UILongPressGestureRecognizer *)sender;	// abstract
- (IBAction)pan:(UIPanGestureRecognizer *)sender;				// abstract
- (IBAction)pinch:(UIPinchGestureRecognizer *)sender;			// abstract
- (IBAction)tap:(UITapGestureRecognizer *)sender;				// abstract

- (UILongPressGestureRecognizer *)addLongPressWithTarget:(id)target action:(SEL)action;
- (UILongPressGestureRecognizer *)addLongPressWithTarget:(id)target;
- (UILongPressGestureRecognizer *)addLongPress;

- (UIPanGestureRecognizer *)addPanWithTarget:(id)target action:(SEL)action;
- (UIPanGestureRecognizer *)addPanWithTarget:(id)target;
- (UIPanGestureRecognizer *)addPan;

- (UIPinchGestureRecognizer *)addPinchWithTarget:(id)target action:(SEL)action;
- (UIPinchGestureRecognizer *)addPinchWithTarget:(id)target;
- (UIPinchGestureRecognizer *)addPinch;

- (UITapGestureRecognizer *)addTapWithTarget:(id)target action:(SEL)action;
- (UITapGestureRecognizer *)addTapWithTarget:(id)target;
- (UITapGestureRecognizer *)addTap;

@end
