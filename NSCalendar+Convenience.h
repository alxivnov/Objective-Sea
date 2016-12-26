//
//  NSCalendar+Convenience.h
//  Ringtonic
//
//  Created by Alexander Ivanov on 15.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WEEKDAY_SUNDAY 0	// вс
#define WEEKDAY_MONDAY 1	// пн
#define WEEKDAY_TUESDAY 2	// вт
#define WEEKDAY_WEDNESDAY 3	// ср
#define WEEKDAY_THURSDAY 4	// чт
#define WEEKDAY_FRIDAY 5	// пт
#define WEEKDAY_SATURDAY 6	// сб

#define TIME_SECOND 1
#define TIME_MINUTE 60
#define TIME_HOUR 3600		// 60*60
#define TIME_DAY 86400		// 24*60*60
#define TIME_WEEK 604800	// 7*24*60*60
#define TIME_MONTH 2592000		// 30*24*60*60
#define TIME_YEAR 31536000		// 365*24*60*60

@interface NSDate (Convenience)

- (BOOL)isGreaterThan:(NSDate *)date;
- (BOOL)isLessThan:(NSDate *)date;
- (BOOL)isGreaterThanOrEqual:(NSDate *)date;
- (BOOL)isLessThanOrEqual:(NSDate *)date;

@property (assign, nonatomic, readonly) BOOL isPast;
@property (assign, nonatomic, readonly) BOOL isFuture;

@property (assign, nonatomic, readonly) BOOL isYesterday;
@property (assign, nonatomic, readonly) BOOL isToday;
@property (assign, nonatomic, readonly) BOOL isTomorrow;

@property (assign, nonatomic, readonly) NSUInteger weekday;
@property (assign, nonatomic, readonly) NSInteger daysToNow;
@property (assign, nonatomic, readonly) NSInteger secondsFromGMT;

- (NSInteger)componentValue:(NSCalendarUnit)unit;
- (NSDate *)addValue:(NSInteger)value forComponent:(NSCalendarUnit)unit;

- (NSDate *)component:(NSCalendarUnit)unit;
- (NSDate *)dateComponent;
- (NSTimeInterval)timeComponent;

- (NSDate *)nextWeekday:(NSInteger)weekday withTime:(NSTimeInterval)time skipToday:(BOOL)skipToday;
- (NSDate *)nextWeekday:(NSInteger)weekday withTime:(NSTimeInterval)time;

- (NSDate *)nextDay:(NSInteger)day withTime:(NSTimeInterval)time skipToday:(BOOL)skipToday;
- (NSDate *)nextDay:(NSInteger)day withTime:(NSTimeInterval)time;

+ (NSUInteger)firstWeekday;

+ (NSDate *)yesterday;
+ (NSDate *)today;
+ (NSDate *)tomorrow;

- (NSString *)descriptionForDate:(NSDateFormatterStyle)dateStyle andTime:(NSDateFormatterStyle)timeStyle;
- (NSString *)descriptionForDateAndTime:(NSDateFormatterStyle)dateAndTimeStyle;
- (NSString *)descriptionForDate:(NSDateFormatterStyle)dateStyle;
- (NSString *)descriptionForTime:(NSDateFormatterStyle)timeStyle;

- (NSString *)descriptionWithFormat:(NSString *)format calendar:(NSCalendar *)calendar;
- (NSString *)weekdayDescription;
- (NSString *)timestampDescription;

@end

@interface NSDateComponents (Convenience)

+ (NSCalendarUnit)mostSignificantComponent:(NSTimeInterval)ti;

@end
