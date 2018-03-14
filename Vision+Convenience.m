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

@implementation VNImageRequestHandler (Convenience)

- (BOOL)performRequests:(NSArray<VNRequest *> *)requests {
	NSError *error = Nil;
	BOOL success = [self performRequests:requests error:&error];
	[error log:@"VNRequest performRequests:"];
	return success;
}

@end

@implementation VNRequest (Convenience)

+ (instancetype)requestWithCompletionHandler:(void(^)(NSArray *results))completionHandler {
	return [[self alloc] initWithCompletionHandler:^(VNRequest * _Nonnull request, NSError * _Nullable error) {
		if (completionHandler)
			completionHandler(request.results.count ? request.results : Nil);

		[error log:@"VNRequest initWithCompletionHandler:"];
	}];
}

@end

@implementation UIImage (Vision)

- (BOOL)detectTextRectanglesWithOptions:(NSDictionary<VNImageOption, id> *)options completionHandler:(void(^)(NSArray<VNTextObservation *> *results))completionHandler {
	VNImageRequestHandler *handler = [[VNImageRequestHandler alloc] initWithCGImage:self.CGImage options:options];
	VNDetectTextRectanglesRequest *request = [VNDetectTextRectanglesRequest requestWithCompletionHandler:completionHandler];
	if (options[VNImageOptionReportCharacterBoxes])
		request.reportCharacterBoxes = [options[VNImageOptionReportCharacterBoxes] boolValue];
	return [handler performRequests:@[ request ]];
}

- (BOOL)detectRectanglesWithOptions:(NSDictionary<VNImageOption, id> *)options completionHandler:(void(^)(NSArray<VNRectangleObservation *> *results))completionHandler {
	VNImageRequestHandler *handler = [[VNImageRequestHandler alloc] initWithCGImage:self.CGImage options:options];
	VNDetectRectanglesRequest *request = [VNDetectRectanglesRequest requestWithCompletionHandler:completionHandler];
	return [handler performRequests:@[ request ]];
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
