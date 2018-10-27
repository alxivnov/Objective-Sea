//
//  WatchKit+Convenience.m
//  Sleep Diary
//
//  Created by Alexander Ivanov on 14.10.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "WatchKit+Convenience.h"

@implementation WKInterfaceTable (Convenience)

- (void)setRows:(NSDictionary<NSString *, NSNumber *> *)dictionary {
	NSMutableArray *array = [NSMutableArray array];

	for (NSString *key in dictionary) {
		NSUInteger count = dictionary[key].integerValue;

		for (NSUInteger index = 0; index < count; index++)
			[array addObject:key];
	}

	[self setRowTypes:array];
}

@end

@implementation WKInterfaceTimer (Convenience)

- (void)setInterval:(NSTimeInterval)interval {
	NSDate *date = [[NSDate date] dateByAddingTimeInterval:0.0 - interval];

	[self setDate:date];
}

@end

@implementation WKPickerItem (Convenience)

- (instancetype)initWithTitle:(NSString *)title caption:(NSString *)caption accessoryImage:(WKImage *)accessoryImage contentImage:(WKImage *)contentImage {
	self = [self init];

	if (self) {
		self.title = title;
		self.caption = caption;
		self.accessoryImage = accessoryImage;
		self.contentImage = contentImage;
	}

	return self;
}

@end

@implementation WKInterfacePicker (Convenience)

- (void)setItemsWithTitles:(NSArray<NSString *> *)titles {
	NSMutableArray<WKPickerItem *> *items = [NSMutableArray arrayWithCapacity:titles.count];
	for (NSString *title in titles)
		[items addObject:[[WKPickerItem alloc] initWithTitle:title caption:Nil accessoryImage:Nil contentImage:Nil]];

	[self setItems:items];
}

@end

@implementation WKExtension (Convenience)

- (void)scheduleBackgroundRefreshWithPreferredDate:(NSDate *)preferredFireDate userInfo:(id<NSSecureCoding,NSObject>)userInfo {
	if (preferredFireDate)
		[self scheduleBackgroundRefreshWithPreferredDate:preferredFireDate userInfo:userInfo scheduledCompletion:^(NSError *error) {
			[error log:@"scheduleBackgroundRefreshWithPreferredDate:"];
		}];
}

- (void)scheduleBackgroundRefreshWithPreferredDate:(NSDate *)preferredFireDate {
	if (preferredFireDate)
		[self scheduleBackgroundRefreshWithPreferredDate:preferredFireDate userInfo:Nil scheduledCompletion:^(NSError *error) {
			[error log:@"scheduleBackgroundRefreshWithPreferredDate:"];
		}];
}

- (void)scheduleSnapshotRefreshWithPreferredDate:(NSDate *)preferredFireDate userInfo:(id<NSSecureCoding,NSObject>)userInfo {
	if (preferredFireDate)
		[self scheduleSnapshotRefreshWithPreferredDate:preferredFireDate userInfo:userInfo scheduledCompletion:^(NSError *error) {
			[error log:@"scheduleBackgroundRefreshWithPreferredDate:"];
		}];
}

- (void)scheduleSnapshotRefreshWithPreferredDate:(NSDate *)preferredFireDate {
	if (preferredFireDate)
		[self scheduleSnapshotRefreshWithPreferredDate:preferredFireDate userInfo:Nil scheduledCompletion:^(NSError *error) {
			[error log:@"scheduleBackgroundRefreshWithPreferredDate:"];
		}];
}

- (void)scheduleBackgroundRefreshWithTimeIntervalSinceNow:(NSTimeInterval)secs userInfo:(id<NSSecureCoding,NSObject>)userInfo {
	[self scheduleBackgroundRefreshWithPreferredDate:[NSDate dateWithTimeIntervalSinceNow:secs] userInfo:userInfo];
}

- (void)scheduleBackgroundRefreshWithTimeIntervalSinceNow:(NSTimeInterval)secs {
	[self scheduleBackgroundRefreshWithPreferredDate:[NSDate dateWithTimeIntervalSinceNow:secs] userInfo:Nil];
}

- (void)scheduleSnapshotRefreshWithTimeIntervalSinceNow:(NSTimeInterval)secs userInfo:(id<NSSecureCoding,NSObject>)userInfo {
	[self scheduleSnapshotRefreshWithPreferredDate:[NSDate dateWithTimeIntervalSinceNow:secs] userInfo:userInfo];
}

- (void)scheduleSnapshotRefreshWithTimeIntervalSinceNow:(NSTimeInterval)secs {
	[self scheduleSnapshotRefreshWithPreferredDate:[NSDate dateWithTimeIntervalSinceNow:secs] userInfo:Nil];
}

@end
