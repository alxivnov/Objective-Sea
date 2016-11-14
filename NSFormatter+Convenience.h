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

+ (instancetype)mmssAbbreviatedFormatter;

- (NSString *)stringFromValue:(NSDate *)startDate toValue:(NSDate *)endDate;

@end

@interface NSDateIntervalFormatter (Convinience)

- (NSString *)stringFromTimeInterval:(NSTimeInterval)fromTimeInterval toTimeInterval:(NSTimeInterval)toTimeInterval;

- (instancetype)initWithDateStyle:(NSDateIntervalFormatterStyle)dateStyle timeStyle:(NSDateIntervalFormatterStyle)timeStyle;

@end
