//
//  Dispatch+Convenience.m
//  Sleep Diary
//
//  Created by Alexander Ivanov on 16.10.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "Dispatch+Convenience.h"

@implementation GCD {
	dispatch_semaphore_t _sema;
}

- (instancetype)initWithCount:(NSInteger)count {
	self  = [self init];

	if (self)
		_sema = dispatch_semaphore_create(count);

	return self;
}
/*
- (void)dealloc {
	dispatch_release(_sema);
}
*/
- (BOOL)signal {
	return dispatch_semaphore_signal(_sema) == 0;
}

- (BOOL)wait:(NSTimeInterval)time {
	return time < 0.0 ? NO : dispatch_semaphore_wait(_sema, time > 0.0 ? dispatch_time(DISPATCH_TIME_NOW, time * NSEC_PER_SEC) : DISPATCH_TIME_FOREVER) == 0;
}

- (BOOL)wait {
	return [self wait:0.0];
}

+ (instancetype)new {
	return [[self alloc] initWithCount:0];
}

+ (void)sync:(void (^)(GCD *))sync wait:(NSTimeInterval)time {
	if (!sync)
		return;

	GCD *sema = time < 0.0 ? Nil : [GCD new];

	sync(sema);

	[sema wait:time];
}

+ (void)sync:(void (^)(GCD *))sync {
	[self sync:sync wait:0.0];
}



+ (void)queue:(dispatch_queue_t)queue after:(NSTimeInterval)after block:(void (^)())block {
	if (queue) {
		if (after > 0.0)
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(after * NSEC_PER_SEC)), queue, block);
		else
			dispatch_async(queue, block);
	} else {
		if (after > 0.0)
			[NSThread sleepForTimeInterval:after];

		block();
	}
}

+ (void)global:(void (^)())block {
	[self queue:GCD_GLOBAL after:0.0 block:block];
}

+ (void)main:(void (^)())block {
	[self queue:GCD_MAIN after:0.0 block:block];
}

+ (void)once:(void (^)())block {
	static dispatch_once_t predicate;

	dispatch_once(&predicate, block);
}

@end
