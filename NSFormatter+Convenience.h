//
//  NSFormatter+Convenience.h
//  Sleep Diary
//
//  Created by Alexander Ivanov on 16.10.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSObject+Convenience.h"

@interface NSDateFormatter (Convenience)

+ (NSDateFormatter *)defaultFormatter;
+ (NSDateFormatter *)RFC3339Formatter;
+ (NSDateFormatter *)sqlFormatter;
+ (NSDateFormatter *)GMTDateFormatter;
+ (NSDateFormatter *)GMTTimeFormatter;

- (NSDate *)dateFromValue:(NSString *)string;
- (NSString *)stringFromValue:(NSDate *)date;

- (NSString *)weekdaySymbol:(NSUInteger)weekday;
- (NSString *)monthSymbol:(NSUInteger)month;

- (NSString *)weekdaySymbolForDate:(NSDate *)date;
- (NSString *)monthSymbolForDate:(NSDate *)date;

@end

@interface NSDateComponentsFormatter (Convenience)

+ (instancetype)hhmmFormatter;
+ (instancetype)hhmmssFormatter;
+ (instancetype)mmssFormatter;

+ (instancetype)hhmmFullFormatter;
+ (instancetype)mmssAbbreviatedFormatter;
+ (instancetype)mmShortFormatter;
+ (instancetype)ssShortFormatter;

- (NSString *)stringFromValue:(NSDate *)startDate toValue:(NSDate *)endDate;

@end

@interface NSDateIntervalFormatter (Convinience)

- (NSString *)stringFromTimeInterval:(NSTimeInterval)fromTimeInterval toTimeInterval:(NSTimeInterval)toTimeInterval;

- (instancetype)initWithDateStyle:(NSDateIntervalFormatterStyle)dateStyle timeStyle:(NSDateIntervalFormatterStyle)timeStyle;

@end

@interface NSLengthFormatter (Convenience)

+ (instancetype)lengthFormatter;

@end

@interface NSDate (NSFormatter)

- (NSString *)descriptionForDate:(NSDateFormatterStyle)dateStyle andTime:(NSDateFormatterStyle)timeStyle;
- (NSString *)descriptionForDateAndTime:(NSDateFormatterStyle)dateAndTimeStyle;
- (NSString *)descriptionForDate:(NSDateFormatterStyle)dateStyle;
- (NSString *)descriptionForTime:(NSDateFormatterStyle)timeStyle;

- (NSString *)descriptionWithFormat:(NSString *)format calendar:(NSCalendar *)calendar;
- (NSString *)weekdayDescription;
- (NSString *)timestampDescription;

- (NSString *)descriptionFromNow;

@end

@interface NSDateComponents (NSFormatter)

- (NSString *)description:(NSDateComponentsFormatterUnitsStyle)unitStyle;

@end

@interface NSNumber (NSNumberFormatter)

- (NSString *)localizedStringWithNumberStyle:(NSNumberFormatterStyle)style;

@end
