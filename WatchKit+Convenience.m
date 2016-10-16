//
//  WatchKit+Convenience.m
//  Sleep Diary
//
//  Created by Alexander Ivanov on 14.10.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "WatchKit+Convenience.h"

@implementation WKInterfaceTable (Convenience)

- (void)setRows:(NSDictionary *)dictionary {
	NSMutableArray *array = [NSMutableArray array];

	for (NSString *key in dictionary) {
		NSUInteger count = [dictionary[key] unsignedIntegerValue];

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
