//
//  UIHoldButton.m
//  Sleep Diary
//
//  Created by Alexander Ivanov on 16.05.15.
//  Copyright (c) 2015 Alexander Ivanov. All rights reserved.
//

#import "UIHoldButton.h"

@interface UIHoldButton ()
@property (assign, nonatomic) NSDate *touchDown;
@end

@implementation UIHoldButton

- (void)holdUp {
	if (!self.touchDown)
		return;
	
	NSTimeInterval delay = [[NSDate date] timeIntervalSinceDate:self.touchDown];
	if (delay < self.holdUpDelay)
		return;
	
	self.touchDown = Nil;
	
	__weak UIHoldButton *__self = self;
	if (self.holdUpBlock)
		self.holdUpBlock(__self);
}

- (void)sendActionsForControlEvents:(UIControlEvents)controlEvents {
	if (controlEvents & UIControlEventTouchDown) {
		if (self.holdUpDelay > 0.0) {
			self.touchDown = [NSDate date];
			
			[self performSelector:@selector(holdUp) withObject:Nil afterDelay:self.holdUpDelay];
		}
	} else if (controlEvents & UIControlEventTouchUpInside) {
		if (!self.touchDown)
			return;
		
		self.touchDown = Nil;
	}
	
	[super sendActionsForControlEvents:controlEvents];
}

- (void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
	[super sendAction:action to:target forEvent:event];
}

@end
