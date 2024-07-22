//
//  NSCharacterSet+Convenience.h
//  Ringtonic
//
//  Created by Alexander Ivanov on 26.07.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSObject+Convenience.h"

@interface NSCharacterSet (Convenience)

- (instancetype)unionWithCharacterSets:(NSArray<NSCharacterSet *> *)otherSets;
- (instancetype)unionWithCharacterSet:(NSCharacterSet *)otherSet;

+ (NSCharacterSet *)URLAllowedCharacterSet;

@end
