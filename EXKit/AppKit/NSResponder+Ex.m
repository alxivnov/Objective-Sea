//
//  NSResponder+EX.m
//  Guardian
//
//  Created by Alexander Ivanov on 10.08.15.
//  Copyright (c) 2015 NATEK. All rights reserved.
//

#import "NSResponder+Ex.h"

@implementation NSResponder (Ex)

#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

- (id)passSelector:(SEL)aSelector {
	NSResponder *responder = self;
	while (responder) {
		if ([responder respondsToSelector:aSelector])
			return [responder performSelector:aSelector];
		else
			responder = [responder nextResponder];
	}
	
	return Nil;
}

- (id)passSelector:(SEL)aSelector withObject:(id)object {
	NSResponder *responder = self;
	while (responder) {
		if ([responder respondsToSelector:aSelector])
			return [responder performSelector:aSelector withObject:object];
		else
			responder = [responder nextResponder];
	}
	
	return Nil;
}

- (id)passSelector:(SEL)aSelector withObject:(id)object1 withObject:(id)object2 {
	NSResponder *responder = self;
	while (responder) {
		if ([responder respondsToSelector:aSelector])
			return [responder performSelector:aSelector withObject:object1 withObject:object2];
		else
			responder = [responder nextResponder];
	}
	
	return Nil;
}

@end
