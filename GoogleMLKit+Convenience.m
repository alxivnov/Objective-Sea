//
//  FIRVision+Convenience.m
//  Scans
//
//  Created by Alexander Ivanov on 24.05.2018.
//  Copyright © 2018 Alexander Ivanov. All rights reserved.
//

#import "GoogleMLKit+Convenience.h"
/*
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
*/
@implementation MLKTextRecognizer (Convenience)

- (MLKText *)processImage:(UIImage *)image {
	if (image == Nil)
		return Nil;

	__block MLKText *result = Nil;

	MLKVisionImage *firImage = [[MLKVisionImage alloc] initWithImage:image];
	[GCD sync:^(GCD *sema) {
		[self processImage:firImage completion:^(MLKText * _Nullable text, NSError * _Nullable error) {
			result = text;

			[error log:@"MLKTextRecognizer detectInImage:"];

			[sema signal];
		}];
	}];

	return result;
}

@end
