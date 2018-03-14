//
//  UIImagePickerController+Convenience.m
//  Guardian
//
//  Created by Alexander Ivanov on 16.12.16.
//  Copyright © 2016 NATEK. All rights reserved.
//

#import "UIImagePickerController+Convenience.h"

@interface UIImagePicker : UIImagePickerController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, copy) void (^completion)(UIImage *image, NSDictionary *info);
@end

@implementation UIImagePicker

- (instancetype)init {
	self = [super init];

	if (self)
		self.delegate = self;

	return self;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[self dismissViewControllerAnimated:YES completion:^{
		UIImage *image = Nil;

		if (info[UIImagePickerControllerMediaURL])
			image = [UIImage imageWithContentsOfURL:info[UIImagePickerControllerMediaURL]];
		else
			image = info[UIImagePickerControllerEditedImage] ?: info[UIImagePickerControllerOriginalImage];

		if (self.completion)
			self.completion(image, info);
	}];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[self dismissViewControllerAnimated:YES completion:^{
		if (self.completion)
			self.completion(Nil, Nil);
	}];
}

+ (instancetype)imagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType mediaTypes:(NSArray<NSString *> *)mediaTypes completion:(void (^)(UIImage *image, NSDictionary *info))completion {
	if (![UIImagePickerController isSourceTypeAvailable:sourceType])
		return Nil;

	UIImagePicker *instance = [UIImagePicker new];
	instance.sourceType = sourceType;
	if (mediaTypes)
		instance.mediaTypes = mediaTypes;// ?: [UIImagePickerController availableMediaTypesForSourceType:sourceType];
	instance.completion = completion;
	return instance;
}

@end

@implementation UIViewController (UIImagePickerController)

- (instancetype)presentImagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType mediaTypes:(NSArray<NSString *> *)mediaTypes from:(id)from completion:(void (^)(UIImage *image))completion {
	UIImagePicker *picker = [UIImagePicker imagePickerWithSourceType:sourceType mediaTypes:mediaTypes completion:^(UIImage *image, NSDictionary *info) {
		if (completion)
			completion(image);
	}];

	if (self.iPhone || sourceType == UIImagePickerControllerSourceTypeCamera)
		[self presentViewController:picker animated:YES completion:Nil];
	else
		[self popoverViewController:picker from:from];

	return picker;
}

- (void)presentImagePickerWithSourceTypes:(NSArray<NSNumber *> *)sourceTypes mediaTypes:(NSArray<NSString *> *)mediaTypes from:(id)from completion:(void (^)(UIImage *image))completion {
	sourceTypes = [sourceTypes query:^BOOL(NSNumber *obj) {
		return [UIImagePickerController isSourceTypeAvailable:obj.integerValue];
	}];

	if (sourceTypes.count == 1)
		[self presentImagePickerWithSourceType:sourceTypes.firstObject.integerValue mediaTypes:mediaTypes from:from completion:completion];
	else
		[self presentAlertControllerWithTitle:Nil message:Nil preferredStyle:UIAlertControllerStyleActionSheet cancelActionTitle:NSLocalizedString(@"Cancel", @"Cancel button title in Image Picker.") destructiveActionTitle:Nil otherActionTitles:[sourceTypes map:^id(id item) {
			switch ([item integerValue]) {
				case UIImagePickerControllerSourceTypeCamera:
					return NSLocalizedString(@"Camera", @"Camera button title in Image Picker.");
				case UIImagePickerControllerSourceTypePhotoLibrary:
					return NSLocalizedString(@"Photos", @"Photos button title in Image Picker.");
				case UIImagePickerControllerSourceTypeSavedPhotosAlbum:
					return NSLocalizedString(@"Albums", @"Albums button title in Image Picker.");
				default:
					return Nil;
			}
		}] from:from configuration:Nil completion:^(UIAlertController *instance, NSInteger index) {
			if (index >= 0 && index < sourceTypes.count)
				[self presentImagePickerWithSourceType:sourceTypes[index].integerValue mediaTypes:mediaTypes from:from completion:completion];
		}];
}

@end
