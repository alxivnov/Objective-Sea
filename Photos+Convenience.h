//
//  Photos+Convenience.h
//  Poisk
//
//  Created by Alexander Ivanov on 12.06.17.
//  Copyright © 2017 Pine 9. All rights reserved.
//

#import <Photos/Photos.h>

#import "Dispatch+Convenience.h"

@interface PHFetchOptions (Convenience)

+ (instancetype)fetchOptionsWithPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors;

@end

@interface PHFetchResult (Convenience)

@property (strong, nonatomic, readonly) NSArray<PHAsset *> *array;

@end

@interface PHImageRequestOptions (Convenience)

+ (instancetype)optionsWithNetworkAccessAllowed:(BOOL)networkAccessAllowed synchronous:(BOOL)synchronous progressHandler:(PHAssetImageProgressHandler)progressHandler;
+ (instancetype)optionsWithNetworkAccessAllowed:(BOOL)networkAccessAllowed synchronous:(BOOL)synchronous;
+ (instancetype)optionsWithNetworkAccessAllowed:(BOOL)networkAccessAllowed;

@end

@interface PHPhotoLibrary (Convenience)

+ (NSNumber *)authorization;

@end

@interface PHImageManager (Convenience)

- (UIImage *)requestImageForAsset:(PHAsset *)asset targetSize:(CGSize)targetSize contentMode:(PHImageContentMode)contentMode options:(PHImageRequestOptions *)options;
- (NSData *)requestImageDataForAsset:(PHAsset *)asset options:(PHImageRequestOptions *)options;

@end
