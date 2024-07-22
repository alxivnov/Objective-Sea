//
//  Guid.h
//  Air Tasks
//
//  Created by Alexander Ivanov on 14.10.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NSUUIDSize 16

@interface NSUUID (Guid)

- (instancetype)initWithDotNetString:(NSString *)string;

- (NSString *)dotNetString;

@end
