//
//  NSFileManager+iCloud.h
//  Ringtonic
//
//  Created by Alexander Ivanov on 19.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "NSFileManager+Convenience.h"

@interface NSFileManager (iCloud)

- (BOOL)isUbiquityAvailable;
+ (BOOL)isUbiquityAvailable;

- (BOOL)URLForUbiquityContainerIdentifier:(NSString *)containerIdentifier handler:(void(^)(NSURL *url))handler;
+ (BOOL)URLForUbiquityContainerIdentifier:(NSString *)containerIdentifier handler:(void(^)(NSURL *url))handler;

@end

@interface NSURL (Coordinator)

- (void)coordinateWriting:(void(^)(NSURL *url))writer options:(NSFileCoordinatorWritingOptions)options handler:(void(^)(BOOL success))handler;

- (void)coordinateReading:(void(^)(NSURL *url))reader options:(NSFileCoordinatorReadingOptions)options handler:(void(^)(BOOL success))handler;

- (void)coordinateDeleting:(void(^)(BOOL success))handler;

- (void)coordinateCopyingFrom:(NSURL *)url overwrite:(BOOL)overwrite handler:(void(^)(BOOL success))handler;
- (void)coordinateCopyingTo:(NSURL *)url overwrite:(BOOL)overwrite handler:(void(^)(BOOL success))handler;

- (void)coordinateMovingFrom:(NSURL *)url overwrite:(BOOL)overwrite handler:(void(^)(BOOL success))handler;
- (void)coordinateMovingTo:(NSURL *)url overwrite:(BOOL)overwrite handler:(void(^)(BOOL success))handler;

@end

@interface NSURL (iCloud)

- (BOOL)isUbiquitous;
- (void)setUbiquitous:(BOOL)flag destinationURL:(NSURL *)destinationURL handler:(void(^)(BOOL success))handler;
- (BOOL)startDownloading;
- (BOOL)evict;
- (NSURL *)URLForPublishing:(NSDate *)outDate;

- (void)moveToCloud:(NSURL *)cloudURL;
- (void)moveLocally:(NSURL *)localURL;

- (void)moveToUbiquityContainer:(NSString *)containerIdentifier;
- (void)moveToUbiquityContainer;

- (void)copyToUbiquityContainer:(NSString *)containerIdentifier;
- (void)copyToUbiquityContainer;

+ (instancetype)URLWithString:(NSString *)URLString ubiquityContainer:(NSString *)containerIdentifier;

@end
