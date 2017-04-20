//
//  FBShareDialog.m
//  Ringtonic
//
//  Created by Alexander Ivanov on 05.03.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "FBSDKShareKit+Convenience.h"

@implementation FBSDKShareLinkContent (Convenience)

+ (instancetype)createWithURL:(NSURL *)url {
	FBSDKShareLinkContent *instance = [FBSDKShareLinkContent new];
//	instance.contentDescription = description;
//	instance.contentTitle = title;
	instance.contentURL = url;
//	instance.imageURL = imageURL;
	return instance;
}

@end

@implementation FBSDKSharePhotoContent (Convenience)

+ (instancetype)createWithURL:(NSURL *)url images:(NSArray<UIImage *> *)images userGenerated:(BOOL)userGenerated {
	FBSDKSharePhotoContent *instance = [FBSDKSharePhotoContent new];
	instance.contentURL = url;
	instance.photos = [images map:^id(id obj) {
		return [FBSDKSharePhoto photoWithImage:obj userGenerated:userGenerated];
	}];
	return instance;
}

+ (instancetype)createWithURL:(NSURL *)url images:(NSArray<UIImage *> *)images {
	return [self createWithURL:url images:images userGenerated:NO];
}

+ (instancetype)createWithURL:(NSURL *)url image:(UIImage *)image userGenerated:(BOOL)userGenerated {
	FBSDKSharePhotoContent *instance = [FBSDKSharePhotoContent new];
	instance.contentURL = url;
	instance.photos = @[ [FBSDKSharePhoto photoWithImage:image userGenerated:userGenerated] ];
	return instance;
}

+ (instancetype)createWithURL:(NSURL *)url image:(UIImage *)image {
	return [self createWithURL:url image:image userGenerated:NO];
}

@end

@implementation FBSDKAppInviteContent (Convenience)

+ (instancetype)createWithAppLinkURL:(NSURL *)appLinkURL previewImageURL:(NSURL *)previewImageURL destination:(FBSDKAppInviteDestination)destination {
	FBSDKAppInviteContent *content = [FBSDKAppInviteContent new];
	content.appLinkURL = appLinkURL;
	content.appInvitePreviewImageURL = previewImageURL;
	content.destination = destination;
	return content;
}

+ (instancetype)createWithAppLinkURL:(NSURL *)appLinkURL previewImageURL:(NSURL *)previewImageURL {
	return [FBSDKAppInviteContent createWithAppLinkURL:appLinkURL previewImageURL:previewImageURL destination:FBSDKAppInviteDestinationFacebook];
}

@end

@implementation FBShareDialog

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results {
	NSLog(@"sharer:didCompleteWithResults: %@", results);

	if (self.completionHandler)
		self.completionHandler(YES, Nil);
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error {
	[error log:@"sharer:didFailWithError:"];

	if (self.completionHandler)
		self.completionHandler(NO, error);
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer {
	NSLog(@"sharerDidCancel:");

	if (self.completionHandler)
		self.completionHandler(NO, Nil);
}

- (instancetype)initWithCompletionHandler:(void (^)(BOOL, NSError *))completionHandler {
	self = [self init];

	if (self) {
		self.delegate = self;

		self.completionHandler = completionHandler;
	}

	return self;
}

@end

@implementation FBInviteDialog

- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didCompleteWithResults:(NSDictionary *)results {
	NSLog(@"appInviteDialog:didCompleteWithResults: %@", results);

	if (self.completionHandler)
		self.completionHandler([results[@"didComplete"] boolValue] && ![results[@"completionGesture"] isEqualToString:@"cancel"], Nil);
}

- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didFailWithError:(NSError *)error {
	[error log:@"appInviteDialog:didFailWithError:"];

	if (self.completionHandler)
		self.completionHandler(NO, error);
}

- (instancetype)initWithCompletionHandler:(void (^)(BOOL, NSError *))completionHandler {
	self = [self init];

	if (self) {
		self.delegate = self;

		self.completionHandler = completionHandler;
	}

	return self;
}

@end

@implementation UIViewController (FBSDKShareKit)

- (FBSDKShareDialog *)presentSharingContent:(id <FBSDKSharingContent>)content modes:(NSArray<NSNumber *> *)modes completion:(void (^)(BOOL, NSError *))completion {
	FBShareDialog *dialog = [[FBShareDialog alloc] initWithCompletionHandler:completion];
	dialog.shareContent = content;
	dialog.fromViewController = self;

	for (NSNumber *mode in modes) {
		dialog.mode = mode.unsignedIntegerValue;
		if ([dialog canShow])
			break;
	}

	return [dialog show] ? dialog : Nil;
}

- (FBSDKShareDialog *)presentSharingContent:(id<FBSDKSharingContent>)content modes:(NSArray<NSNumber *> *)modes {
	return [self presentSharingContent:content modes:modes completion:Nil];
}

- (FBSDKShareDialog *)presentSharingContent:(id<FBSDKSharingContent>)content mode:(FBSDKShareDialogMode)mode completion:(void (^)(BOOL, NSError *))completion {
	return [self presentSharingContent:content modes:@[ @(mode) ] completion:completion];
}

- (FBSDKShareDialog *)presentSharingContent:(id <FBSDKSharingContent>)content mode:(FBSDKShareDialogMode)mode {
	return [self presentSharingContent:content mode:mode completion:Nil];
}

- (FBSDKShareDialog *)presentSharingContent:(id<FBSDKSharingContent>)content completion:(void (^)(BOOL, NSError *))completion {
	return [self presentSharingContent:content modes:@[ @(FBSDKShareDialogModeNative), @(FBSDKShareDialogModeFeedBrowser), @(FBSDKShareDialogModeAutomatic) ] completion:completion];
}

- (FBSDKShareDialog *)presentSharingContent:(id <FBSDKSharingContent>)content {
	return [self presentSharingContent:content completion:Nil];
}

- (FBSDKAppInviteDialog *)presentInviteContent:(FBSDKAppInviteContent *)content completion:(void (^)(BOOL, NSError *))completion {
	FBInviteDialog *dialog = [[FBInviteDialog alloc] initWithCompletionHandler:completion];
	dialog.content = content;
	dialog.fromViewController = self;

	return [dialog canShow] && [dialog validateWithError:Nil] && [dialog show] ? dialog : Nil;
}

- (FBSDKAppInviteDialog *)presentInviteContent:(FBSDKAppInviteContent *)content {
	return [self presentInviteContent:content completion:Nil];
}

@end
