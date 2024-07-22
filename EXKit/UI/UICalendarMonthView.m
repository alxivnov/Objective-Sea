//
//  UICalendarMonthView.m
//  Air Tasks
//
//  Created by Alexander Ivanov on 23.11.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "UICalendarMonthView.h"

@implementation UICalendarMonthView

+ (NSArray *)createDays {
	NSMutableArray *days = [NSMutableArray arrayWithCapacity:31];
	
	for (NSUInteger index = 0; index < 31; index++)
		[days addObject:@(index + 1)];
	
	return days;
}

@end
