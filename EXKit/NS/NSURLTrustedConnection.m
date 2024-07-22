//
//  NSURLSecurity.m
//  Guardian
//
//  Created by Alexander Ivanov on 16.10.14.
//  Copyright (c) 2014 NATEK. All rights reserved.
//

#import "NSURLTrustedConnection.h"

@interface NSURLTrustedConnection ()
@property (strong, nonatomic) NSMutableData *data;
@property (strong, nonatomic) NSURLResponse *response;
@property (copy, nonatomic) void (^handler)(NSURLResponse* response, NSData* data, NSError* connectionError);
@property (assign, nonatomic) BOOL trust;
@end

@implementation NSURLTrustedConnection

- (NSMutableData *)data {
	if (!_data)
		_data = [NSMutableData data];

	return _data;
}

- (instancetype)initWithHandler:(void (^)(NSURLResponse* response, NSData* data, NSError* connectionError))handler trust:(BOOL)trust {
	self = [self init];

	if (self) {
		self.handler = handler;
		self.trust = trust;
	}

	return self;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[self.data setLength:0];

	self.response = response;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[self.data appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	self.handler(self.response, self.data, error);

	self.data = Nil;
	self.response = Nil;
	self.handler = Nil;
	
	[error log:@"connection:didFailWithError:"];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	self.handler(self.response, self.data, Nil);

	self.data = Nil;
	self.response = Nil;
	self.handler = Nil;
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	if (self.trust && [challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
		SecTrustResultType result = [SecHelper evaluate:challenge.protectionSpace.serverTrust];
		if (result == kSecTrustResultUnspecified || result == kSecTrustResultProceed || (result == kSecTrustResultRecoverableTrustFailure && [SecHelper setExceptions:challenge.protectionSpace.serverTrust]))
			[challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
		else
			[challenge.sender cancelAuthenticationChallenge:challenge];
	} else {
		[challenge.sender performDefaultHandlingForAuthenticationChallenge:challenge];
	}
}

+ (void)sendAsynchronousRequest:(NSURLRequest*)request queue:(NSOperationQueue*)queue completionHandler:(void (^)(NSURLResponse* response, NSData* data, NSError* connectionError))handler trust:(BOOL)trust {
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:[[NSURLTrustedConnection alloc] initWithHandler:handler trust:trust] startImmediately:NO];
	[connection setDelegateQueue:queue];
	[connection start];
}

+ (void)sendAsynchronousRequest:(NSURLRequest*)request queue:(NSOperationQueue*)queue completionHandler:(void (^)(NSURLResponse* response, NSData* data, NSError* connectionError))handler {
	[self sendAsynchronousRequest:request queue:queue completionHandler:handler trust:NO];
}

@end
