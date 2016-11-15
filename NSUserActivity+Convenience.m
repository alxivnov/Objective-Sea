//
//  NSUserActivity+Convenience.m
//  Ringtonic
//
//  Created by Alexander Ivanov on 15.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "NSUserActivity+Convenience.h"

@implementation NSUserActivity (Convenience)

- (NSUserActivityEligibility)eligibility {
	NSUserActivityEligibility eligibility = 0;
	if (self.isEligibleForHandoff)
		eligibility |= NSUserActivityEligibleForHandoff;
	if (self.isEligibleForPublicIndexing)
		eligibility |= NSUserActivityEligibleForPublicIndexing;
	if (self.isEligibleForSearch)
		eligibility |= NSUserActivityEligibleForSearch;
	return eligibility;
}

- (void)setEligibility:(NSUserActivityEligibility)eligibility {
	self.eligibleForHandoff = eligibility & NSUserActivityEligibleForHandoff;
	self.eligibleForPublicIndexing = eligibility & NSUserActivityEligibleForPublicIndexing;
	self.eligibleForSearch = eligibility & NSUserActivityEligibleForSearch;
}

- (NSArray<NSString *> *)allKeywords {
	return self.keywords.allObjects;
}

- (void)setAllKeywords:(NSArray<NSString *> *)allKeywords {
	self.keywords = allKeywords ? [NSSet setWithArray:allKeywords] : Nil;
}

#if TARGET_OS_IPHONE
- (void)setContentDescription:(NSString *)contentDescription {
	if (!self.contentAttributeSet)
		self.contentAttributeSet = [CSSearchableItemAttributeSet new];

	self.contentAttributeSet.contentDescription = contentDescription;
}

- (void)setThumbnailData:(NSData *)thumbnailData {
	if (!self.contentAttributeSet)
		self.contentAttributeSet = [CSSearchableItemAttributeSet new];

	self.contentAttributeSet.thumbnailData = thumbnailData;
}

- (void)setThumbnailURL:(NSURL *)thumbnailURL {
	if (!self.contentAttributeSet)
		self.contentAttributeSet = [CSSearchableItemAttributeSet new];

	self.contentAttributeSet.thumbnailURL = thumbnailURL;
}
#endif

- (void)becomeCurrent:(BOOL)retain {
	if (retain)
		[[NSUserActivityQueue instance] queue:self];
	else
		[self becomeCurrent];
}

@end

@interface NSUserActivityQueue()
@property (strong, readonly, nonatomic) NSMutableArray<NSUserActivity *> *activities;
@end

@implementation NSUserActivityQueue

@synthesize activities = _activities;

- (NSMutableArray<NSUserActivity *> *)activities {
	if (!_activities)
		_activities = [NSMutableArray new];

	return _activities;
}

- (void)enumerate:(NSNumber *)remove {
	NSUInteger count = 0;

	@synchronized([self class]) {
		if (remove.boolValue)
			[self.activities removeObjectAtIndex:0];

		[self.activities.firstObject becomeCurrent];

		count = self.activities.count;
	}

	if (count)
		[self performSelector:@selector(enumerate:) withObject:@YES afterDelay:1.5];
}

- (void)queue:(NSUserActivity *)activity {
	NSUInteger count = 0;

	@synchronized([self class]) {
		count = self.activities.count;

		[self.activities addObject:activity];
	}

	if (!count)
		[self enumerate:@NO];
}

static id _instance;

+ (instancetype)instance {
	@synchronized(self) {
		if (!_instance)
			_instance = [self new];
	}

	return _instance;
}

@end
