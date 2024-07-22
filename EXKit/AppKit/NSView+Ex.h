//
//  NSView+Ex.h
//  Guardian
//
//  Created by Alexander Ivanov on 16.07.15.
//  Copyright © 2015 NATEK. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef NS_OPTIONS(NSUInteger, NSDirection) {
	NSDirectionDown = (1 << 0),
	NSDirectionUp = (1 << 1),
	NSDirectionRight = (1 << 2),
	NSDirectionLeft = (1 << 3),
};

@interface NSView (Ex)

- (BOOL)makeFirstResponder;

- (void)setEnabledRecursively:(BOOL)enabled;

- (void)shake:(NSDirection)direction duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay animation:(void (^)(void))animation completion:(void (^)(void))completion;

- (void)rotate:(CGFloat)angle duration:(NSTimeInterval)duration completion:(void(^)(void))completion;

- (void)beginPostingBoundsChangedNotificationsForObserver:(id)observer selector:(SEL)selelctor;
- (void)endPostingBoundsChangedNotificationsForObserver:(id)observer;

@end
