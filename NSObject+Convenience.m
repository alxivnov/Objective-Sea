//
//  NSLib.m
//  Done!
//
//  Created by Alexander Ivanov on 17.10.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import "NSObject+Convenience.h"

@implementation NSObject (Convenience)

- (void)log:(NSString *)message {
	NSLog(message ? [message stringByAppendingString:@" %@"] : self.debugDescription, self.debugDescription);
}

- (id)performSelector:(SEL)aSelector withObjects:(NSArray *)objects {
	NSMethodSignature *signature = [self methodSignatureForSelector:aSelector];
	if (!signature)
		return Nil;

	NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
	invocation.target = self;
	invocation.selector = aSelector;
	for (NSUInteger index = 0; index < objects.count; index++) {
		id object = objects[index];

		if (object == [NSNull null])
			continue;

		[invocation setArgument:&object atIndex:index + 2];
	}
	[invocation invoke];

	return [invocation getReturnValue];
}

- (id)performSelector:(SEL)aSelector withObject:(id)object1 withObject:(id)object2 withObject:(id)object3 {
	return [self performSelector:aSelector withObjects:@[ object1 ?: [NSNull null], object2 ?: [NSNull null], object3 ?: [NSNull null] ]];
}

#pragma diagnostics push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

- (id)forwardSelector:(SEL)aSelector withObjects:(NSArray *)objects nextTarget:(id(^)(id, BOOL, id))block {
	BOOL responds = [self respondsToSelector:aSelector];
	id returnValue = responds ? [self performSelector:aSelector withObjects:objects] : Nil;
	id target = block ? block(self, responds, returnValue) : Nil;
	return target ? [target forwardSelector:aSelector withObjects:objects nextTarget:block] : returnValue;
}

#pragma diagnostics pop

- (id)forwardSelector:(SEL)aSelector withObject:(id)object1 withObject:(id)object2 withObject:(id)object3 nextTarget:(id(^)(id, BOOL, id))block {
	return [self forwardSelector:aSelector withObjects:@[ object1 ?: [NSNull null], object2 ?: [NSNull null], object3 ?: [NSNull null] ] nextTarget:block];
}

- (id)forwardSelector:(SEL)aSelector withObject:(id)object1 withObject:(id)object2 nextTarget:(id(^)(id, BOOL, id))block {
	return [self forwardSelector:aSelector withObjects:@[ object1 ?: [NSNull null], object2 ?: [NSNull null] ] nextTarget:block];
}

- (id)forwardSelector:(SEL)aSelector withObject:(id)object1 nextTarget:(id(^)(id, BOOL, id))block {
	return [self forwardSelector:aSelector withObjects:@[ object1 ?: [NSNull null] ] nextTarget:block];
}

- (id)forwardSelector:(SEL)aSelector nextTarget:(id(^)(id, BOOL, id))block {
	return [self forwardSelector:aSelector withObjects:Nil nextTarget:block];
}

- (BOOL)isEqualToAnyObject:(NSArray *)objects {
	for (id object in objects)
		if ([self isEqual:object])
			return YES;

	return NO;
}

- (BOOL)isKindOfAnyClass:(NSArray *)classes {
	for (Class class in classes)
		if ([self isKindOfClass:class])
			return YES;

	return NO;
}

- (BOOL)isMemberOfAnyClass:(NSArray *)classes {
	for (Class class in classes)
		if ([self isMemberOfClass:class])
			return YES;

	return NO;
}

- (NSData *)archivedData {
	return [NSKeyedArchiver archivedDataWithRootObject:self];
}

+ (instancetype)createFromArchivedData:(NSData *)data {
	return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

@end

#define NSMethodReturnTypeChar "c"
#define NSMethodReturnTypeInt "i"
#define NSMethodReturnTypeShort "s"
#define NSMethodReturnTypeLong "l"
#define NSMethodReturnTypeLongLong "q"
#define NSMethodReturnTypeUnsignedChar "C"
#define NSMethodReturnTypeUnsignedInt "I"
#define NSMethodReturnTypeUnsignedShort "S"
#define NSMethodReturnTypeUnsignedLong "L"
#define NSMethodReturnTypeUnsignedLongLong "Q"
#define NSMethodReturnTypeFloat "f"
#define NSMethodReturnTypeDouble "d"
#define NSMethodReturnTypeBool "B"
#define NSMethodReturnTypeVoid "v"
#define NSMethodReturnTypeCharacterString "*"
#define NSMethodReturnTypeObject "@"
#define NSMethodReturnTypeClass "#"
#define NSMethodReturnTypeSelector ":"

@implementation NSMethodSignature (Convenience)

- (BOOL)methodReturnTypeIs:(char *)methodReturnType {
	return strncmp(self.methodReturnType, methodReturnType, 1) == 0;
}

@end

// https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100

@implementation NSInvocation (Convenience)

- (id)getReturnValue {
	if ([self.methodSignature methodReturnTypeIs:NSMethodReturnTypeChar]) {
		char returnValue = 0;
		[self getReturnValue:&returnValue];
		return @(returnValue);
	} else if ([self.methodSignature methodReturnTypeIs:NSMethodReturnTypeInt]) {
		int returnValue = 0;
		[self getReturnValue:&returnValue];
		return @(returnValue);
	} else if ([self.methodSignature methodReturnTypeIs:NSMethodReturnTypeShort]) {
		short returnValue = 0;
		[self getReturnValue:&returnValue];
		return @(returnValue);
	} else if ([self.methodSignature methodReturnTypeIs:NSMethodReturnTypeLong]) {
		long returnValue = 0;
		[self getReturnValue:&returnValue];
		return @(returnValue);
	} else if ([self.methodSignature methodReturnTypeIs:NSMethodReturnTypeLongLong]) {
		long long returnValue = 0;
		[self getReturnValue:&returnValue];
		return @(returnValue);
	} else if ([self.methodSignature methodReturnTypeIs:NSMethodReturnTypeUnsignedChar]) {
		unsigned char returnValue = 0;
		[self getReturnValue:&returnValue];
		return @(returnValue);
	} else if ([self.methodSignature methodReturnTypeIs:NSMethodReturnTypeUnsignedInt]) {
		unsigned int returnValue = 0;
		[self getReturnValue:&returnValue];
		return @(returnValue);
	} else if ([self.methodSignature methodReturnTypeIs:NSMethodReturnTypeUnsignedShort]) {
		unsigned short returnValue = 0;
		[self getReturnValue:&returnValue];
		return @(returnValue);
	} else if ([self.methodSignature methodReturnTypeIs:NSMethodReturnTypeUnsignedLong]) {
		unsigned long returnValue = 0;
		[self getReturnValue:&returnValue];
		return @(returnValue);
	} else if ([self.methodSignature methodReturnTypeIs:NSMethodReturnTypeUnsignedLongLong]) {
		unsigned long long returnValue = 0;
		[self getReturnValue:&returnValue];
		return @(returnValue);
	} else if ([self.methodSignature methodReturnTypeIs:NSMethodReturnTypeFloat]) {
		float returnValue = 0;
		[self getReturnValue:&returnValue];
		return @(returnValue);
	} else if ([self.methodSignature methodReturnTypeIs:NSMethodReturnTypeDouble]) {
		double returnValue = 0;
		[self getReturnValue:&returnValue];
		return @(returnValue);
	} else if ([self.methodSignature methodReturnTypeIs:NSMethodReturnTypeBool]) {
		BOOL returnValue = NO;
		[self getReturnValue:&returnValue];
		return @(returnValue);
	} else if ([self.methodSignature methodReturnTypeIs:NSMethodReturnTypeCharacterString]
			   || [self.methodSignature methodReturnTypeIs:NSMethodReturnTypeObject]
			   || [self.methodSignature methodReturnTypeIs:NSMethodReturnTypeClass]
			   || [self.methodSignature methodReturnTypeIs:NSMethodReturnTypeSelector]) {
		__unsafe_unretained id returnValue = Nil;
		[self getReturnValue:&returnValue];
		return returnValue;
	}

	return Nil;
}

@end
