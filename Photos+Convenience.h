//
//  Photos+Convenience.h
//  Poisk
//
//  Created by Alexander Ivanov on 12.06.17.
//  Copyright © 2017 Pine 9. All rights reserved.
//

#import <Photos/Photos.h>

#import "Dispatch+Convenience.h"
#import "NSObject+Convenience.h"

#define PHPhotoLibraryNotDetermined(status) (status == NSNotFound ? [PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined : status == PHAuthorizationStatusNotDetermined)
#define PHPhotoLibraryAuthorized(status) (status == NSNotFound ? [PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized : status == PHAuthorizationStatusAuthorized)
#define PHPhotoLibraryRestricted(status) (status == NSNotFound ? [PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusRestricted : status == PHAuthorizationStatusRestricted)
#define PHPhotoLibraryDenied(status) (status == NSNotFound ? [PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusDenied : status == PHAuthorizationStatusDenied)

#if __has_include("UIApplication+Convenience.h")
#import "UIApplication+Convenience.h"
#endif

@interface PHFetchResult (Convenience)

@property (strong, nonatomic, readonly) NSArray<PHAsset *> *array;

@end

@interface PHFetchOptions (Convenience)

+ (instancetype)fetchOptionsWithPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors;

@end

@interface PHAsset (Convenience)

+ (PHFetchResult<PHAsset *> *)fetchAssetsWithLocalIdentifier:(NSString *)identifier options:(PHFetchOptions *)options;

@end

@interface PHAssetCollection (Convenience)

+ (PHAssetCollection *)fetchAssetCollectionWithLocalIdentifier:(NSString *)identifier options:(PHFetchOptions *)options;
+ (PHAssetCollection *)fetchAssetCollectionsWithALAssetGroupURL:(NSURL *)assetGroupURL options:(PHFetchOptions *)options;

@end

@interface PHAssetCollectionChangeRequest (Convenience)

- (void)insertAssets:(NSArray *)assets;

@end

@interface PHPhotoLibrary (Convenience)

+ (NSNumber *)authorization;

#if __has_include("UIApplication+Convenience.h")
+ (void)requestAuthorizationIfNeeded:(void (^)(PHAuthorizationStatus status))handler;
#endif

+ (void)createAssetWithImage:(UIImage *)image completionHandler:(void(^)(NSString *localIdentifier))completionHandler;

+ (void)toggleFavoriteOnAsset:(PHAsset *)asset completionHandler:(void(^)(BOOL success))completionHandler;

+ (void)deleteAssets:(id<NSFastEnumeration>)assets completionHandler:(void(^)(BOOL success))completionHandler;

+ (void)createAssetCollectionWithTitle:(NSString *)title completionHandler:(void(^)(NSString *localIdentifier))completionHandler;

+ (void)insertAssets:(id<NSFastEnumeration>)assets atIndexes:(NSIndexSet *)indexes intoAssetCollection:(PHAssetCollection *)assetCollection completionHandler:(void(^)(BOOL success))completionHandler;

+ (void)removeAssets:(NSArray *)assets fromAssetCollection:(PHAssetCollection *)assetCollection completionHandler:(void(^)(BOOL success))completionHandler;

@end

@interface PHImageManager (Convenience)

- (UIImage *)requestImageForAsset:(PHAsset *)asset targetSize:(CGSize)targetSize contentMode:(PHImageContentMode)contentMode options:(PHImageRequestOptions *)options;
- (NSData *)requestImageDataForAsset:(PHAsset *)asset options:(PHImageRequestOptions *)options;

@end

@interface UICollectionView (Photos)

- (void)performFetchResultChanges:(PHFetchResultChangeDetails *)changes inSection:(NSUInteger)section;

@end
