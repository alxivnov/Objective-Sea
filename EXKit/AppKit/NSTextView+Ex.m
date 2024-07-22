//
//  NSTextView+Ex.m
//  Guardian
//
//  Created by Alexander Ivanov on 06/05/16.
//  Copyright © 2016 NATEK. All rights reserved.
//

#import "NSTextView+Ex.h"

@implementation NSTextView (Ex)

- (NSString *)nullableString {
	return self.string;
}

- (void)setNullableString:(NSString *)string {
	self.string = string ? string : @"";
}

@end
