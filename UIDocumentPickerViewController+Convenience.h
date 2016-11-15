//
//  UIDocumentPickerViewController+Convenience.h
//  Ringtonic
//
//  Created by Alexander Ivanov on 14.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NSFileManager+Convenience.h"
#import "UIApplication+Convenience.h"
#import "UIViewController+Convenience.h"

@import MobileCoreServices;

#define UIDocumentExportActivityType @"document.picker.export"
#define UIDocumentExportActivityTitle @"Save to iCloud Drive"
#define UIDocumentExportActivityImage @"iCloud"

@interface UIDocumentExportActivity : UIActivity

+ (UIDocumentExportActivity *)activityWithURL:(NSURL *)url;

@end

@interface UIDocumentPicker : UIDocumentPickerViewController <UIDocumentPickerDelegate>

+ (instancetype)pickerForExport:(NSURL *)url completion:(void(^)(NSURL *url))completion;
+ (instancetype)pickerForMove:(NSURL *)url completion:(void(^)(NSURL *url))completion;

+ (instancetype)pickerForImport:(NSArray *)UTIs completion:(void(^)(NSURL *url))completion;
+ (instancetype)pickerForOpen:(NSArray *)UTIs completion:(void(^)(NSURL *url))completion;

@end

@interface UIViewController (UIDocumentPickerViewController)

- (UIDocumentPickerViewController *)presentDocumentExport:(void (^)(NSURL *url))completion URL:(NSURL *)url fromView:(UIView *)view;
- (UIDocumentPickerViewController *)presentDocumentExport:(void (^)(NSURL *url))completion URL:(NSURL *)url fromButton:(UIBarButtonItem *)button;
- (UIDocumentPickerViewController *)presentDocumentExport:(void (^)(NSURL *url))completion URL:(NSURL *)url;

- (UIDocumentPickerViewController *)presentDocumentImport:(void (^)(NSURL *url))completion UTIs:(NSArray *)UTIs fromView:(UIView *)view;
- (UIDocumentPickerViewController *)presentDocumentImport:(void (^)(NSURL *url))completion UTIs:(NSArray *)UTIs fromButton:(UIBarButtonItem *)button;
- (UIDocumentPickerViewController *)presentDocumentImport:(void (^)(NSURL *url))completion UTIs:(NSArray *)UTIs;

- (UIDocumentPickerViewController *)presentDocumentMove:(void (^)(NSURL *url))completion URL:(NSURL *)url fromView:(UIView *)view;
- (UIDocumentPickerViewController *)presentDocumentMove:(void (^)(NSURL *url))completion URL:(NSURL *)url fromButton:(UIBarButtonItem *)button;
- (UIDocumentPickerViewController *)presentDocumentMove:(void (^)(NSURL *url))completion URL:(NSURL *)url;

- (UIDocumentPickerViewController *)presentDocumentOpen:(void (^)(NSURL *url))completion UTIs:(NSArray *)UTIs fromView:(UIView *)view;
- (UIDocumentPickerViewController *)presentDocumentOpen:(void (^)(NSURL *url))completion UTIs:(NSArray *)UTIs fromButton:(UIBarButtonItem *)button;
- (UIDocumentPickerViewController *)presentDocumentOpen:(void (^)(NSURL *url))completion UTIs:(NSArray *)UTIs;

@end
