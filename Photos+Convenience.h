//
//  Photos+Convenience.h
//  Poisk
//
//  Created by Alexander Ivanov on 12.06.17.
//  Copyright © 2017 Pine 9. All rights reserved.
//

#import <Photos/Photos.h>

@interface PHFetchOptions (Convenience)

+ (instancetype)fetchOptionsWithPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors;

@end

@interface PHFetchResult (Convenience)

@property (strong, nonatomic, readonly) NSArray<PHAsset *> *array;

@end

@interface PHPhotoLibrary (Convenience)

+ (NSNumber *)authorization;

@end
