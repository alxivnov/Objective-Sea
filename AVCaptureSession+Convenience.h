//
//  AVCaptureSession+Convenience.h
//  Scans
//
//  Created by Alexander Ivanov on 29.03.2018.
//  Copyright © 2018 Alexander Ivanov. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#import "NSObject+Convenience.h"

@interface AVCaptureSession (Convenience)

+ (instancetype)sessionWithPreset:(AVCaptureSessionPreset)sessionPreset;

@end

@interface AVCaptureDeviceInput (Convenience)

+ (instancetype)deviceInputWithDevice:(AVCaptureDevice *)device;
+ (instancetype)deviceInputWithMediaType:(AVMediaType)mediaType;
+ (instancetype)deviceInputWithUniqueID:(NSString *)deviceUniqueID;
+ (instancetype)deviceInputWithDeviceType:(AVCaptureDeviceType)deviceType mediaType:(AVMediaType)mediaType position:(AVCaptureDevicePosition)position;

@end

@interface AVCaptureVideoDataOutput (Convenience)

+ (instancetype)videoDataOutputWithSampleBufferDelegate:(id<AVCaptureVideoDataOutputSampleBufferDelegate>)sampleBufferDelegate queue:(dispatch_queue_t)sampleBufferCallbackQueue;

@end

@interface AVCaptureMetadataOutput (Convenience)

+ (instancetype)metadataOutputWithMetadataObjectsDelegate:(id<AVCaptureMetadataOutputObjectsDelegate>)objectsDelegate queue:(dispatch_queue_t)objectsCallbackQueue;

- (void)setAvailableMetadataObjectTypes:(NSArray<AVMetadataObjectType> *)metadataObjectTypes;

@end

#if __has_include(<UIKit/UIKit.h>)

#import <UIKit/UIKit.h>

@interface AVCapturePhoto (Convenience)

@property (strong, nonatomic, readonly) UIImage *image;

@end

@interface AVCapturePhotoViewController : UIViewController

@property (strong, nonatomic, readonly) AVCaptureVideoPreviewLayer *previewLayer;

@property (strong, nonatomic, readonly) UIButton *doneButton;
@property (strong, nonatomic, readonly) UIButton *cancelButton;

@property (copy, nonatomic) void (^capturePhotoHandler)(AVCapturePhoto *photo);

@end

#endif
