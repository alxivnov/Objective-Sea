//
//  WeekView.m
//  CollectionView
//
//  Created by Alexander Ivanov on 20.11.14.
//  Copyright (c) 2014 Alexander Ivanov. All rights reserved.
//

#import "UICalendarWeekView.h"

@implementation UICalendarWeekView

+ (NSArray *)createDays {
	return [NSCalendar currentCalendar].shortWeekdaySymbols;
}

+ (NSUInteger)firstDay {
	return [[NSCalendar currentCalendar] firstWeekday] - 1;
}

@end
