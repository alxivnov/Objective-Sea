//
//  NSLib.m
//  Done!
//
//  Created by Alexander Ivanov on 17.10.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

//#import "NSData+Reader.h"
#import "NSHelper.h"

@implementation NSHelper

+ (BOOL)wait:(NSTimeInterval)interval flag:(BOOL *)flag step:(NSTimeInterval)step {
	for (; interval > 0.0 && !*flag; interval -= step)
		[NSThread sleepForTimeInterval:step];
	
	return *flag;
}

+ (BOOL)wait:(NSTimeInterval)interval flag:(BOOL *)flag {
	return [self wait:interval flag:flag step:1.0];
}

+ (BOOL)string:(NSString *)value1 isEqualTo:(NSString *)value2 {
	return value1 == value2 || (value2 && [value1 isEqualToString:value2]);
}

+ (BOOL)number:(NSNumber *)value1 isEqualTo:(NSNumber *)value2 {
	return value1 == value2 || (value2 && [value1 isEqualToNumber:value2]);
}

+ (BOOL)date:(NSDate *)value1 isEqualTo:(NSDate *)value2 {
	return value1 == value2 || (value2 && [value1 isEqualToDate:value2]);
}

+ (BOOL)data:(NSData *)value1 isEqualTo:(NSData *)value2 {
	return value1 == value2 || (value2 && [value1 isEqualToData:value2]);
}

+ (NSComparisonResult)string:(NSString *)value1 compare:(NSString *)value2 {
	return value1 == value2 ? NSOrderedSame : !value1 ? NSOrderedDescending : !value2 ? NSOrderedAscending : [value1 compare:value2];
}

+ (NSComparisonResult)number:(NSNumber *)value1 compare:(NSNumber *)value2 {
	return value1 == value2 ? NSOrderedSame : !value1 ? NSOrderedDescending : !value2 ? NSOrderedAscending : [value1 compare:value2];
}

+ (NSComparisonResult)date:(NSDate *)value1 compare:(NSDate *)value2 {
	return value1 == value2 ? NSOrderedSame : !value1 ? NSOrderedDescending : !value2 ? NSOrderedAscending : [value1 compare:value2];
}

@end

@implementation NSString (Log)

- (void)log:(NSString *)message {
	NSLog(!message ? self : ![message hasSuffix:@"%@"] ? [message stringByAppendingString:@" %@"] : message, self);
}

@end

@implementation NSError (Log)

- (void)log:(NSString *)message {
	NSString *description = /*self.localizedDescription ? self.localizedDescription : */self.debugDescription;
	[description log:message];
}

- (void)log {
	[self log:Nil];
}

@end
