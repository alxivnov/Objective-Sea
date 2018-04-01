//
//  UIDocumentPickerViewController+Convenience.m
//  Ringtonic
//
//  Created by Alexander Ivanov on 14.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "UIDocumentPickerViewController+Convenience.h"

@interface UIDocumentExportActivity ()
@property (strong, nonatomic) NSURL *URL;
@end

@implementation UIDocumentExportActivity

+ (UIActivityCategory)activityCategory {
	return UIActivityCategoryAction;
}

- (NSString *)activityType {
	return UIDocumentExportActivityType;
}

- (NSString *)activityTitle {
	return UIDocumentExportActivityTitle;
}

- (UIImage *)activityImage {
	return [UIImage imageNamed:[UIDocumentExportActivityImage stringByAppendingString:[UIApplication sharedApplication].iPad ? @"-76" : @"-60"]];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
	return self.URL.isExistingFile || [activityItems any:^BOOL(id item) {
		return cls(NSURL, item).isExistingFile;
	}];
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
	if (!self.URL.isExistingFile)
		self.URL = [activityItems firstObject:^BOOL(id item) {
			return cls(NSURL, item).isExistingFile;
		}];
}

- (UIViewController *)activityViewController {
	return [UIDocumentPicker pickerForExport:self.URL completion:^(NSURL *url) {
		[self activityDidFinish:url ? YES : NO];
	}];
}

+ (UIDocumentExportActivity *)activityWithURL:(NSURL *)url {
	UIDocumentExportActivity *activity = [self new];
	activity.URL = url;
	return activity;
}

@end

@interface UIDocumentPicker ()
@property (copy, nonatomic) void(^completion)(NSURL *url);
@end

@implementation UIDocumentPicker

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray <NSURL *>*)urls {
	if (self.completion)
		self.completion(urls.firstObject);
}

- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller {
	if (self.completion)
		self.completion(Nil);
}

+ (instancetype)pickerWithMode:(UIDocumentPickerMode)mode argument:(id)argument completion:(void(^)(NSURL *url))completion {
	UIDocumentPicker *instance = mode == UIDocumentPickerModeExportToService || mode == UIDocumentPickerModeMoveToService
		? [[self alloc] initWithURL:argument inMode:mode]
		: [[self alloc] initWithDocumentTypes:argument inMode:mode];
	instance.delegate = instance;
	instance.completion = completion;
	return instance;
}

+ (instancetype)pickerForExport:(NSURL *)url completion:(void(^)(NSURL *url))completion {
	return url ? [self pickerWithMode:UIDocumentPickerModeExportToService argument:url completion:completion] : Nil;
}

+ (instancetype)pickerForMove:(NSURL *)url completion:(void(^)(NSURL *url))completion {
	return url ? [self pickerWithMode:UIDocumentPickerModeMoveToService argument:url completion:completion] : Nil;
}

+ (instancetype)pickerForImport:(NSArray *)UTIs completion:(void(^)(NSURL *url))completion {
	return [self pickerWithMode:UIDocumentPickerModeImport argument:UTIs ? UTIs : @[ (NSString *)kUTTypeData ] completion:completion];
}

+ (instancetype)pickerForOpen:(NSArray *)UTIs completion:(void(^)(NSURL *url))completion {
	return [self pickerWithMode:UIDocumentPickerModeOpen argument:UTIs ? UTIs : @[ (NSString *)kUTTypeData ] completion:completion];
}

@end

@implementation UIViewController (UIDocumentPickerViewController)

- (UIDocumentPickerViewController *)presentDocumentExport:(void (^)(NSURL *url))completion URL:(NSURL *)url fromView:(UIView *)view {
	UIDocumentPicker *picker = [UIDocumentPicker pickerForExport:url completion:completion];

	return [self popoverViewController:picker from:view] ? picker : Nil;
}

- (UIDocumentPickerViewController *)presentDocumentExport:(void (^)(NSURL *url))completion URL:(NSURL *)url fromButton:(UIBarButtonItem *)button {
	UIDocumentPicker *picker = [UIDocumentPicker pickerForExport:url completion:completion];

	return [self popoverViewController:picker from:button] ? picker : Nil;
}

- (UIDocumentPickerViewController *)presentDocumentExport:(void (^)(NSURL *url))completion URL:(NSURL *)url {
	UIDocumentPicker *picker = [UIDocumentPicker pickerForExport:url completion:completion];

	return [self popoverViewController:picker from:Nil] ? picker : Nil;
}

- (UIDocumentPickerViewController *)presentDocumentImport:(void (^)(NSURL *url))completion UTIs:(NSArray *)UTIs fromView:(UIView *)view {
	UIDocumentPicker *picker = [UIDocumentPicker pickerForImport:UTIs completion:completion];

	return [self popoverViewController:picker from:view] ? picker : Nil;
}

- (UIDocumentPickerViewController *)presentDocumentImport:(void (^)(NSURL *url))completion UTIs:(NSArray *)UTIs fromButton:(UIBarButtonItem *)button {
	UIDocumentPicker *picker = [UIDocumentPicker pickerForImport:UTIs completion:completion];

	return [self popoverViewController:picker from:button] ? picker : Nil;
}

- (UIDocumentPickerViewController *)presentDocumentImport:(void (^)(NSURL *url))completion UTIs:(NSArray *)UTIs {
	UIDocumentPicker *picker = [UIDocumentPicker pickerForImport:UTIs completion:completion];

	return [self popoverViewController:picker from:Nil] ? picker : Nil;
}

- (UIDocumentPickerViewController *)presentDocumentMove:(void (^)(NSURL *url))completion URL:(NSURL *)url fromView:(UIView *)view {
	UIDocumentPicker *picker = [UIDocumentPicker pickerForMove:url completion:completion];

	return [self popoverViewController:picker from:view] ? picker : Nil;
}

- (UIDocumentPickerViewController *)presentDocumentMove:(void (^)(NSURL *url))completion URL:(NSURL *)url fromButton:(UIBarButtonItem *)button {
	UIDocumentPicker *picker = [UIDocumentPicker pickerForMove:url completion:completion];

	return [self popoverViewController:picker from:button] ? picker : Nil;
}

- (UIDocumentPickerViewController *)presentDocumentMove:(void (^)(NSURL *url))completion URL:(NSURL *)url {
	UIDocumentPicker *picker = [UIDocumentPicker pickerForMove:url completion:completion];

	return [self popoverViewController:picker from:Nil] ? picker : Nil;
}

- (UIDocumentPickerViewController *)presentDocumentOpen:(void (^)(NSURL *url))completion UTIs:(NSArray *)UTIs fromView:(UIView *)view {
	UIDocumentPicker *picker = [UIDocumentPicker pickerForOpen:UTIs completion:completion];

	return [self popoverViewController:picker from:view] ? picker : Nil;
}

- (UIDocumentPickerViewController *)presentDocumentOpen:(void (^)(NSURL *url))completion UTIs:(NSArray *)UTIs fromButton:(UIBarButtonItem *)button {
	UIDocumentPicker *picker = [UIDocumentPicker pickerForOpen:UTIs completion:completion];

	return [self popoverViewController:picker from:button] ? picker : Nil;
}

- (UIDocumentPickerViewController *)presentDocumentOpen:(void (^)(NSURL *url))completion UTIs:(NSArray *)UTIs {
	UIDocumentPicker *picker = [UIDocumentPicker pickerForOpen:UTIs completion:completion];

	return [self popoverViewController:picker from:Nil] ? picker : Nil;
}

@end
