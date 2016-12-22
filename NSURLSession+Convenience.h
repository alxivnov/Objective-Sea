//
//  NSURLSession+Convenience.h
//  Sleep Diary
//
//  Created by Alexander Ivanov on 14.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CommonCrypto+Convenience.h"
#import "Dispatch+Convenience.h"
#import "NSFileManager+Convenience.h"
#import "NSObject+Convenience.h"
#import "NSString+Convenience.h"
#import "NSURL+Convenience.h"

@interface NSURLSession (Convenience)

- (NSURLSessionDataTask *)dataTaskWithURL:(NSURL *)url priority:(float)priority;
- (NSURLSessionDataTask *)dataTaskWithURL:(NSURL *)url priority:(float)priority completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler;

- (NSURLSessionDownloadTask *)downloadTaskWithURL:(NSURL *)url priority:(float)priority;
- (NSURLSessionDownloadTask *)downloadTaskWithURL:(NSURL *)url priority:(float)priority completionHandler:(void (^)(NSURL *location, NSURLResponse *response, NSError *error))completionHandler;

@end

@interface NSURLSessionRedirection : NSObject <NSURLSessionTaskDelegate>

+ (instancetype)instance;

@property (strong, nonatomic, readonly) NSURLSession *defaultSession;
@property (strong, nonatomic, readonly) NSURLSession *ephemeralSession;

@end

#define URL_CACHE(url) [[[NSFileManager URLForDirectory:NSCachesDirectory] URLByAppendingPathComponent:[[url.absoluteString dataUsingEncoding:NSUnicodeStringEncoding] md5].UUIDString] URLByAppendingPathExtension:url.pathExtension]

@interface NSURL (NSURLSession)

@property (strong, nonatomic, readonly) NSURL *cacheURL;

- (void)download:(NSURL *)url priority:(float)priority handler:(void (^)(NSURL *))handler;
- (void)download:(NSURL *)url handler:(void (^)(NSURL *url))handler;
- (void)cache:(void (^)(NSURL *url))handler;

- (BOOL)download:(NSURL *)url;
- (NSURL *)cache;

@end

@interface NSJSONSerialization (Convenience)

+ (id)JSONObjectWithData:(NSData *)data;

+ (NSData *)dataWithJSONObject:(id)obj;

@end
