//
//  NSString+Data.h
//  Guardian
//
//  Created by Alexander Ivanov on 28.08.14.
//  Copyright (c) 2014 NATEK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Data)

- (NSData *)toData;

- (NSData *)dataUsingDotNetEncoding;

@end

@interface NSMutableString (Reset)

- (void)reset;

@end
