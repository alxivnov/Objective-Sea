//
//  MobileCoreServices+Convenience.m
//  Offcloud
//
//  Created by Alexander Ivanov on 23.02.17.
//  Copyright © 2017 Alexander Ivanov. All rights reserved.
//

#import "MobileCoreServices+Convenience.h"

@implementation UTType

+ (NSString *)preferredTagWithClass:(CFStringRef)outTagClass fromTag:(NSString *)inTag withClass:(CFStringRef)inTagClass {
	CFStringRef uti = UTTypeCreatePreferredIdentifierForTag(inTagClass, (__bridge CFStringRef)inTag, NULL);

	CFStringRef outTag = UTTypeCopyPreferredTagWithClass(uti, outTagClass);

	CFRelease(uti);

	return (NSString *)CFBridgingRelease(outTag);
}

+ (NSArray *)allTagsWithClass:(CFStringRef)outTagClass fromTag:(NSString *)inTag withClass:(CFStringRef)inTagClass {
	CFStringRef uti = UTTypeCreatePreferredIdentifierForTag(inTagClass, (__bridge CFStringRef)inTag, NULL);

	CFArrayRef outTag = UTTypeCopyAllTagsWithClass(uti, outTagClass);

	CFRelease(uti);

	return (NSArray *)CFBridgingRelease(outTag);
}

+ (NSString *)mimeTypeFromFilenameExtension:(NSString *)filenameExtension {
	return [self preferredTagWithClass:kUTTagClassMIMEType fromTag:filenameExtension withClass:kUTTagClassFilenameExtension];
}

+ (NSArray<NSString *> *)filenameExtensionsFromMimeType:(NSString *)mimeType {
	return [self allTagsWithClass:kUTTagClassFilenameExtension fromTag:mimeType withClass:kUTTagClassMIMEType];
}

@end
