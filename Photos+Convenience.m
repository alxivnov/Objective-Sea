//
//  Photos+Convenience.m
//  Poisk
//
//  Created by Alexander Ivanov on 12.06.17.
//  Copyright © 2017 Pine 9. All rights reserved.
//

#import "Photos+Convenience.h"

@implementation PHFetchResult (Convenience)

- (NSArray<PHAsset *> *)array {
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
	for (PHAsset *asset in self)
		[array addObject:asset];
	return array;
}

@end

@implementation PHFetchOptions (Convenience)

+ (instancetype)fetchOptionsWithPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors {
	PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
	fetchOptions.predicate = predicate;
	fetchOptions.sortDescriptors = sortDescriptors;
	return fetchOptions;
}

@end

@implementation PHAsset (Convenience)

+ (PHFetchResult<PHAsset *> *)fetchAssetsWithLocalIdentifier:(NSString *)identifier options:(PHFetchOptions *)options {
	return identifier ? [self fetchAssetsWithLocalIdentifiers:@[ identifier ] options:options] : Nil;
}

@end

@implementation PHAssetCollection (Convenience)

+ (PHAssetCollection *)fetchAssetCollectionWithLocalIdentifier:(NSString *)identifier options:(PHFetchOptions *)options {
	return identifier ? [self fetchAssetCollectionsWithLocalIdentifiers:@[ identifier ] options:options].firstObject : Nil;
}

+ (PHAssetCollection *)fetchAssetCollectionsWithALAssetGroupURL:(NSURL *)assetGroupURL options:(PHFetchOptions *)options {
	return assetGroupURL ? [self fetchAssetCollectionsWithALAssetGroupURLs:@[ assetGroupURL ] options:options].firstObject : Nil;
}

@end

@implementation PHAssetCollectionChangeRequest (Convenience)

- (void)insertAssets:(NSArray *)assets {
	if (assets.count)
		[self insertAssets:assets atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, assets.count)]];
}

@end

@implementation PHPhotoLibrary (Convenience)

+ (NSNumber *)authorization {
	PHAuthorizationStatus status = [self authorizationStatus];
	return status == PHAuthorizationStatusAuthorized ? @YES : status == PHAuthorizationStatusDenied ? @NO : Nil;
}

#if __has_include("UIApplication+Convenience.h")

+ (void)requestAuthorizationIfNeeded:(void (^)(PHAuthorizationStatus))handler {
	PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];

	if (status == PHAuthorizationStatusAuthorized) {
		if (handler)
			handler(status);
	} else if (status == PHAuthorizationStatusDenied) {
		[UIApplication openSettings];

		if (handler)
			handler(status);
	} else {
		[PHPhotoLibrary requestAuthorization:handler];
	}
}

#endif

+ (void)createAssetWithImage:(UIImage *)image completionHandler:(void(^)(NSString *localIdentifier))completionHandler {
	__block NSString *localIdentifier = Nil;

	[[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
		localIdentifier = [PHAssetChangeRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset.localIdentifier;
	} completionHandler:^(BOOL success, NSError * _Nullable error) {
		if (completionHandler)
			completionHandler(success ? localIdentifier : Nil);

		[error log:@"creationRequestForAssetFromImage:"];
	}];
}

+ (void)toggleFavoriteOnAsset:(PHAsset *)asset completionHandler:(void(^)(BOOL success))completionHandler {
	[[self sharedPhotoLibrary] performChanges:^{
		[PHAssetChangeRequest changeRequestForAsset:asset].favorite = !asset.isFavorite;
	} completionHandler:^(BOOL success, NSError *error) {
		if (completionHandler)
			completionHandler(success);

		[error log:@"toggleFavoriteOnAsset:"];
	}];
}

+ (void)deleteAssets:(id<NSFastEnumeration>)assets completionHandler:(void(^)(BOOL success))completionHandler {
	[[self sharedPhotoLibrary] performChanges:^{
		[PHAssetChangeRequest deleteAssets:assets];
	} completionHandler:^(BOOL success, NSError *error) {
		if (completionHandler)
			completionHandler(success);

		[error log:@"deleteAssets:"];
	}];
}

+ (void)createAssetCollectionWithTitle:(NSString *)title completionHandler:(void(^)(NSString *localIdentifier))completionHandler {
	__block NSString *localIdentifier = Nil;

	[[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
		localIdentifier = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title].placeholderForCreatedAssetCollection.localIdentifier;
	} completionHandler:^(BOOL success, NSError * _Nullable error) {
		if (completionHandler)
			completionHandler(success ? localIdentifier : Nil);

		[error log:@"creationRequestForAssetCollectionWithTitle:"];
	}];
}

+ (void)insertAssets:(id<NSFastEnumeration>)assets atIndexes:(NSIndexSet *)indexes intoAssetCollection:(PHAssetCollection *)assetCollection completionHandler:(void(^)(BOOL success))completionHandler {
	[[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
		if (indexes)
			[[PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection]  insertAssets:assets atIndexes:indexes];
		else
			[[PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection]  addAssets:assets];
	} completionHandler:^(BOOL success, NSError * _Nullable error) {
		if (completionHandler)
			completionHandler(success);
		
		[error log:@"insertAssets:"];
	}];
}

+ (void)removeAssets:(NSArray *)assets fromAssetCollection:(PHAssetCollection *)assetCollection completionHandler:(void(^)(BOOL success))completionHandler {
	[[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
		[[PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection] removeAssets:assets];
	} completionHandler:^(BOOL success, NSError * _Nullable error) {
		if (completionHandler)
			completionHandler(success);

		[error log:@"removeAssets:"];
	}];
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

@implementation NSIndexSet (UICollectionView)

- (NSArray<NSIndexPath *> *)indexPathsInSection:(NSUInteger)section {
	NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:self.count];
	[self enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
		[indexPaths addObject:[NSIndexPath indexPathForItem:idx inSection:section]];
	}];
	return indexPaths;
}

@end

@implementation UICollectionView (Photos)

- (void)performFetchResultChanges:(PHFetchResultChangeDetails *)changes inSection:(NSUInteger)section {
	if (!changes)
		return;

	if (changes.hasIncrementalChanges)
		[self performBatchUpdates:^{
			NSArray *removedIndexes = [changes.removedIndexes indexPathsInSection:section];
//			[removedIndexes log:@"removedIndexes:"];
			if (removedIndexes.count)
				[self deleteItemsAtIndexPaths:removedIndexes];

			NSArray *insertedIndexes = [changes.insertedIndexes indexPathsInSection:section];
//			[insertedIndexes log:@"insertedIndexes:"];
			if (insertedIndexes.count)
				[self insertItemsAtIndexPaths:insertedIndexes];

			NSArray *changedIndexes = [changes.changedIndexes indexPathsInSection:section];
//			[changedIndexes log:@"changedIndexes:"];
			if (changedIndexes.count)
				[self reloadItemsAtIndexPaths:changedIndexes];

			if (changes.hasMoves)
				[changes enumerateMovesWithBlock:^(NSUInteger fromIndex, NSUInteger toIndex) {
					[self moveItemAtIndexPath:[NSIndexPath indexPathForItem:fromIndex inSection:section] toIndexPath:[NSIndexPath indexPathForItem:toIndex inSection:section]];
				}];
		} completion:Nil];
	else
		[self reloadData];
}

@end
