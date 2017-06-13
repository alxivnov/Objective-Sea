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

@implementation PHPhotoLibrary (Convenience)

+ (NSNumber *)authorization {
	PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
	return status == PHAuthorizationStatusAuthorized ? @YES : status == PHAuthorizationStatusDenied ? @NO : Nil;
}

@end
