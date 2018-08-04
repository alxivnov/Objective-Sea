//
//  FIRVision+Convenience.h
//  Scans
//
//  Created by Alexander Ivanov on 24.05.2018.
//  Copyright © 2018 Alexander Ivanov. All rights reserved.
//

#import <FirebaseMLVision/FirebaseMLVision.h>

#import "Dispatch+Convenience.h"
#import "NSObject+Convenience.h"

@interface FIRVisionLabelDetector (Convenience)

+ (instancetype)labelDetector;

- (NSArray<FIRVisionLabel *> *)detectInImage:(UIImage *)image;

@end

@interface FIRVisionTextRecognizer (Convenience)

+ (instancetype)onDeviceTextRecognizer;
+ (instancetype)cloudTextRecognizer;

- (FIRVisionText *)processImage:(UIImage *)image;

@end
