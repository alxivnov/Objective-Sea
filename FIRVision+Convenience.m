//
//  FIRVision+Convenience.m
//  Scans
//
//  Created by Alexander Ivanov on 24.05.2018.
//  Copyright © 2018 Alexander Ivanov. All rights reserved.
//

#import "FIRVision+Convenience.h"

@implementation FIRVisionLabelDetector (Convenience)

__static(FIRVisionLabelDetector *, labelDetector, [FIRVision vision].labelDetector)

- (NSArray<FIRVisionLabel *> *)detectInImage:(UIImage *)image {
	if (image == Nil)
		return Nil;

	__block NSArray *result = Nil;

	FIRVisionImage *firImage = [[FIRVisionImage alloc] initWithImage:image];
	[GCD sync:^(GCD *sema) {
		[self detectInImage:firImage completion:^(NSArray<FIRVisionLabel *> * _Nullable labels, NSError * _Nullable error) {
			result = labels;

			[error log:@"FIRVisionLabelDetector detectInImage:"];

			[sema signal];
		}];
	}];

	return result;
}

@end

@implementation FIRVisionTextDetector (Convenience)

__static(FIRVisionTextDetector *, textDetector, [FIRVision vision].textDetector)

- (NSArray<id<FIRVisionText>> *)detectInImage:(UIImage *)image {
	if (image == Nil)
		return Nil;

	__block NSArray *result = Nil;

	FIRVisionImage *firImage = [[FIRVisionImage alloc] initWithImage:image];
	[GCD sync:^(GCD *sema) {
		[self detectInImage:firImage completion:^(NSArray<id<FIRVisionText>> * _Nullable texts, NSError * _Nullable error) {
			result = texts;

			[error log:@"FIRVisionLabelDetector detectInImage:"];

			[sema signal];
		}];
	}];

	return result;
}

@end
