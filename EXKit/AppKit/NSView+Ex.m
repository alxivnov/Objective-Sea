//
//  NSView+Ex.m
//  Guardian
//
//  Created by Alexander Ivanov on 16.07.15.
//  Copyright © 2015 NATEK. All rights reserved.
//

#import "AppKitEx.h"
#import "NSView+Ex.h"

#import "CoreGraphics+Convenience.h"

@import QuartzCore;

@implementation NSView (Ex)

- (BOOL)makeFirstResponder {
	return [self.window makeFirstResponder:self];
}

- (void)setEnabledRecursively:(BOOL)enabled {
	if ([self isKindOfClass:[NSControl class]])
		((NSControl *)self).enabled = enabled;
	else
		for (NSView *subview in self.subviews)
			[subview setEnabledRecursively:enabled];
}

+ (CGPoint)offset:(CGFloat)offset withDirection:(NSDirection)direction {
	return CGPointMake(direction == NSDirectionLeft ? -offset : direction == NSDirectionRight ? offset : 0.0, direction == NSDirectionUp ? offset : direction == NSDirectionDown ? -offset : 0.0);
}

- (void)setOffsetWithX:(CGFloat)x andY:(CGFloat)y {
	[self setFrameOrigin:CGPointMake(self.frame.origin.x + x, self.frame.origin.y + y)];
}

- (void)setOffset:(CGPoint)offset {
	[self setOffsetWithX:offset.x andY:offset.y];
}

- (void)shake:(NSDirection)direction duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay animation:(void (^)(void))animation completion:(void (^)(void))completion {
	if (self.hidden)
		return;
	
	CGSize size = self.frame.size;
	CGFloat m = size.height < 512 && size.width < 512 ? 1.0 : size.height < 1024 && size.width < 1024 ? 2.0 : 3.0;
	
	duration = duration / 5;
	[NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
		[context setDuration:duration];
		
		self.animator.frame = CGRectOffsetX(self.animator.frame, 30.0 * m);
	} completionHandler:^{
		[NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
			[context setDuration:duration];
			
			self.animator.frame = CGRectOffsetX(self.animator.frame, -51.0 * m);
		} completionHandler:^{
			[NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
				[context setDuration:duration];
				
				self.animator.frame = CGRectOffsetX(self.animator.frame, 39.0 * m);
				
				if (animation)
					animation();
			} completionHandler:^{
				[NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
					[context setDuration:duration];
					
					self.animator.frame = CGRectOffsetX(self.animator.frame, -24.0 * m);
				} completionHandler:^{
					[NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
						[context setDuration:duration];
						
						self.animator.frame = CGRectOffsetX(self.animator.frame, 6.0 * m);
					} completionHandler:^{
						if (completion)
							completion();
					}];
				}];
			}];
		}];
	}];
}

- (void)rotate:(CGFloat)angle duration:(NSTimeInterval)duration completion:(void(^)(void))completion {
//	BOOL wantsLayer = self.wantsLayer;
//	if (!wantsLayer)
//		self.wantsLayer = YES;
	
	CGPoint center = CGRectCenter(self.frame);
	
	[NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
		context.duration = duration;
		
		self.animator.frameRotation = angle;
		self.layer.position = center;
		self.layer.anchorPoint = CGPointMake(0.5, 0.5);
	} completionHandler:^{
		if (completion)
			completion();
		
//		if (!wantsLayer)
//			self.wantsLayer = NO;
	}];
}

- (void)beginPostingBoundsChangedNotificationsForObserver:(id)observer selector:(SEL)selector {
	if (observer && selector)
		[[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:NSViewBoundsDidChangeNotification object:self];
	
	self.postsBoundsChangedNotifications = YES;
}

- (void)endPostingBoundsChangedNotificationsForObserver:(id)observer {
	self.postsBoundsChangedNotifications = NO;

	if (observer)
		[[NSNotificationCenter defaultCenter] removeObserver:observer name:NSViewBoundsDidChangeNotification object:self];
}

@end
