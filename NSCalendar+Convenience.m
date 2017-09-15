//
//  NSCalendar+Convenience.m
//  Ringtonic
//
//  Created by Alexander Ivanov on 15.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "NSCalendar+Convenience.h"

@implementation NSDate (Convenience)

- (BOOL)isGreaterThan:(NSDate *)date {
	return date ? [self compare:date] == NSOrderedDescending : YES;
}

- (BOOL)isLessThan:(NSDate *)date {
	return date ? [self compare:date] == NSOrderedAscending : NO;
}

- (BOOL)isGreaterThanOrEqual:(NSDate *)date {
	return ![self isLessThan:date];
}

- (BOOL)isLessThanOrEqual:(NSDate *)date {
	return ![self isGreaterThan:date];
}

- (BOOL)isPast {
	return [self isLessThan:[NSDate date]];
}

- (BOOL)isFuture {
	return [self isGreaterThan:[NSDate date]];
}

- (BOOL)isYesterday {
	return [[NSCalendar currentCalendar] isDateInYesterday:self];
}

- (BOOL)isToday {
	return [[NSCalendar currentCalendar] isDateInToday:self];
}

- (BOOL)isTomorrow {
	return [[NSCalendar currentCalendar] isDateInTomorrow:self];
}

- (NSUInteger)weekday {
	return [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:self].weekday - 1;
}

- (NSInteger)daysToNow {
	return [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:self toDate:[NSDate date] options:0].day;
}

- (NSInteger)secondsFromGMT {
	return [[NSCalendar currentCalendar].timeZone secondsFromGMTForDate:self];
}

- (NSInteger)componentValue:(NSCalendarUnit)unit {
	return [[NSCalendar currentCalendar] component:unit fromDate:self];
}

- (NSDate *)addValue:(NSInteger)value forComponent:(NSCalendarUnit)unit {
	NSDateComponents *components = [[NSDateComponents alloc] init];
	[components setValue:value forComponent:unit];
	return [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)component:(NSCalendarUnit)unit {
	NSDate *tempDate;
	NSTimeInterval tempTime;

	if ([[NSCalendar currentCalendar] rangeOfUnit:unit startDate:&tempDate interval:&tempTime forDate:self])
		return tempDate;
	else
		return Nil;
}

- (NSDate *)dateComponent {
	return [self component:NSCalendarUnitDay];
}

- (NSTimeInterval)timeComponent {
	NSCalendar *calendar = [NSCalendar currentCalendar];

	NSDate *tempDate;
	NSTimeInterval tempTime;

	if ([calendar rangeOfUnit:NSCalendarUnitDay startDate:&tempDate interval:&tempTime forDate:self])
		return [self timeIntervalSinceDate:tempDate];
	else
		return 0;
}

- (NSDate *)nextWeekday:(NSInteger)weekday withTime:(NSTimeInterval)time skipToday:(BOOL)skipToday {
	NSInteger days = weekday - [self weekday];
	if (days < 0)
		days += 7;

	NSDate *date = [[self dateComponent] addValue:days forComponent:NSCalendarUnitDay];
	if (time > 0)
		date = [date dateByAddingTimeInterval:time];
	if (days == 0 && (skipToday ? [date isLessThan:self] : [date isLessThanOrEqual:self]))
		date = [date addValue:1 forComponent:NSCalendarUnitWeekOfYear];

	return date;
}

- (NSDate *)nextWeekday:(NSInteger)weekday withTime:(NSTimeInterval)time {
	return [self nextWeekday:weekday withTime:time skipToday:NO];
}

- (NSDate *)nextDay:(NSInteger)day withTime:(NSTimeInterval)time skipToday:(BOOL)skipToday {
	//	day++;

	NSCalendar *calendar = [NSCalendar currentCalendar];

	NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self];
	components.day = MIN(day, [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self].length);

	NSDate *date = [calendar dateFromComponents:components];
	if (time > 0)
		date = [date dateByAddingTimeInterval:time];
	if (skipToday ? [date isLessThan:self] : [date isLessThanOrEqual:self])
		date = [[date addValue:1 forComponent:NSCalendarUnitMonth] nextDay:day withTime:time skipToday:YES];

	return date;
}

- (NSDate *)nextDay:(NSInteger)day withTime:(NSTimeInterval)time {
	return [self nextDay:day withTime:time skipToday:NO];
}

+ (NSUInteger)firstWeekday {
	return [NSCalendar currentCalendar].firstWeekday - 1;
}

+ (NSDate *)yesterday {
	return [[[NSDate date] dateComponent] addValue:-1 forComponent:NSCalendarUnitDay];
}

+ (NSDate *)today {
	return [[NSDate date] dateComponent];
}

+ (NSDate *)tomorrow {
	return [[[NSDate date] dateComponent] addValue:1 forComponent:NSCalendarUnitDay];
}

@end

@implementation NSDateComponents (Convenience)

+ (NSCalendarUnit)mostSignificantComponent:(NSTimeInterval)ti {
	NSTimeInterval interval = fabs(ti);

	if (interval >= TIME_YEAR)
		return NSCalendarUnitYear;
	if (interval >= TIME_MONTH)
		return NSCalendarUnitMonth;
	if (interval >= TIME_WEEK)
		return NSCalendarUnitWeekOfMonth;
	if (interval >= TIME_DAY)
		return NSCalendarUnitDay;
	if (interval >= TIME_HOUR)
		return NSCalendarUnitHour;
	if (interval >= TIME_MINUTE)
		return NSCalendarUnitMinute;

	return NSCalendarUnitSecond;
}

+ (instancetype)dateComponentsWithValue:(NSInteger)value forComponent:(NSCalendarUnit)unit {
	NSDateComponents *dateComponents = [NSDateComponents new];
	[dateComponents setValue:value forComponent:unit];
	return dateComponents;
}

+ (instancetype)dateComponentsWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
	NSDateComponents *dateComponents = [NSDateComponents new];
	dateComponents.calendar = [NSCalendar currentCalendar];
	dateComponents.year = year;
	dateComponents.month = month;
	dateComponents.day = day;
	return dateComponents;
}

- (NSTimeInterval)secondsFromDate:(NSDate *)date {
	if (!date)
		date = [NSDate date];

	return [[[NSCalendar currentCalendar] dateByAddingComponents:self toDate:date options:0] timeIntervalSinceDate:date];
}

- (NSTimeInterval)secondsToDate:(NSDate *)date {
	if (!date)
		date = [NSDate date];

	return [date timeIntervalSinceDate:[[NSCalendar currentCalendar] dateByAddingComponents:self toDate:date options:NSCalendarSearchBackwards]];
}

@end
