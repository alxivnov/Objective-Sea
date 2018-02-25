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

@interface PHFetchResult (Convenience)

@property (strong, nonatomic, readonly) NSArray<PHAsset *> *array;

@end

@interface PHFetchOptions (Convenience)

+ (instancetype)fetchOptionsWithPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors;

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

+ (void)deleteAssets:(id<NSFastEnumeration>)assets completionHandler:(void(^)(BOOL success))completionHandler;

+ (void)insertAssets:(id<NSFastEnumeration>)assets atIndexes:(NSIndexSet *)indexes intoAssetCollection:(PHAssetCollection *)assetCollection completionHandler:(void(^)(BOOL success))completionHandler;

@end

@interface PHImageManager (Convenience)

- (UIImage *)requestImageForAsset:(PHAsset *)asset targetSize:(CGSize)targetSize contentMode:(PHImageContentMode)contentMode options:(PHImageRequestOptions *)options;
- (NSData *)requestImageDataForAsset:(PHAsset *)asset options:(PHImageRequestOptions *)options;

@end

@interface UICollectionView (Photos)

- (void)performFetchResultChanges:(PHFetchResultChangeDetails *)changes inSection:(NSUInteger)section;

@end
