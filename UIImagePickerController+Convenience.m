//
//  UIImagePickerController+Convenience.m
//  Guardian
//
//  Created by Alexander Ivanov on 16.12.16.
//  Copyright © 2016 NATEK. All rights reserved.
//

#import "UIImagePickerController+Convenience.h"

@interface UIImagePicker ()
@property (nonatomic, copy) void (^completion)(NSDictionary *info);
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
		if (self.completion)
			self.completion(info);
	}];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[self dismissViewControllerAnimated:YES completion:^{
		if (self.completion)
			self.completion(Nil);
	}];
}

+ (instancetype)imagePicker:(void (^)(NSDictionary *info))completion sourceType:(UIImagePickerControllerSourceType)sourceType {
	if (![UIImagePickerController isSourceTypeAvailable:sourceType])
		return Nil;

	UIImagePicker *instance = [UIImagePicker new];
	instance.completion = completion;
	instance.sourceType = sourceType;
	instance.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
	return instance;
}

@end

@implementation UIViewController (UIImagePickerController)

- (instancetype)presentImagePicker:(void (^)(UIImage *image))completion sourceType:(UIImagePickerControllerSourceType)sourceType from:(id)source {
	UIImagePicker *picker = [UIImagePicker imagePicker:^(NSDictionary *info) {
		UIImage *image = Nil;

		if (info[UIImagePickerControllerMediaURL])
			image = [UIImage imageWithContentsOfURL:info[UIImagePickerControllerMediaURL]];
		else if (info[UIImagePickerControllerEditedImage])
			image = info[UIImagePickerControllerEditedImage];
		else
			image = info[UIImagePickerControllerOriginalImage];

		if (completion)
			completion(image);
	} sourceType:sourceType];

	if (self.iPhone || sourceType == UIImagePickerControllerSourceTypeCamera)
		[self presentViewController:picker animated:YES completion:Nil];
	else
		[self popoverViewController:picker from:source];

	return picker;
}

- (instancetype)presentImagePicker:(void (^)(UIImage *image))completion sourceType:(UIImagePickerControllerSourceType)sourceType fromView:(UIView *)view {
	return [self presentImagePicker:completion sourceType:sourceType from:view];
}

- (instancetype)presentImagePicker:(void (^)(UIImage *image))completion sourceType:(UIImagePickerControllerSourceType)sourceType fromButton:(UIBarButtonItem *)button {
	return [self presentImagePicker:completion sourceType:sourceType from:button];
}

- (void)presentImagePicker:(void (^)(UIImage *image))completion sourceTypes:(NSArray *)sourceTypes from:(id)source {
	sourceTypes = [sourceTypes query:^BOOL(id item) {
		return [UIImagePickerController isSourceTypeAvailable:[item integerValue]];
	}];

	if (sourceTypes.count == 1)
		[self presentImagePicker:completion sourceType:[sourceTypes.firstObject integerValue] from:source];
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
		}] from:source configuration:Nil completion:^(UIAlertController *instance, NSInteger index) {
			if (index >= 0 && index < sourceTypes.count)
				[self presentImagePicker:completion sourceType:[sourceTypes[index] integerValue] from:source];
		}];
}

- (void)presentImagePicker:(void (^)(UIImage *image))completion sourceTypes:(NSArray *)sourceTypes fromView:(UIView *)view {
	[self presentImagePicker:completion sourceTypes:sourceTypes from:view];
}

- (void)presentImagePicker:(void (^)(UIImage *image))completion sourceTypes:(NSArray *)sourceTypes fromButton:(UIBarButtonItem *)button {
	[self presentImagePicker:completion sourceTypes:sourceTypes from:button];
}

@end
