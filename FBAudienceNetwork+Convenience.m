//
//  FBAdView+Convenience.m
//  Ringtonic
//
//  Created by Alexander Ivanov on 09.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "FBAudienceNetwork+Convenience.h"

@implementation FBAdView (Convenience)

+ (instancetype)loadWithPlacementID:(NSString *)placementID rootViewController:(UIViewController *)viewController {
	FBAdView *adView = [[self alloc] initWithPlacementID:placementID adSize:(viewController ? viewController.iPad : [UIApplication sharedApplication].iPad) ? kFBAdSizeHeight90Banner : kFBAdSizeHeight50Banner rootViewController:viewController];
	[adView loadAd];
	return adView;
}

+ (instancetype)loadWithPlacementID:(NSString *)placementID {
	return [self loadWithPlacementID:placementID rootViewController:Nil];
}

@end

@interface FBAdViewDelegate ()
@property (copy, nonatomic) void(^completion)(FBAdView *adView);

@property (strong, nonatomic) FBAdView *adView;
@end

@implementation FBAdViewDelegate

- (FBAdSize)adSize {
	return [UIApplication sharedApplication].iPad ? kFBAdSizeHeight90Banner : kFBAdSizeHeight50Banner;
}

- (instancetype)init {
	self = [super init];

	if (self) {
//		if (IS_DEBUGGING)
//			[FBAdSettings addTestDevice:[FBAdSettings testDeviceHash]];
//		else
			[FBAdSettings clearTestDevices];
	}

	return self;
}

- (FBAdView *)loadWithPlacementID:(NSString *)placementID rootViewController:(UIViewController *)viewController completion:(void (^)(FBAdView *adView))completion {
	self.adView = [[FBAdView alloc] initWithPlacementID:placementID adSize:viewController ? viewController.iPad ? kFBAdSizeHeight90Banner : kFBAdSizeHeight50Banner : self.adSize rootViewController:viewController];
	self.completion = completion;
	self.adView.delegate = self;
	[self.adView loadAd];
	return self.adView;
}

- (FBAdView *)loadWithPlacementID:(NSString *)placementID completion:(void (^)(FBAdView *adView))completion {
	return [self loadWithPlacementID:placementID rootViewController:nil completion:completion];
}

- (void)adViewDidLoad:(FBAdView *)adView {
	self.adView = Nil;

	if (!self.completion)
		return;

	self.completion(adView);
	self.completion = Nil;
}

- (void)adView:(FBAdView *)adView didFailWithError:(NSError *)error {
	self.adView = Nil;

	if (!self.completion)
		return;

	self.completion(Nil);
	self.completion = Nil;

	[error log:@"adView:didFailWithError:"];
}

@end
