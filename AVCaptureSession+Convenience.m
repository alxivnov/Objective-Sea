//
//  AVCaptureSession+Convenience.m
//  Scans
//
//  Created by Alexander Ivanov on 29.03.2018.
//  Copyright © 2018 Alexander Ivanov. All rights reserved.
//

#import "AVCaptureSession+Convenience.h"

@implementation AVCaptureSession (Convenience)

+ (instancetype)sessionWithPreset:(AVCaptureSessionPreset)sessionPreset {
	AVCaptureSession *session = [[AVCaptureSession alloc] init];
	if (!sessionPreset)
		return session;

	if ([session canSetSessionPreset:sessionPreset])
		session.sessionPreset = sessionPreset;
	else
		return Nil;

	return session;
}

@end

@implementation AVCaptureDeviceInput (Convenience)

+ (instancetype)deviceInputWithDevice:(AVCaptureDevice *)device {
	if (!device)
		return Nil;

	NSError *error = Nil;
	AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
	[error log:@"deviceInputWithDevice:"];

	return input;
}

+ (instancetype)deviceInputWithMediaType:(AVMediaType)mediaType {
	return mediaType ? [self deviceInputWithDevice:[AVCaptureDevice defaultDeviceWithMediaType:mediaType]] : Nil;
}

+ (instancetype)deviceInputWithUniqueID:(NSString *)deviceUniqueID {
	return deviceUniqueID ? [self deviceInputWithDevice:[AVCaptureDevice deviceWithUniqueID:deviceUniqueID]] : Nil;
}

+ (instancetype)deviceInputWithDeviceType:(AVCaptureDeviceType)deviceType mediaType:(AVMediaType)mediaType position:(AVCaptureDevicePosition)position {
	return deviceType ? [self deviceInputWithDevice:[AVCaptureDevice defaultDeviceWithDeviceType:deviceType mediaType:mediaType position:position]] : Nil;
}

@end

@implementation AVCaptureVideoDataOutput (Convenience)

+ (instancetype)videoDataOutputWithSampleBufferDelegate:(id<AVCaptureVideoDataOutputSampleBufferDelegate>)sampleBufferDelegate queue:(dispatch_queue_t)sampleBufferCallbackQueue {
	AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
	[output setSampleBufferDelegate:sampleBufferDelegate queue:sampleBufferCallbackQueue];
	return output;
}

@end

#if __has_include(<UIKit/UIKit.h>)

@implementation AVCapturePhoto (Convenience)

UIImageOrientation UIImageOrientationForCGImagePropertyOrientation(CGImagePropertyOrientation cgOrientation) {
	switch (cgOrientation) {
		case kCGImagePropertyOrientationUp: return UIImageOrientationUp;
		case kCGImagePropertyOrientationDown: return UIImageOrientationDown;
		case kCGImagePropertyOrientationLeft: return UIImageOrientationLeft;
		case kCGImagePropertyOrientationRight: return UIImageOrientationRight;
		case kCGImagePropertyOrientationUpMirrored: return UIImageOrientationUpMirrored;
		case kCGImagePropertyOrientationDownMirrored: return UIImageOrientationDownMirrored;
		case kCGImagePropertyOrientationLeftMirrored: return UIImageOrientationLeftMirrored;
		case kCGImagePropertyOrientationRightMirrored: return UIImageOrientationRightMirrored;
	}

	return UIImageOrientationUp;
}

- (UIImage *)image {
	return [UIImage imageWithCGImage:self.CGImageRepresentation scale:0.0 orientation:UIImageOrientationForCGImagePropertyOrientation([self.metadata[(NSString *)kCGImagePropertyOrientation] intValue])];
}

@end

@implementation UIButton (Convenience)

+ (instancetype)buttonWithFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)action {
	UIButton *button = [[UIButton alloc] initWithFrame:frame];
	[button setTitle:title forState:UIControlStateNormal];
	[button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
	button.layer.borderColor = button.currentTitleColor.CGColor;
	button.layer.borderWidth = 2.0;
	button.layer.cornerRadius = 22.0;
	return button;
}

@end

@interface AVCapturePhotoViewController () <AVCapturePhotoCaptureDelegate>
@property (strong, nonatomic, readonly) AVCaptureSession *session;

@property (strong, nonatomic, readonly) AVCaptureDeviceInput *deviceInput;
@property (strong, nonatomic, readonly) AVCapturePhotoOutput *photoOutput;
@end

@implementation AVCapturePhotoViewController

__synthesize(UIButton *, doneButton, [UIButton buttonWithFrame:CGRectMake(20.0, self.view.bounds.size.height - 44.0 - 30.0, 88.0, 44.0) title:@"Done" target:self action:@selector(done:)])

- (IBAction)done:(UIButton *)sender {
	[self.photoOutput capturePhotoWithSettings:[AVCapturePhotoSettings photoSettings] delegate:self];
}

__synthesize(UIButton *, cancelButton, [UIButton buttonWithFrame:CGRectMake(self.view.bounds.size.width - 88.0 - 20.0, self.view.bounds.size.height - 44.0 - 30.0, 88.0, 44.0) title:@"Cancel" target:self action:@selector(cancel:)])

- (IBAction)cancel:(UIButton *)sender {
	[self dismissViewControllerAnimated:YES completion:Nil];
}


__synthesize(AVCaptureSession *, session, [AVCaptureSession sessionWithPreset:AVCaptureSessionPresetPhoto])
__synthesize(AVCaptureDeviceInput *, deviceInput, [AVCaptureDeviceInput deviceInputWithMediaType:AVMediaTypeVideo])
__synthesize(AVCapturePhotoOutput *, photoOutput, [[AVCapturePhotoOutput alloc] init])

__synthesize(AVCaptureVideoPreviewLayer *, previewLayer, ({
	AVCaptureVideoPreviewLayer *layer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
	layer.frame = self.view.bounds;
	layer;
}))

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.

	[self.view addSubview:self.doneButton];
	[self.view addSubview:self.cancelButton];

	[self.session addInput:self.deviceInput];
	[self.session addOutput:self.photoOutput];
	[self.session startRunning];

	[self.view.layer addSublayer:self.previewLayer];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.

	[self.session stopRunning];
}

- (void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhoto:(AVCapturePhoto *)photo error:(NSError *)error {
	if (self.capturePhotoHandler)
		self.capturePhotoHandler(photo);

	[self dismissViewControllerAnimated:YES completion:Nil];

	[error log:@"didFinishProcessingPhoto:"];
}

@end

#endif
