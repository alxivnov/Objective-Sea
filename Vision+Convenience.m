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
	if (!requests.count)
		return NO;

	NSError *error = Nil;
	BOOL success = [self performRequests:requests error:&error];
	[error log:@"VNRequest performRequests:"];

	return success;
}

@end

@implementation VNSequenceRequestHandler (Convenience)

- (BOOL)performRequests:(NSArray<VNRequest *> *)requests onCVPixelBuffer:(CVPixelBufferRef)pixelBuffer {
	if (!requests.count)
		return NO;

	NSError *error = Nil;
	BOOL success = [self performRequests:requests onCVPixelBuffer:pixelBuffer error:&error];
	[error log:@"VNSequenceRequestHandler performRequests:"];

	return success;
}

- (BOOL)performRequests:(NSArray<VNRequest *> *)requests onCVPixelBuffer:(CVPixelBufferRef)pixelBuffer orientation:(CGImagePropertyOrientation)orientation {
	if (!requests.count)
		return NO;

	NSError *error = Nil;
	BOOL success = [self performRequests:requests onCVPixelBuffer:pixelBuffer orientation:orientation error:&error];
	[error log:@"VNSequenceRequestHandler performRequests:"];

	return success;
}


- (BOOL)performRequests:(NSArray<VNRequest *> *)requests onCGImage:(CGImageRef)image {
	if (!requests.count)
		return NO;

	NSError *error = Nil;
	BOOL success = [self performRequests:requests onCGImage:image error:&error];
	[error log:@"VNSequenceRequestHandler performRequests:"];

	return success;
}

- (BOOL)performRequests:(NSArray<VNRequest *> *)requests onCGImage:(CGImageRef)image orientation:(CGImagePropertyOrientation)orientation {
	if (!requests.count)
		return NO;

	NSError *error = Nil;
	BOOL success = [self performRequests:requests onCGImage:image orientation:orientation error:&error];
	[error log:@"VNSequenceRequestHandler performRequests:"];

	return success;
}


- (BOOL)performRequests:(NSArray<VNRequest *> *)requests onCIImage:(CIImage*)image {
	if (!requests.count)
		return NO;

	NSError *error = Nil;
	BOOL success = [self performRequests:requests onCIImage:image error:&error];
	[error log:@"VNSequenceRequestHandler performRequests:"];

	return success;
}

- (BOOL)performRequests:(NSArray<VNRequest *> *)requests onCIImage:(CIImage*)image orientation:(CGImagePropertyOrientation)orientation {
	if (!requests.count)
		return NO;

	NSError *error = Nil;
	BOOL success = [self performRequests:requests onCIImage:image orientation:orientation error:&error];
	[error log:@"VNSequenceRequestHandler performRequests:"];

	return success;
}


- (BOOL)performRequests:(NSArray<VNRequest *> *)requests onImageURL:(NSURL*)imageURL {
	if (!requests.count)
		return NO;

	NSError *error = Nil;
	BOOL success = [self performRequests:requests onImageURL:imageURL error:&error];
	[error log:@"VNSequenceRequestHandler performRequests:"];

	return success;
}

- (BOOL)performRequests:(NSArray<VNRequest *> *)requests onImageURL:(NSURL*)imageURL orientation:(CGImagePropertyOrientation)orientation {
	if (!requests.count)
		return NO;

	NSError *error = Nil;
	BOOL success = [self performRequests:requests onImageURL:imageURL orientation:orientation error:&error];
	[error log:@"VNSequenceRequestHandler performRequests:"];

	return success;
}


- (BOOL)performRequests:(NSArray<VNRequest *> *)requests onImageData:(NSData*)imageData {
	if (!requests.count)
		return NO;

	NSError *error = Nil;
	BOOL success = [self performRequests:requests onImageData:imageData error:&error];
	[error log:@"VNSequenceRequestHandler performRequests:"];

	return success;
}

- (BOOL)performRequests:(NSArray<VNRequest *> *)requests onImageData:(NSData*)imageData orientation:(CGImagePropertyOrientation)orientation {
	if (!requests.count)
		return NO;

	NSError *error = Nil;
	BOOL success = [self performRequests:requests onImageData:imageData orientation:orientation error:&error];
	[error log:@"VNSequenceRequestHandler performRequests:"];

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

- (CGImagePropertyOrientation)orientation {
	switch (self.imageOrientation) {
		case UIImageOrientationUp:
			return kCGImagePropertyOrientationUp;
		case UIImageOrientationDown:
			return kCGImagePropertyOrientationDown;
		case UIImageOrientationLeft:
			return kCGImagePropertyOrientationLeft;
		case UIImageOrientationRight:
			return kCGImagePropertyOrientationRight;
		case UIImageOrientationUpMirrored:
			return kCGImagePropertyOrientationUpMirrored;
		case UIImageOrientationDownMirrored:
			return kCGImagePropertyOrientationDownMirrored;
		case UIImageOrientationLeftMirrored:
			return kCGImagePropertyOrientationLeftMirrored;
		case UIImageOrientationRightMirrored:
			return kCGImagePropertyOrientationRightMirrored;
		default:
			return kCGImagePropertyOrientationUp;
	}
}

- (BOOL)detectTextRectanglesWithOptions:(NSDictionary<VNImageOption, id> *)options completionHandler:(void(^)(NSArray<VNTextObservation *> *results))completionHandler {
	VNImageRequestHandler *handler = [[VNImageRequestHandler alloc] initWithCGImage:self.CGImage orientation:[self orientation] options:options];
	VNDetectTextRectanglesRequest *request = [VNDetectTextRectanglesRequest requestWithCompletionHandler:completionHandler];
	if (options[VNImageOptionReportCharacterBoxes])
		request.reportCharacterBoxes = [options[VNImageOptionReportCharacterBoxes] boolValue];
	return [handler performRequests:@[ request ]];
}

- (BOOL)detectRectanglesWithOptions:(NSDictionary<VNImageOption, id> *)options completionHandler:(void(^)(NSArray<VNRectangleObservation *> *results))completionHandler {
	VNImageRequestHandler *handler = [[VNImageRequestHandler alloc] initWithCGImage:self.CGImage orientation:[self orientation] options:options];
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
