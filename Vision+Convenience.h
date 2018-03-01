//
//  Vision+Convenience.h
//  Scans
//
//  Created by Alexander Ivanov on 26.02.2018.
//  Copyright © 2018 Alexander Ivanov. All rights reserved.
//

#import <Vision/Vision.h>
#import <UIKit/UIKit.h>

#import "NSObject+Convenience.h"

@interface VNDetectedObjectObservation (Convenience)

@property (assign, nonatomic, readonly) CGRect bounds;

@end

#define VNImageOptionReportCharacterBoxes @"VNImageOptionReportCharacterBoxes"

@interface UIImage (Vision)

- (VNImageRequestHandler *)detectTextRectanglesWithOptions:(NSDictionary<VNImageOption, id> *)options handler:(void(^)(NSArray<VNTextObservation *> *results))handler;

- (CGRect)boundsForObservation:(VNDetectedObjectObservation *)observation;

- (UIImage *)imageWithObservation:(VNDetectedObjectObservation *)observation;

@end
