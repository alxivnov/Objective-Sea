//
//  NSURLSecurity.h
//  Guardian
//
//  Created by Alexander Ivanov on 16.10.14.
//  Copyright (c) 2014 NATEK. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LocalAuthentication+Convenience.h"

@interface NSURLTrustedConnection : NSObject <NSURLConnectionDataDelegate, NSURLConnectionDelegate>

+ (void)sendAsynchronousRequest:(NSURLRequest*)request queue:(NSOperationQueue*)queue completionHandler:(void (^)(NSURLResponse* response, NSData* data, NSError* connectionError))handler trust:(BOOL)trust;
+ (void)sendAsynchronousRequest:(NSURLRequest*)request queue:(NSOperationQueue*)queue completionHandler:(void (^)(NSURLResponse* response, NSData* data, NSError* connectionError))handler;

@end
