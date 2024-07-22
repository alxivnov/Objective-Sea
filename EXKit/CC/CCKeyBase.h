//
//  KeyValueBase.h
//  Guardian
//
//  Created by Alexander Ivanov on 08.11.14.
//  Copyright (c) 2014 NATEK. All rights reserved.
//

#import "NSXMLDictionaryBase.h"

@interface CCKeyBase : NSXMLDictionaryBase

- (NSData *)value:(NSString *)key;

- (void)reset;

- (NSData *)encrypt:(NSData *)data;	// abstract
- (NSData *)decrypt:(NSData *)data;	// abstract

@end
