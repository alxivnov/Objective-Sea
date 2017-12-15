//
//  Photos+Convenience.m
//  Poisk
//
//  Created by Alexander Ivanov on 12.06.17.
//  Copyright © 2017 Pine 9. All rights reserved.
//

#import "Photos+Convenience.h"

@implementation PHFetchOptions (Convenience)

+ (instancetype)fetchOptionsWithPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors {
	PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
	fetchOptions.predicate = predicate;
	fetchOptions.sortDescriptors = sortDescriptors;
	return fetchOptions;
}

@end

@implementation PHFetchResult (Convenience)

- (NSArray<PHAsset *> *)array {
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
	for (PHAsset *asset in self)
		[array addObject:asset];
	return array;
}

@end

@implementation PHImageRequestOptions (Convenience)

+ (instancetype)optionsWithNetworkAccessAllowed:(BOOL)networkAccessAllowed synchronous:(BOOL)synchronous progressHandler:(PHAssetImageProgressHandler)progressHandler {
	PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
	options.networkAccessAllowed = networkAccessAllowed;
	options.synchronous = synchronous;
	options.progressHandler = progressHandler;
	return options;
}

+ (instancetype)optionsWithNetworkAccessAllowed:(BOOL)networkAccessAllowed synchronous:(BOOL)synchronous {
	return [self optionsWithNetworkAccessAllowed:networkAccessAllowed synchronous:synchronous progressHandler:Nil];
}

+ (instancetype)optionsWithNetworkAccessAllowed:(BOOL)networkAccessAllowed {
	return [self optionsWithNetworkAccessAllowed:networkAccessAllowed synchronous:NO progressHandler:Nil];
}

@end

@implementation PHPhotoLibrary (Convenience)

+ (NSNumber *)authorization {
	PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
	return status == PHAuthorizationStatusAuthorized ? @YES : status == PHAuthorizationStatusDenied ? @NO : Nil;
}

@end

@implementation PHImageManager (Convenience)

- (UIImage *)requestImageForAsset:(PHAsset *)asset targetSize:(CGSize)targetSize contentMode:(PHImageContentMode)contentMode options:(PHImageRequestOptions *)options {
	__block UIImage *image = Nil;

	[GCD sync:^(GCD *sema) {
		[self requestImageForAsset:asset targetSize:targetSize contentMode:contentMode options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
			image = result;

			[sema signal];
		}];
	}];

	return image;
}

- (NSData *)requestImageDataForAsset:(PHAsset *)asset options:(PHImageRequestOptions *)options {
	__block NSData *data = Nil;

	[GCD sync:^(GCD *sema) {
		[self requestImageDataForAsset:asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
			data = imageData;

			[sema signal];
		}];
	}];

	return data;
}

@end
