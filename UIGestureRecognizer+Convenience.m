//
//  UIGestureRecognizer+Convenience.m
//  Sleep Diary
//
//  Created by Alexander Ivanov on 17.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "UIGestureRecognizer+Convenience.h"

@implementation UIGestureRecognizer (Convenience)

- (void)cancel {
	self.enabled = NO;
	self.enabled = YES;
}

@end

@implementation UIPinchGestureRecognizer (Convenience)

- (BOOL)pinchIn {
	return self.scale < 1.0;
}

- (BOOL)pinchOut {
	return self.scale > 1.0;
}

@end

@implementation UIView (UIGestureRecognizer)

- (IBAction)longPress:(UILongPressGestureRecognizer *)sender {
	// abstract
}

- (IBAction)pan:(UIPanGestureRecognizer *)sender {
	// abstract
}

- (IBAction)pinch:(UIPinchGestureRecognizer *)sender {
	// abstract
}

- (IBAction)tap:(UITapGestureRecognizer *)sender {
	// abstract
}

- (UIGestureRecognizer *)addGestureRecognizer:(Class)class target:(id)target action:(SEL)action {
	UIGestureRecognizer *gestureRecognizer = [[class alloc] initWithTarget:target action:action];

	[self addGestureRecognizer:gestureRecognizer];

	return gestureRecognizer;
}

- (UILongPressGestureRecognizer *)addLongPressWithTarget:(id)target action:(SEL)action {
	return (UILongPressGestureRecognizer *)[self addGestureRecognizer:[UILongPressGestureRecognizer class] target:target action:[target respondsToSelector:action] ? action : Nil];
}

- (UILongPressGestureRecognizer *)addLongPressWithTarget:(id)target {
	return [self addLongPressWithTarget:target action:target ? @selector(longPress:) : Nil];
}

- (UILongPressGestureRecognizer *)addLongPress {
	return [self addLongPressWithTarget:self action:@selector(longPress:)];
}

- (UIPanGestureRecognizer *)addPanWithTarget:(id)target action:(SEL)action {
	return (UIPanGestureRecognizer *)[self addGestureRecognizer:[UIPanGestureRecognizer class] target:target action:[target respondsToSelector:action] ? action : Nil];
}

- (UIPanGestureRecognizer *)addPanWithTarget:(id)target {
	return [self addPanWithTarget:target action:target ? @selector(pan:) : Nil];
}

- (UIPanGestureRecognizer *)addPan {
	return [self addPanWithTarget:self action:@selector(pan:)];
}

- (UIPinchGestureRecognizer *)addPinchWithTarget:(id)target action:(SEL)action {
	return (UIPinchGestureRecognizer *)[self addGestureRecognizer:[UIPinchGestureRecognizer class] target:target action:[target respondsToSelector:action] ? action : Nil];
}

- (UIPinchGestureRecognizer *)addPinchWithTarget:(id)target {
	return [self addPinchWithTarget:target action:target ? @selector(pinch:) : Nil];
}

- (UIPinchGestureRecognizer *)addPinch {
	return [self addPinchWithTarget:self action:@selector(pinch:)];
}

- (UITapGestureRecognizer *)addTapWithTarget:(id)target action:(SEL)action {
	return (UITapGestureRecognizer *)[self addGestureRecognizer:[UITapGestureRecognizer class] target:target action:[target respondsToSelector:action] ? action : Nil];
}

- (UITapGestureRecognizer *)addTapWithTarget:(id)target {
	return [self addTapWithTarget:target action:target ? @selector(tap:) : Nil];
}

- (UITapGestureRecognizer *)addTap {
	return [self addTapWithTarget:self action:@selector(tap:)];
}

@end
