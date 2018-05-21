//
//  NSFormatter+Convenience.m
//  Sleep Diary
//
//  Created by Alexander Ivanov on 16.10.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "NSFormatter+Convenience.h"

@implementation NSDateFormatter (Convenience)

__static(NSDateFormatter *, defaultFormatter, ({
	NSDateFormatter *formatter = [NSDateFormatter new];
	formatter.dateStyle = NSDateFormatterShortStyle;
	formatter.timeStyle = NSDateFormatterMediumStyle;
	formatter;
}))

__static(NSDateFormatter *, RFC3339Formatter, ({
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
	[formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
	[formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	formatter;
}))

__static(NSDateFormatter *, GMTDateFormatter, ({
	NSDateFormatter *formatter = [NSDateFormatter new];
	formatter.dateStyle = NSDateFormatterShortStyle;
	formatter.timeStyle = NSDateFormatterMediumStyle;
	formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
	formatter;
}))

__static(NSDateFormatter *, GMTTimeFormatter, ({
	NSDateFormatter *formatter = [NSDateFormatter new];
	formatter.dateStyle = NSDateFormatterNoStyle;
	formatter.timeStyle = NSDateFormatterMediumStyle;
	formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
	formatter;
}))

- (NSDate *)dateFromValue:(NSString *)string {
	return string ? [self dateFromString:string] : Nil;
}

- (NSString *)stringFromValue:(NSDate *)date {
	return date ? [self stringFromDate:date] : Nil;
}

- (NSString *)weekdaySymbol:(NSUInteger)weekday {
	return idx(self.standaloneWeekdaySymbols, weekday - 1);
}

- (NSString *)monthSymbol:(NSUInteger)month {
	return idx(self.standaloneMonthSymbols, month - 1);
}

- (NSString *)weekdaySymbolForDate:(NSDate *)date {
	return date ? [self weekdaySymbol:[[NSCalendar currentCalendar] component:NSCalendarUnitWeekday fromDate:date]] : Nil;
}

- (NSString *)monthSymbolForDate:(NSDate *)date {
	return date ? [self monthSymbol:[[NSCalendar currentCalendar] component:NSCalendarUnitMonth fromDate:date]] : Nil;
}

@end

@implementation NSDateComponentsFormatter (Convenience)

+ (instancetype)dateComponentsFormatterWithAllowedUnits:(NSCalendarUnit)allowedUnits unitsStyle:(NSDateComponentsFormatterUnitsStyle)unitsStyle {
	NSDateComponentsFormatter *instance = [NSDateComponentsFormatter new];
	instance.allowedUnits = allowedUnits;
	instance.unitsStyle = unitsStyle;
	instance.zeroFormattingBehavior = NSDateComponentsFormatterZeroFormattingBehaviorPad;
	return instance;
}

+ (instancetype)dateComponentsFormatterWithAllowedUnits:(NSCalendarUnit)allowedUnits {
	return [self dateComponentsFormatterWithAllowedUnits:allowedUnits unitsStyle:NSDateComponentsFormatterUnitsStylePositional];
}

__static(NSDateComponentsFormatter *, hhmmFormatter, [self dateComponentsFormatterWithAllowedUnits:NSCalendarUnitHour | NSCalendarUnitMinute])
__static(NSDateComponentsFormatter *, hhmmssFormatter, [self dateComponentsFormatterWithAllowedUnits:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond])
__static(NSDateComponentsFormatter *, mmssFormatter, [self dateComponentsFormatterWithAllowedUnits:NSCalendarUnitMinute | NSCalendarUnitSecond])

__static(NSDateComponentsFormatter *, mmssAbbreviatedFormatter, [NSDateComponentsFormatter dateComponentsFormatterWithAllowedUnits:NSCalendarUnitMinute | NSCalendarUnitSecond unitsStyle:NSDateComponentsFormatterUnitsStyleAbbreviated])
__static(NSDateComponentsFormatter *, mmShortFormatter, [NSDateComponentsFormatter dateComponentsFormatterWithAllowedUnits:NSCalendarUnitMinute unitsStyle:NSDateComponentsFormatterUnitsStyleShort])
__static(NSDateComponentsFormatter *, ssShortFormatter, [NSDateComponentsFormatter dateComponentsFormatterWithAllowedUnits:NSCalendarUnitSecond unitsStyle:NSDateComponentsFormatterUnitsStyleShort])

- (NSString *)stringFromValue:(NSDate *)startDate toValue:(NSDate *)endDate {
	return startDate && endDate ? [self stringFromDate:startDate toDate:endDate] : Nil;
}

@end

@implementation NSDateIntervalFormatter (Convinience)

- (instancetype)initWithDateStyle:(NSDateIntervalFormatterStyle)dateStyle timeStyle:(NSDateIntervalFormatterStyle)timeStyle {
	self = [self init];

	if (self) {
		self.dateStyle = dateStyle;
		self.timeStyle = timeStyle;
	}

	return self;
}

- (NSString *)stringFromTimeInterval:(NSTimeInterval)fromTimeInterval toTimeInterval:(NSTimeInterval)toTimeInterval {
	NSDate *fromDate = [NSDate dateWithTimeIntervalSinceReferenceDate:fromTimeInterval];
	NSDate *toDate = [NSDate dateWithTimeIntervalSinceReferenceDate:toTimeInterval];
	return [self stringFromDate:fromDate toDate:toDate];
}

@end

@implementation NSDate (NSFormatter)

- (NSString *)descriptionForDate:(NSDateFormatterStyle)dateStyle andTime:(NSDateFormatterStyle)timeStyle {
	return [NSDateFormatter localizedStringFromDate:self dateStyle:dateStyle timeStyle:timeStyle];
}

- (NSString *)descriptionForDateAndTime:(NSDateFormatterStyle)dateAndTimeStyle {
	return [NSDateFormatter localizedStringFromDate:self dateStyle:dateAndTimeStyle timeStyle:dateAndTimeStyle];
}

- (NSString *)descriptionForDate:(NSDateFormatterStyle)dateStyle {
	return [NSDateFormatter localizedStringFromDate:self dateStyle:dateStyle timeStyle:NSDateFormatterNoStyle];
}

- (NSString *)descriptionForTime:(NSDateFormatterStyle)timeStyle {
	return [NSDateFormatter localizedStringFromDate:self dateStyle:NSDateFormatterNoStyle timeStyle:timeStyle];
}

- (NSString *)descriptionWithFormat:(NSString *)format calendar:(NSCalendar *)calendar {
	NSDateFormatter *formatter = [NSDateFormatter new];
	if (format)
		formatter.dateFormat = format;
	if (calendar)
		formatter.calendar = calendar;
	return [formatter stringFromDate:self];
}

- (NSString *)weekdayDescription {
	return [self descriptionWithFormat:@"EEEE" calendar:Nil];
}

- (NSString *)timestampDescription {
	return [self descriptionWithFormat:@"yyyy-MM-dd-HH-mm-ss" calendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]];
}

- (NSString *)descriptionFromNow {
	NSCalendarUnit units = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;

	NSDateComponents *components = [[NSCalendar currentCalendar] components:units fromDate:self toDate:[NSDate date] options:0];

	if (components.year > 0)
		return [NSString stringWithFormat:components.year == 1 ? @"A year ago" : @"%ld years ago", components.year];
	else if (components.year < 0)
		return [NSString stringWithFormat:components.year == -1 ? @"In a year" : @"In %ld years", components.year];

	else if (components.month > 0)
		return [NSString stringWithFormat:components.month == 1 ? @"A month ago" : @"%ld months ago", components.month];
	else if (components.month < 0)
		return [NSString stringWithFormat:components.month == -1 ? @"In a month" : @"In %ld months", components.month];

	else if (components.day > 0)
		return [NSString stringWithFormat:components.day == 1 ? @"A day ago" : @"%ld days ago", components.day];
	else if (components.day < 0)
		return [NSString stringWithFormat:components.day == -1 ? @"In a day" : @"In %ld days", components.day];

	else if (components.hour > 0)
		return [NSString stringWithFormat:components.hour == 1 ? @"A hour ago" : @"%ld hours ago", components.hour];
	else if (components.hour < 0)
		return [NSString stringWithFormat:components.hour == -1 ? @"In a hour" : @"In %ld hours", components.hour];

	else if (components.minute > 0)
		return [NSString stringWithFormat:components.minute == 1 ? @"A minute ago" : @"%ld minutes ago", components.minute];
	else if (components.minute < 0)
		return [NSString stringWithFormat:components.minute == -1 ? @"In a minute" : @"In %ld minutes", components.minute];

	return @"Now";

}

@end

@implementation NSDateComponents (NSFormatter)

- (NSString *)description:(NSDateComponentsFormatterUnitsStyle)unitStyle {
	return [NSDateComponentsFormatter localizedStringFromDateComponents:self unitsStyle:unitStyle];
}

@end

@implementation NSNumber (NSNumberFormatter)

- (NSString *)localizedStringWithNumberStyle:(NSNumberFormatterStyle)style {
	return [NSNumberFormatter localizedStringFromNumber:self numberStyle:style];
}

@end
