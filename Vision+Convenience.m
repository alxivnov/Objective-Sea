//
//  Vision+Convenience.m
//  Scans
//
//  Created by Alexander Ivanov on 26.02.2018.
//  Copyright © 2018 Alexander Ivanov. All rights reserved.
//

#import "Vision+Convenience.h"

@implementation VNDetectedObjectObservation (Convenience)

- (CGRect)bounds {
	CGFloat x = self.boundingBox.origin.x;
	CGFloat y = (1.0 - self.boundingBox.origin.y);
	CGFloat width = self.boundingBox.size.width;
	CGFloat height = self.boundingBox.size.height;
	return CGRectMake(x, y - height, width, height);
}

@end

@implementation UIImage (Vision)

- (VNImageRequestHandler *)detectTextRectanglesWithOptions:(NSDictionary<VNImageOption, id> *)options handler:(void(^)(NSArray<VNTextObservation *> *results))handler {
	VNImageRequestHandler *h = [[VNImageRequestHandler alloc] initWithCGImage:self.CGImage options:options];
	VNDetectTextRectanglesRequest *r = [[VNDetectTextRectanglesRequest alloc] initWithCompletionHandler:^(VNRequest * _Nonnull request, NSError * _Nullable error) {
		if (handler)
			handler(request.results.count ? request.results : Nil);

		[error log:@"VNDetectTextRectanglesRequest initWithCompletionHandler:"];
	}];
	if (options[VNImageOptionReportCharacterBoxes])
		r.reportCharacterBoxes = [options[VNImageOptionReportCharacterBoxes] boolValue];

	NSError *error = Nil;
	BOOL success = [h performRequests:@[ r ] error:&error];
	[error log:@"VNDetectTextRectanglesRequest performRequests:"];

	return success ? h : Nil;
}

- (CGRect)boundsForObservation:(VNDetectedObjectObservation *)observation {
	CGRect rect = observation.bounds;
	rect.origin.x *= self.size.width;
	rect.origin.y *= self.size.height;
	rect.size.width *= self.size.width;
	rect.size.height *= self.size.height;
	return rect;
}

- (UIImage *)imageWithObservation:(VNDetectedObjectObservation *)observation {
	CGRect rect = [self boundsForObservation:observation];
	rect.origin.x *= self.scale;
	rect.origin.y *= self.scale;
	rect.size.width *= self.scale;
	rect.size.height *= self.scale;

	CGImageRef cgImage = CGImageCreateWithImageInRect(self.CGImage, rect);

	UIImage *image = [UIImage imageWithCGImage:cgImage scale:self.scale orientation:self.imageOrientation];

	CGImageRelease(cgImage);

	return image;
}

@end
