//
//  Guid.m
//  Air Tasks
//
//  Created by Alexander Ivanov on 14.10.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "NSUUID+Guid.h"

@implementation NSUUID (Guid)

+ (NSString *)reverseUUIDString:(NSString *)string {
	NSArray *components = [string componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"-"]];

	NSMutableString *uuidString = [NSMutableString stringWithCapacity:string.length];
	for (NSUInteger index = 0; index < components.count; index++) {
		NSString *component = components[index];

		if (index < 3) {
			NSMutableString *s = [NSMutableString stringWithCapacity:component.length];
			for (NSInteger i = (component.length / 2) - 1; i >= 0; i--)
				[s appendString:[component substringWithRange:NSMakeRange(i * 2, 2)]];
			component = s;
		}

		if (index > 0)
			[uuidString appendString:@"-"];

		[uuidString appendString:component];
	}
	return uuidString;
}

- (instancetype)initWithDotNetString:(NSString *)string {
	return [self initWithUUIDString:[[self class] reverseUUIDString:string]];
}

- (NSString *)dotNetString {
	return [[self class] reverseUUIDString:[self UUIDString]];
}

@end
