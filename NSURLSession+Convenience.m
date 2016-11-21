//
//  NSURLSession+Convenience.m
//  Sleep Diary
//
//  Created by Alexander Ivanov on 14.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "NSURLSession+Convenience.h"

@implementation NSURLSession (Convenience)

- (NSURLSessionDataTask *)dataTaskWithURL:(NSURL *)url priority:(float)priority {
	if (!url)
		return Nil;

	NSURLSessionDataTask *task = [self dataTaskWithURL:url];
	task.priority = priority;
	[task resume];
	return task;
}

- (NSURLSessionDataTask *)dataTaskWithURL:(NSURL *)url priority:(float)priority completionHandler:(void (^)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))completionHandler {
	if (!url)
		return Nil;

	NSURLSessionDataTask *task = [self dataTaskWithURL:url completionHandler:completionHandler];
	task.priority = priority;
	[task resume];
	return task;
}

- (NSURLSessionDownloadTask *)downloadTaskWithURL:(NSURL *)url priority:(float)priority {
	if (!url)
		return Nil;

	NSURLSessionDownloadTask *task = [self downloadTaskWithURL:url];
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

@implementation NSURL (Download)

- (NSURL *)cacheURL {
	if (!self.isWebAddress)
		return Nil;

	NSURL *url = URL_CACHE(self);
	return url.isExistingFile ? url : Nil;
}

- (void)download:(NSURL *)url priority:(float)priority handler:(void (^)(NSURL *))handler {
	if (self.isWebAddress)
		[[[NSURLSessionRedirection instance] defaultSession] downloadTaskWithURL:self priority:priority completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
			[error log:@"downloadTaskWithURL:"];

			BOOL err404 = [[response description] caseInsensitiveContainsAllStrings:@[ STR_404, STR_PHP ]];
			if (err404)
				NSLog(@"err404: %@", response);

			NSURL *written = error || err404 ?  Nil : url ? [location moveItem:url overwrite:YES] : location;

			if (handler)
				handler(written);
		}];
	/*		[DSHelper dispatchToGlobal:^{
	 NSError *error = Nil;
	 NSData *data = [NSData dataWithContentsOfURL:self options:0 error:&error];
	 [error log:@"dataWithContentsOfURL:"];
	 BOOL written = [data writeToURL:url ? url : URL_CACHE(self) atomically:YES];

	 if (handler)
	 handler(written ? url : Nil);
		}];
	 */	else if (handler)
		 [GCD global:^{
			 handler(Nil);
		 }];
}

- (void)download:(NSURL *)url handler:(void (^)(NSURL *))handler {
	[self download:url priority:NSURLSessionTaskPriorityDefault handler:handler];
}

- (void)cache:(void (^)(NSURL *))handler {
	NSURL *url = self.isWebAddress ? URL_CACHE(self) : self;

	if (self.isWebAddress && !url.isExistingFile)
		[self download:url handler:handler];
	else if (handler)
		[GCD global:^{
			handler(url);
		}];
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

- (NSURL *)cache {
	NSURL *url = self.isWebAddress ? URL_CACHE(self) : self;

	return self.isWebAddress && !url.isExistingFile ? [self download:url] ? url : Nil : url;
}

@end