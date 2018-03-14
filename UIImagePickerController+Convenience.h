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

@interface UIViewController (UIImagePickerController)

- (instancetype)presentImagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType mediaTypes:(NSArray<NSString *> *)mediaTypes from:(id)from completion:(void (^)(UIImage *image))completion;

- (void)presentImagePickerWithSourceTypes:(NSArray<NSNumber *> *)sourceTypes mediaTypes:(NSArray<NSString *> *)mediaTypes from:(id)from completion:(void (^)(UIImage *image))completion;

@end
