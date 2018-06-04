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

CGImagePropertyOrientation CGImagePropertyOrientationForUIImageOrientation(UIImageOrientation uiOrientation) {
	switch (uiOrientation) {
		case UIImageOrientationUp: return kCGImagePropertyOrientationUp;
		case UIImageOrientationDown: return kCGImagePropertyOrientationDown;
		case UIImageOrientationLeft: return kCGImagePropertyOrientationLeft;
		case UIImageOrientationRight: return kCGImagePropertyOrientationRight;
		case UIImageOrientationUpMirrored: return kCGImagePropertyOrientationUpMirrored;
		case UIImageOrientationDownMirrored: return kCGImagePropertyOrientationDownMirrored;
		case UIImageOrientationLeftMirrored: return kCGImagePropertyOrientationLeftMirrored;
		case UIImageOrientationRightMirrored: return kCGImagePropertyOrientationRightMirrored;
	}

	return kCGImagePropertyOrientationUp;
}

+ (UIImage *)imageWithFilter:(NSString *)name parameters:(NSDictionary<NSString *, id> *)params scale:(CGFloat)scale orientation:(UIImageOrientation)orientation {
	if (!name)
		return Nil;

	CIFilter *filter = [CIFilter filterWithName:name withInputParameters:params];

	return [UIImage imageWithCIImage:filter.outputImage scale:scale orientation:orientation];
}

+ (UIImage *)imageWithFilter:(NSString *)name parameters:(NSDictionary<NSString *, id> *)params scale:(CGFloat)scale {
	return [self imageWithFilter:name parameters:params scale:scale orientation:UIImageOrientationUp];
}

+ (UIImage *)imageWithFilter:(NSString *)name parameters:(NSDictionary<NSString *, id> *)params {
	return [self imageWithFilter:name parameters:params scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
}

- (UIImage *)filterWithName:(NSString *)name parameters:(NSDictionary<NSString *, id> *)params createCGImage:(BOOL)flag {
	if (!name)
		return self;

	NSMutableDictionary *dic = params ? [params mutableCopy] : [NSMutableDictionary dictionaryWithCapacity:1];
	CIImage *inputImage = self.CIImage;
	if (!inputImage) {
		inputImage = [CIImage imageWithCGImage:self.CGImage];
		if (@available(iOS 11.0, *))
			inputImage = [inputImage imageByApplyingCGOrientation:CGImagePropertyOrientationForUIImageOrientation(self.imageOrientation)];
	}
	dic[kCIInputImageKey] = inputImage;

	CIFilter *filter = [CIFilter filterWithName:name withInputParameters:dic];

	if (!flag)
		return [UIImage imageWithCIImage:filter.outputImage scale:self.scale orientation:self.imageOrientation];

	CGImageRef cgImage = [[CIContext contextWithOptions:Nil] createCGImage:filter.outputImage fromRect:filter.outputImage.extent];

	UIImage *image = [UIImage imageWithCGImage:cgImage scale:self.scale orientation:self.CIImage ? self.imageOrientation : UIImageOrientationUp];

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

@implementation NSData (CoreImage)

- (UIImage *)qrCode:(NSString *)inputCorrectionLevel {
	return [UIImage imageWithFilter:@"CIQRCodeGenerator" parameters:@{ @"inputMessage" : self, @"inputCorrectionLevel" : inputCorrectionLevel ?: @"L" }];
}

@end
