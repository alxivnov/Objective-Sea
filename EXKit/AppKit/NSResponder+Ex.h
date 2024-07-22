//
//  NSResponder+EX.h
//  Guardian
//
//  Created by Alexander Ivanov on 10.08.15.
//  Copyright (c) 2015 NATEK. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSResponder (Ex)

- (id)passSelector:(SEL)aSelector;
- (id)passSelector:(SEL)aSelector withObject:(id)object;
- (id)passSelector:(SEL)aSelector withObject:(id)object1 withObject:(id)object2;

@end
