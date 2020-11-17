//
//  NSLib.m
//  Done!
//
//  Created by Alexander Ivanov on 17.10.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import "NSObject+Convenience.h"

@implementation NSObject (Convenience)

- (id)cast:(Class)type {
	return [self isKindOfClass:type] ? self : Nil;
}

- (void)log:(NSString *)message {
	NSString *description = [self forwardSelector:@selector(componentsJoinedByString:) withObject:@", "];
	if (!description)
		description = self.debugDescription;

	NSLog(message ? [message stringByAppendingString:@" %@"] : description, description);
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

- (id)forwardSelector:(SEL)aSelector {
	return [self respondsToSelector:aSelector] ? [self performSelector:aSelector] : Nil;
}

- (id)forwardSelector:(SEL)aSelector withObject:(id)object1 {
	return [self respondsToSelector:aSelector] ? [self performSelector:aSelector withObject:object1] : Nil;
}

- (id)forwardSelector:(SEL)aSelector withObject:(id)object1 withObject:(id)object2 {
	return [self respondsToSelector:aSelector] ? [self performSelector:aSelector withObject:object1 withObject:object2] : Nil;
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

- (BOOL)isNull {
	return self == [NSNull null];
}

- (NSData *)archivedData {
	return [NSKeyedArchiver archivedDataWithRootObject:self];
}

+ (instancetype)createFromArchivedData:(NSData *)data {
	return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

- (id)tryGetValueForKey:(NSString *)key {
	id value = Nil;
	@try {
		value = [self valueForKey:key];
	}
	@finally {
		return value;
	}
}

- (BOOL)trySetValue:(id)value forKey:(NSString *)key {
	BOOL success = NO;
	@try {
		[self setValue:value forKey:key];

		success = YES;
	}
	@finally {
		return success;
	}
}

+ (instancetype)arrayWithObject:(id)obj0 withObject:(id)obj1 withObject:(id)obj2 {
	NSMutableArray *arr = [NSMutableArray arrayWithCapacity:3];

	if (obj0)
		[arr addObject:obj0];
	if (obj1)
		[arr addObject:obj1];
	if (obj2)
		[arr addObject:obj2];

	return arr;
}

+ (instancetype)dictionaryWithObject:(id)obj0 forKey:(id<NSCopying>)key0 withObject:(id)obj1 forKey:(id<NSCopying>)key1 withObject:(id)obj2 forKey:(id<NSCopying>)key2 {
	NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:3];

	if (key0 && obj0)
		[dic setObject:obj0 forKey:key0];
	if (key1 && obj1)
		[dic setObject:obj1 forKey:key1];
	if (key2 && obj2)
		[dic setObject:obj2 forKey:key2];

	return dic;
}

- (id)valueForPath:(NSArray *)path {
	id obj = self;
	
	for (id component in path) {
		if ([component isKindOfClass:[NSString class]] && ([obj isKindOfClass:[NSDictionary class]] || [obj isKindOfClass:[NSMutableDictionary class]])) {
			obj = [obj objectForKey:component];
		} else if ([component isKindOfClass:[NSNumber class]] && ([obj isKindOfClass:[NSArray class]] || [obj isKindOfClass:[NSMutableArray class]])) {
			obj = [obj valueAtIndex:[component integerValue]];
		}
	}
	
	return obj;
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

@implementation NSNumber (Convenience)

- (BOOL)isNotANumber {
	return [self isEqualToNumber:[NSDecimalNumber notANumber]];
}

- (NSDecimalNumber *)decimalNumber {
	return [[NSDecimalNumber alloc] initWithDouble:self.doubleValue];
}

@end

@implementation NSArray (Index)

- (id)valueAtIndex:(NSInteger)index {
	return index >= 0 && index < self.count ? self[index] : index < 0 && index >= -self.count ? self[self.count + index] : Nil;
}

@end
