//
//  FIRVision+Convenience.h
//  Scans
//
//  Created by Alexander Ivanov on 24.05.2018.
//  Copyright © 2018 Alexander Ivanov. All rights reserved.
//

#import <MLKitVision/MLKitVision.h>
#import <MLKitTextRecognition/MLKitTextRecognition.h>

#import "Dispatch+Convenience.h"
#import "NSObject+Convenience.h"
/*
@interface FIRVisionLabelDetector (Convenience)

+ (instancetype)labelDetector;

- (NSArray<FIRVisionLabel *> *)detectInImage:(UIImage *)image;

@end
*/
@interface MLKTextRecognizer (Convenience)

- (MLKText *)processImage:(UIImage *)image;

@end
