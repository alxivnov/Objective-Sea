//
//  NSTextField+Ex.m
//  Guardian
//
//  Created by Alexander Ivanov on 06/05/16.
//  Copyright © 2016 NATEK. All rights reserved.
//

#import "NSTextField+Ex.h"

@implementation NSTextField (Ex)

- (NSString *)nullableStringValue {
	return self.stringValue;
}

- (void)setNullableStringValue:(NSString *)stringValue {
	self.stringValue = stringValue ? stringValue : @"";
}

@end
