//
//  NSURLSession+Convenience.m
//  Sleep Diary
//
//  Created by Alexander Ivanov on 14.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "NSURLSession+Convenience.h"

@implementation NSURLSession (Convenience)

- (NSURLSessionDataTask *)dataTaskWithURL:(NSURL *)url priority:(float)priority completionHandler:(void (^)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))completionHandler {
	if (!url)
		return Nil;

	NSURLSessionDataTask *task = [self dataTaskWithURL:url completionHandler:completionHandler];
	task.priority = priority;
	[task resume];
	return task;
}

- (NSURLSessionDownloadTask *)downloadTaskWithURL:(NSURL *)url priority:(float)priority completionHandler:(void (^)(NSURL * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))completionHandler {
	if (!url)
		return Nil;

	NSURLSessionDownloadTask *task = [self downloadTaskWithURL:url completionHandler:completionHandler];
	task.priority = priority;
	[task resume];
	return task;
}

@end

@interface NSURLSessionRedirection ()
@property (strong, nonatomic) NSURLSession *defaultSession;
@property (strong, nonatomic) NSURLSession *ephemeralSession;
@end

@implementation NSURLSessionRedirection

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler {
	completionHandler(request);
}
/*
- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
	if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
		SecTrustResultType result = [SecHelper evaluate:challenge.protectionSpace.serverTrust];
		if (result == kSecTrustResultUnspecified || result == kSecTrustResultProceed || (result == kSecTrustResultRecoverableTrustFailure && [SecHelper setExceptions:challenge.protectionSpace.serverTrust]))
			completionHandler(NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]);
		else
			completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, Nil);
	} else {
		completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, Nil);
	}
}
*/
static id _instance = Nil;

+ (instancetype)instance {
	@synchronized(self) {
		if (!_instance)
			_instance = [self new];
	}

	return _instance;
}

- (NSURLSession *)defaultSession {
	if (!_defaultSession)
		_defaultSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];

	return _defaultSession;
}

- (NSURLSession *)ephemeralSession {
	if (!_ephemeralSession)
		_ephemeralSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];

	return _ephemeralSession;
}

@end

#define STR_404 @"404"
#define STR_PHP @"php"

@implementation NSURL (NSURLSession)

- (NSURL *)cacheURL {
	if (!self.isWebAddress)
		return Nil;

	NSURL *url = URL_CACHE(self);
	return url.isExistingFile ? url : Nil;
}

- (void)downloadData:(void (^)(NSData *))handler {
	if (self.isWebAddress)
		[[[NSURLSessionRedirection instance] defaultSession] dataTaskWithURL:self priority:NSURLSessionTaskPriorityDefault completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
			if (handler)
				handler(data);

			[error log:@"dataTaskWithURL:"];
		}];
	else if (handler)
//		[GCD global:^{
			handler(Nil);
//		}];
}

- (void)download:(NSURL *)url priority:(float)priority handler:(void (^)(NSURL *))handler {
	if (self.isWebAddress)
		[[[NSURLSessionRedirection instance] defaultSession] downloadTaskWithURL:self priority:priority completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
			BOOL err404 = [[response description] caseInsensitiveContainsAllStrings:@[ STR_404, STR_PHP ]];
			if (err404)
				NSLog(@"err404: %@", response);

			NSURL *written = error || err404 ?  Nil : url ? [location moveItem:url overwrite:YES] : location;

			if (handler)
				handler(written);

			[error log:@"downloadTaskWithURL:"];
		}];
/*		[DSHelper dispatchToGlobal:^{
			NSError *error = Nil;
			NSData *data = [NSData dataWithContentsOfURL:self options:0 error:&error];
			BOOL written = [data writeToURL:url ? url : URL_CACHE(self) atomically:YES];

			if (handler)
				handler(written ? url : Nil);

			[error log:@"dataWithContentsOfURL:"];
		}];
*/	else if (handler)
//		 [GCD global:^{
			 handler(Nil);
//		 }];
}

- (void)download:(NSURL *)url handler:(void (^)(NSURL *))handler {
	[self download:url priority:NSURLSessionTaskPriorityDefault handler:handler];
}

- (BOOL)download:(NSURL *)url {
	if (!self.isWebAddress)
		return NO;

	NSError *error = Nil;
	NSData *data = [NSData dataWithContentsOfURL:self options:0 error:&error];
	[error log:@"dataWithContentsOfURL:"];
	BOOL written = [data writeToURL:url ? url : URL_CACHE(self) atomically:YES];
	return written;
}

- (void)cache:(BOOL)read handler:(void (^)(NSURL *))handler {
	NSURL *url = self.isWebAddress ? URL_CACHE(self) : self;

	BOOL download = self.isWebAddress && !url.isExistingFile;

	if (!download || read)
//		[GCD global:^{
			handler(url);
//		}];

	if (download || read)
		[self download:url handler:handler];
}

- (void)cache:(void (^)(NSURL *))handler {
	[self cache:NO handler:handler];
}

- (NSURL *)cache {
	NSURL *url = self.isWebAddress ? URL_CACHE(self) : self;

	return self.isWebAddress && !url.isExistingFile ? [self download:url] ? url : Nil : url;
}

@end

@implementation NSJSONSerialization (Convenience)

+ (id)JSONObjectWithData:(NSData *)data {
	if (!data)
		return Nil;

	NSError *error = Nil;
	id obj = [self JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
	[error log:@"JSONObjectWithData:"];
	return obj;
}

+ (NSData *)dataWithJSONObject:(id)obj {
	if (!obj)
		return Nil;

	NSError *error = Nil;
	NSData *data = [self dataWithJSONObject:obj options:0 error:&error];
	[error log:@"dataWithJSONObject:"];
	return data;
}

+ (id)JSONObjectWithString:(NSString *)string {
	return [self JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding]];
}

+ (NSString *)stringWithJSONObject:(id)obj {
	NSStringEncoding encoding = NSUTF8StringEncoding;
	return [NSString stringWithData:[self dataWithJSONObject:obj] encoding:&encoding];
}

@end

@implementation NSArray (JSON)

+ (instancetype)arrayWithJSONContentsOfURL:(NSURL *)url {
	return cls(NSArray, [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:url]]);
}

- (BOOL)writeJSONToURL:(NSURL *)url atomically:(BOOL)atomically {
	return [[NSJSONSerialization dataWithJSONObject:self] writeToURL:url atomically:atomically];
}

@end

@implementation NSDictionary (JSON)

+ (instancetype)dictionaryWithJSONContentsOfURL:(NSURL *)url {
	return cls(NSDictionary, [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:url]]);
}

- (BOOL)writeJSONToURL:(NSURL *)url atomically:(BOOL)atomically {
	return [[NSJSONSerialization dataWithJSONObject:self] writeToURL:url atomically:atomically];
}

@end

@implementation NSURL (NSURLRequest)

- (NSURLSessionDataTask *)sendRequestWithMethod:(NSString *)method header:(NSDictionary<NSString *, NSString *> *)header body:(NSData *)body completion:(void(^)(NSData *, NSURLResponse *))completion {
//	if (!method/* || !header || !body*/)
//		return Nil;

	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self];
	if (method)
		[request setHTTPMethod:method];
	for (NSString *field in header.allKeys)
		[request addValue:header[field] forHTTPHeaderField:field];
	[request setHTTPBody:body];

	NSURLSession *session = [NSURLSessionRedirection instance].defaultSession;
	NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		if (completion)
			completion(data, response);

		[error log:@"dataTaskWithRequest:"];
	}];
	[task resume];
	return task;
}

// FORM
- (NSURLSessionDataTask *)sendRequestWithMethod:(NSString *)method header:(NSDictionary<NSString *,NSString *> *)header form:(NSDictionary<NSString *,NSString *> *)form completion:(void (^)(NSData *, NSURLResponse *))completion {
	NSMutableString *body = Nil;

	if (form) {
		NSString *boundary = [NSUUID UUID].UUIDString;

		NSMutableDictionary *dictionary = [header mutableCopy] ?: [NSMutableDictionary dictionaryWithCapacity:header.count + 1];
		dictionary[@"Content-Type"] = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
		header = dictionary;


		body = [NSMutableString string];

		for (NSString *key in form.allKeys) {
			[body appendFormat:@"--%@\r\n", boundary];
			[body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key];
			[body appendFormat:@"%@\r\n", form[key]];
		}

		[body appendFormat:@"--%@\r\n", boundary];
	}

	return [self sendRequestWithMethod:method header:header body:[body dataUsingEncoding:NSUTF8StringEncoding] completion:^(NSData *data, NSURLResponse *response) {
//		id object = [NSJSONSerialization JSONObjectWithData:data];

		if (completion)
			completion(data, response);
	}];
}

// JSON
- (NSURLSessionDataTask *)sendRequestWithMethod:(NSString *)method header:(NSDictionary<NSString *, NSString *> *)header json:(id)json completion:(void(^)(id, NSURLResponse *))completion {
	if (json) {
		NSMutableDictionary *dictionary = [header mutableCopy] ?: [NSMutableDictionary dictionaryWithCapacity:header.count + 1];
		dictionary[@"Content-Type"] = @"application/json; charset=utf-8";
		header = dictionary;
	}

	return [self sendRequestWithMethod:method header:header body:[NSJSONSerialization dataWithJSONObject:json] completion:^(NSData *data, NSURLResponse *response) {
		id object = [NSJSONSerialization JSONObjectWithData:data];

		if (completion)
			completion(object, response);

		if (!object)
			[[NSString stringWithData:data] log:@"JSON:"];
	}];
}

#if __has_include("NSXMLDictionary.h")
// SOAP
- (NSURLSessionDataTask *)sendRequestWithContract:(NSString *)contract action:(NSString *)action parameters:(NSDictionary *)parameters completion:(void(^)(id, NSURLResponse *))completion {
	NSMutableString *params = [NSMutableString string];
	for (NSObject *key in parameters)
		[params appendFormat:@"<%@>%@</%@>", key, parameters[key], key];

	NSString *format = @"<s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\">"
/*		"<s:Header>"
			"<Action>"
				"http://tempuri.org/%@/%@"
			"</Action>"
		"</s:Header>"
*/		"<s:Body>"
			"<%@ xmlns=\"http://tempuri.org/\">"
				"%@"
			"</%@>"
		"</s:Body>"
	"</s:Envelope>";
	NSString *body = [NSString stringWithFormat:format, /*contract, action,*/ action, params, action];

	NSDictionary *header = @{ @"soapAction" : [NSString stringWithFormat:@"http://tempuri.org/%@/%@", contract, action], @"Content-Type" : @"text/xml; charset=utf-8", @"Content-Length" : str(body.length) };

	return [self sendRequestWithMethod:@"POST" header:header body:[body dataUsingEncoding:NSUTF8StringEncoding] completion:^(NSData *data, NSURLResponse *response) {
		NSDictionary *dictionary = [NSXMLDictionary parseData:data];
		NSDictionary *sBody = dictionary[@"s:Body"];

		NSString *sFault = sBody[@"s:Fault"];
		if (sFault)
			NSLog(@"s:Fault: %@", sFault);

		NSDictionary *sResponse = sBody[[NSString stringWithFormat:@"%@Response", action]];
		id sResult = sResponse[[NSString stringWithFormat:@"%@Result", action]];

		if (completion)
			completion(sResult, response);

		if (!sResult)
			[[NSString stringWithData:data] log:@"string:"];
	}];
}
#endif

@end
