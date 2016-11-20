//
//  NSTimer+Convenience.m
//  Ringtonic
//
//  Created by Alexander Ivanov on 19.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "NSTimer+Convenience.h"

@implementation NSSelectorTimer

- (void)setEnabled:(BOOL)enabled {
	if (_enabled == enabled)
		return;

	_enabled = enabled;

	[self fire:Nil];
}

- (void)fire {
	if (self.block)
		self.block();
}

- (void)fire:(NSObject *)object {
	if (!self.enabled)
		return;

	[self fire];

	[self performSelector:@selector(fire:) withObject:object afterDelay:self.interval];
}

+ (instancetype)create:(void (^)(void))block interval:(NSTimeInterval)interval {
	NSSelectorTimer *instance = [self new];
	instance.block = block;
	instance.interval = interval;
	return instance;
}

@end

@interface NSTimerBlock ()
@property (copy, nonatomic) BOOL (^block)(id userInfo);
@end

@implementation NSTimerBlock

- (instancetype)initWithBlock:(BOOL(^)(id userInfo))block {
	self = [super init];

	if (self)
		self.block = block;

	return self;
}

- (void)timerFireMethod:(NSTimer *)timer {
	if (self.block)
		if (self.block(timer.userInfo))
			[timer invalidate];
}

- (NSTimer *)timerWithTimeInterval:(NSTimeInterval)ti userInfo:(id)userInfo repeats:(BOOL)yesOrNo {
	__block NSTimer *timer = Nil;
	if (self.block)
		timer = [NSTimer timerWithTimeInterval:ti target:self selector:@selector(timerFireMethod:) userInfo:userInfo repeats:yesOrNo];
	return timer;
}

- (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti userInfo:(id)userInfo repeats:(BOOL)yesOrNo {
	__block NSTimer *timer = Nil;
	if (self.block)
		timer = [NSTimer scheduledTimerWithTimeInterval:ti target:self selector:@selector(timerFireMethod:) userInfo:userInfo repeats:yesOrNo];
	return timer;
}

@end
