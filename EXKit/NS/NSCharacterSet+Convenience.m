//
//  NSCharacterSet+Convenience.m
//  Ringtonic
//
//  Created by Alexander Ivanov on 26.07.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "NSCharacterSet+Convenience.h"

@implementation NSCharacterSet (Convenience)

- (instancetype)unionWithCharacterSets:(NSArray<NSCharacterSet *> *)otherSets {
	NSMutableCharacterSet *set = [self mutableCopy];
	for (NSCharacterSet *otherSet in otherSets)
		[set formUnionWithCharacterSet:otherSet];
	return set;
}

- (instancetype)unionWithCharacterSet:(NSCharacterSet *)otherSet {
	return [self unionWithCharacterSets:arr_(otherSet)];
}

__static(NSCharacterSet *, URLAllowedCharacterSet, ([[self URLHostAllowedCharacterSet] unionWithCharacterSets:@[ [self URLUserAllowedCharacterSet], [self URLPasswordAllowedCharacterSet], [self URLPathAllowedCharacterSet], [self URLQueryAllowedCharacterSet], [self URLFragmentAllowedCharacterSet] ]]))

@end
