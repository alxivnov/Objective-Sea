//
//  KeyValueBase.m
//  Guardian
//
//  Created by Alexander Ivanov on 08.11.14.
//  Copyright (c) 2014 NATEK. All rights reserved.
//

#import "CCKeyBase.h"
#import "NSDictionary+Unlock.h"
#import "NSMutableData+Writer.h"

@implementation CCKeyBase

- (NSData *)value:(NSString *)key {
	id item = [self.dictionary unlock:key];
	
	return [item isKindOfClass:[NSString class]] ? [[NSData alloc] initWithBase64EncodedString:item options:0] : item;
}

- (void)reset {
	for (NSString *key in self.dictionary)
		[cls(NSMutableData, self.dictionary[key]) resetBytes];
}

- (NSData *)encrypt:(NSData *)data {
	return Nil;	// abstract
}

- (NSData *)decrypt:(NSData *)data {
	return Nil;	// abstract
}

@end
