//
//  UIImagePickerController+Convenience.h
//  Guardian
//
//  Created by Alexander Ivanov on 16.12.16.
//  Copyright © 2016 NATEK. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIAlertController+Convenience.h"
#import "UIImage+Convenience.h"

@interface UIImagePicker : UIImagePickerController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

+ (instancetype)imagePicker:(void (^)(NSDictionary *info))completion sourceType:(UIImagePickerControllerSourceType)sourceType;

@end

@interface UIViewController (UIImagePickerController)

- (instancetype)presentImagePicker:(void (^)(UIImage *image))completion sourceType:(UIImagePickerControllerSourceType)sourceType fromView:(UIView *)view;
- (instancetype)presentImagePicker:(void (^)(UIImage *image))completion sourceType:(UIImagePickerControllerSourceType)sourceType fromButton:(UIBarButtonItem *)button;

- (void)presentImagePicker:(void (^)(UIImage *image))completion sourceTypes:(NSArray *)sourceTypes fromView:(UIView *)view;
- (void)presentImagePicker:(void (^)(UIImage *image))completion sourceTypes:(NSArray *)sourceTypes fromButton:(UIBarButtonItem *)button;

@end
