//
//  CoreImage+Convenience.m
//  Poisk
//
//  Created by Alexander Ivanov on 13.06.17.
//  Copyright © 2017 Pine 9. All rights reserved.
//

#import "CoreImage+Convenience.h"

@implementation UIImage (CoreImage)

- (NSArray<CIFeature *> *)featuresOfType:(NSString *)type options:(NSDictionary<NSString *, id> *)options {
	return [[CIDetector detectorOfType:type context:Nil options:options] featuresInImage:self.CIImage ?: [CIImage imageWithCGImage:self.CGImage] options:options];
}

- (CGRect)boundsForFeature:(CIFeature *)feature {
	return CGRectMake(feature.bounds.origin.x / self.scale, self.size.height - (feature.bounds.origin.y + feature.bounds.size.height) / self.scale, feature.bounds.size.width / self.scale, feature.bounds.size.height / self.scale);
}

- (UIImage *)imageWithFeature:(CIFeature *)feature {
	CGRect rect = CGRectMake(feature.bounds.origin.x, self.size.height * self.scale - (feature.bounds.origin.y + feature.bounds.size.height), feature.bounds.size.width, feature.bounds.size.height);

	CGImageRef cgImage = CGImageCreateWithImageInRect(self.CGImage, rect);

	UIImage *image = [UIImage imageWithCGImage:cgImage scale:self.scale orientation:self.imageOrientation];

	CGImageRelease(cgImage);

	return image;
}

- (UIImage *)filterWithName:(NSString *)name parameters:(NSDictionary<NSString *, id> *)params createCGImage:(BOOL)flag {
	if (!name)
		return self;

	NSMutableDictionary *dic = params ? [params mutableCopy] : [NSMutableDictionary dictionaryWithCapacity:1];
	dic[kCIInputImageKey] = self.CIImage ?: [CIImage imageWithCGImage:self.CGImage];

	CIFilter *filter = [CIFilter filterWithName:name withInputParameters:dic];

	if (!flag)
		return [UIImage imageWithCIImage:filter.outputImage scale:self.scale orientation:self.imageOrientation];

	CGImageRef cgImage = [[CIContext contextWithOptions:Nil] createCGImage:filter.outputImage fromRect:filter.outputImage.extent];

	UIImage *image = [UIImage imageWithCGImage:cgImage scale:self.scale orientation:self.imageOrientation];

	CGImageRelease(cgImage);

	return image;
}

- (UIImage *)filterWithName:(NSString *)name parameters:(NSDictionary<NSString *, id> *)params {
	return [self filterWithName:name parameters:params createCGImage:NO];
}

- (UIImage *)filterWithName:(NSString *)name {
	return [self filterWithName:name parameters:Nil createCGImage:NO];
}

@end



#if __has_include(<Vision/Vision.h>)

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
	CGFloat x = observation.boundingBox.origin.x * self.size.width;
	CGFloat y = (1.0 - observation.boundingBox.origin.y) * self.size.height;
	CGFloat width = observation.boundingBox.size.width * self.size.width;
	CGFloat height = observation.boundingBox.size.height * self.size.height;
	return CGRectMake(x, y - height, width, height);
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

#endif
