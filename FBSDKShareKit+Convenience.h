//
//  FBShareDialog.h
//  Ringtonic
//
//  Created by Alexander Ivanov on 05.03.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import <FBSDKShareKit/FBSDKShareKit.h>

#import "NSArray+Convenience.h"
#import "NSObject+Convenience.h"

@interface FBSDKShareLinkContent (Convenience)

+ (instancetype)contentWithURL:(NSURL *)url hashtag:(NSString *)hashtag;
+ (instancetype)contentWithURL:(NSURL *)url;

@end

@interface FBSDKSharePhotoContent (Convenience)

+ (instancetype)createWithURL:(NSURL *)url images:(NSArray<UIImage *> *)images userGenerated:(BOOL)userGenerated;
+ (instancetype)createWithURL:(NSURL *)url images:(NSArray<UIImage *> *)images;

+ (instancetype)createWithURL:(NSURL *)url image:(UIImage *)image userGenerated:(BOOL)userGenerated;
+ (instancetype)createWithURL:(NSURL *)url image:(UIImage *)image;

@end

@interface FBSDKAppInviteContent (Convenience)

+ (instancetype)createWithAppLinkURL:(NSURL *)appLinkURL previewImageURL:(NSURL *)previewImageURL destination:(FBSDKAppInviteDestination)destination;
+ (instancetype)createWithAppLinkURL:(NSURL *)appLinkURL previewImageURL:(NSURL *)previewImageURL;

@end

@interface FBShareDialog : FBSDKShareDialog <FBSDKSharingDelegate>

@property (copy, nonatomic) void (^completionHandler)(BOOL success, NSError *error);

- (instancetype)initWithCompletionHandler:(void (^)(BOOL success, NSError *error))completionHandler;

@end

@interface FBInviteDialog : FBSDKAppInviteDialog <FBSDKAppInviteDialogDelegate>

@property (copy, nonatomic) void (^completionHandler)(BOOL success, NSError *error);

- (instancetype)initWithCompletionHandler:(void (^)(BOOL success, NSError *error))completionHandler;

- (BOOL)validate;

@end

@interface UIViewController (FBSDKShareKit)

- (FBSDKShareDialog *)presentSharingContent:(id <FBSDKSharingContent>)content modes:(NSArray<NSNumber *> *)modes completion:(void (^)(BOOL success, NSError *error))completion;
- (FBSDKShareDialog *)presentSharingContent:(id <FBSDKSharingContent>)content modes:(NSArray<NSNumber *> *)modes;

- (FBSDKShareDialog *)presentSharingContent:(id <FBSDKSharingContent>)content mode:(FBSDKShareDialogMode)mode completion:(void (^)(BOOL success, NSError *error))completion;
- (FBSDKShareDialog *)presentSharingContent:(id <FBSDKSharingContent>)content mode:(FBSDKShareDialogMode)mode;

- (FBSDKShareDialog *)presentSharingContent:(id <FBSDKSharingContent>)content completion:(void (^)(BOOL success, NSError *error))completion;
- (FBSDKShareDialog *)presentSharingContent:(id <FBSDKSharingContent>)content;

- (FBSDKAppInviteDialog *)presentInviteContent:(FBSDKAppInviteContent *)content completion:(void (^)(BOOL success, NSError *error))completion;
- (FBSDKAppInviteDialog *)presentInviteContent:(FBSDKAppInviteContent *)content;

@end
