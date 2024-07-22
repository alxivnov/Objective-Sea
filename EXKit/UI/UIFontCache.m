//
//  UIFontCache.m
//  Air Tasks
//
//  Created by Alexander Ivanov on 23.02.15.
//  Copyright (c) 2015 Alex Ivanov. All rights reserved.
//

#import "UIFontCache.h"

#import "NSObject+Convenience.h"

#define FONT_SYSTEM @"System"

#define FONT_AVENIR_NEXT @"Avenir Next"

#define FONT_SNELL_ROUNDHAND @"Snell Roundhand"

@implementation UIFontCache

__static(NSMutableDictionary *, fonts, [[NSMutableDictionary alloc] init])

- (UIFont *)objectForKey:(NSArray *)aKey {
	NSString *key = [aKey componentsJoinedByString:@"+"];

	UIFont *font = [[self class] fonts][key];

	if (!font)
		font = [[self class] fonts][key] = [aKey.firstObject isEqualToString:FONT_SYSTEM] ? [UIFont systemFontOfSize:[aKey.lastObject doubleValue]] : [UIFont fontWithName:aKey.firstObject size:[aKey.lastObject doubleValue]];

	return font;
}

- (UIFont *)system:(CGFloat)size {
	return [self objectForKey:@[ FONT_SYSTEM, @(size) ]];
}

- (UIFont *)avenirNext:(CGFloat)size {
	return [self objectForKey:@[ FONT_AVENIR_NEXT, @(size) ]];
}

- (UIFont *)snellRoundhand:(CGFloat)size {
	return [self objectForKey:@[ FONT_SNELL_ROUNDHAND, @(size) ]];
}

static id _instance;

+ (instancetype)instance {
	@synchronized(self) {
		if (!_instance)
			_instance = [self new];
	}
	
	return (id)_instance;
}

@end
