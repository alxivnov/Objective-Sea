//
//  NSFileManager+iCloud.m
//  Ringtonic
//
//  Created by Alexander Ivanov on 19.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "NSFileManager+iCloud.h"

@implementation NSFileManager (iCloud)

- (BOOL)isUbiquityAvailable {
	return self.ubiquityIdentityToken ? YES : NO;
}

- (BOOL)URLForUbiquityContainerIdentifier:(NSString *)containerIdentifier handler:(void(^)(NSURL *))handler {
	if (![self ubiquityIdentityToken])
		return NO;

	[GCD global:^{
		NSURL *url = [self URLForUbiquityContainerIdentifier:containerIdentifier];

		if (handler)
			handler(url);
	}];
	return YES;
}

+ (BOOL)isUbiquityAvailable {
	return [[self defaultManager] isUbiquityAvailable];
}

+ (BOOL)URLForUbiquityContainerIdentifier:(NSString *)containerIdentifier handler:(void (^)(NSURL *))handler {
	return [[self defaultManager] URLForUbiquityContainerIdentifier:containerIdentifier handler:handler];
}

@end

#if TARGET_OS_IPHONE
#import "UIApplication+Convenience.h"
#endif

@implementation NSURL (Coordinator)

- (void)coordinateWriting:(void(^)(NSURL *url))writer options:(NSFileCoordinatorWritingOptions)options  handler:(void(^)(BOOL success))handler {
	[GCD global:^{
		__block NSError *error = Nil;
		BOOL success = YES;
#if TARGET_OS_IPHONE
		success = [[UIApplication sharedApplication] performBackgroundTask:^{
#endif
			[[[NSFileCoordinator alloc] initWithFilePresenter:Nil] coordinateWritingItemAtURL:self options:options error:&error byAccessor:writer];

			[error log:@"coordinateWritingItemAtURL:"];
#if TARGET_OS_IPHONE
		}];
#endif
		if (handler)
			handler(success && !error);
	}];
}

- (void)coordinateReading:(void(^)(NSURL *url))reader options:(NSFileCoordinatorReadingOptions)options  handler:(void(^)(BOOL success))handler {
	[GCD global:^{
		__block NSError *error = Nil;
		BOOL success = YES;
#if TARGET_OS_IPHONE
		success = [[UIApplication sharedApplication] performBackgroundTask:^{
#endif
			[[[NSFileCoordinator alloc] initWithFilePresenter:Nil] coordinateReadingItemAtURL:self options:options error:&error byAccessor:reader];

			[error log:@"coordinateWritingItemAtURL:"];
#if TARGET_OS_IPHONE
		}];
#endif
		if (handler)
			handler(success && !error);
	}];
}

- (void)coordinateDeleting:(void(^)(BOOL success))handler {
	[self coordinateWriting:^(NSURL *url) {
		[url removeItem];
	} options:NSFileCoordinatorWritingForDeleting handler:handler];
};

- (void)coordinateCopyingFrom:(NSURL *)from overwrite:(BOOL)overwrite handler:(void(^)(BOOL success))handler {
	[self coordinateWriting:^(NSURL *url) {
		[from copyItem:url overwrite:overwrite];
	} options:NSFileCoordinatorWritingForReplacing handler:handler];
}

- (void)coordinateCopyingTo:(NSURL *)to overwrite:(BOOL)overwrite handler:(void(^)(BOOL success))handler {
	[self coordinateReading:^(NSURL *url) {
		[url copyItem:to overwrite:overwrite];
	} options:0 handler:handler];
}

- (void)coordinateMovingFrom:(NSURL *)from overwrite:(BOOL)overwrite handler:(void(^)(BOOL success))handler {
	[self coordinateWriting:^(NSURL *url) {
		[from moveItem:url overwrite:overwrite];
	} options:NSFileCoordinatorWritingForReplacing handler:handler];
}

- (void)coordinateMovingTo:(NSURL *)to overwrite:(BOOL)overwrite handler:(void(^)(BOOL success))handler {
	[self coordinateWriting:^(NSURL *url) {
		[url moveItem:to overwrite:overwrite];
	} options:NSFileCoordinatorWritingForDeleting handler:handler];
}

@end

#define STR_DOCUMENTS @"Documents"

@implementation NSURL (Ubiquity)

- (BOOL)isUbiquitous {
	return [[NSFileManager defaultManager] isUbiquitousItemAtURL:self];
}

- (void)setUbiquitous:(BOOL)flag destinationURL:(NSURL *)destinationURL handler:(void(^)(BOOL success))handler {
	[GCD global:^{
		__block NSError *error = Nil;

		BOOL exists = [destinationURL isExistingItem];
		[destinationURL coordinateWriting:^(NSURL *url) {
			if (exists)
				[[NSFileManager defaultManager] replaceItemAtURL:destinationURL withItemAtURL:self backupItemName:Nil options:NSFileManagerItemReplacementUsingNewMetadataOnly resultingItemURL:Nil error:&error];
			else
				[[NSFileManager defaultManager] setUbiquitous:YES itemAtURL:self destinationURL:destinationURL error:&error];

			[error log:exists ? @"replaceItemAtURL:" : @"setUbiquitous:"];
		} options:exists ? NSFileCoordinatorWritingForReplacing : NSFileCoordinatorWritingForMoving handler:^(BOOL success) {
			if (handler)
				handler(success && !error);
		}];
	}];
}

- (BOOL)startDownloading {
	NSError *error = Nil;

	BOOL success = [[NSFileManager defaultManager] startDownloadingUbiquitousItemAtURL:self error:&error];

	[error log:@"startDownloadingUbiquitousItemAtURL:"];

	return success;
}

- (BOOL)evict {
	NSError *error = Nil;

	BOOL success = [[NSFileManager defaultManager] evictUbiquitousItemAtURL:self error:&error];

	[error log:@"evictUbiquitousItemAtURL:"];

	return success;
}

- (NSURL *)URLForPublishing:(NSDate *)outDate {
	NSError *error = Nil;

	NSURL *url = [[NSFileManager defaultManager] URLForPublishingUbiquitousItemAtURL:self expirationDate:&outDate error:&error];

	[error log:@"URLForPublishingUbiquitousItemAtURL:"];

	return url;
}

- (void)moveToCloud:(NSURL *)cloudURL {
	[self setUbiquitous:YES destinationURL:cloudURL handler:Nil];
}

- (void)moveLocally:(NSURL *)localURL {
	[self setUbiquitous:NO destinationURL:localURL handler:Nil];
}

- (void)moveToUbiquityContainer:(NSString *)containerIdentifier {
	NSURL *dstURL = [[self class] URLWithString:self.lastPathComponent ubiquityContainer:Nil];

	[self moveToCloud:dstURL];
}

- (void)moveToUbiquityContainer {
	[self moveToUbiquityContainer:Nil];
}

- (void)copyToUbiquityContainer:(NSString *)containerIdentifier {
	NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask].firstObject URLByAppendingPathComponent:self.lastPathComponent];
	url = [self copyItem:url.absoluteURL overwrite:YES];

	NSURL *dstURL = [[self class] URLWithString:self.lastPathComponent ubiquityContainer:Nil];
	__weak NSURL *__url = url;
	[url setUbiquitous:YES destinationURL:dstURL handler:^(BOOL success) {
		if ([__url isExistingItem])
			[__url removeItem];
	}];
}

- (void)copyToUbiquityContainer {
	[self copyToUbiquityContainer:Nil];
}

+ (instancetype)URLWithString:(NSString *)URLString ubiquityContainer:(NSString *)containerIdentifier {
	NSURL *url = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:containerIdentifier];
	url = [url URLByAppendingPathComponents:arr__(STR_DOCUMENTS, URLString)];
	return url;
}

@end
