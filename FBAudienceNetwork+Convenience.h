//
//  FBAdView+Convenience.h
//  Ringtonic
//
//  Created by Alexander Ivanov on 09.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import <FBAudienceNetwork/FBAudienceNetwork.h>

#import "NSObject+Convenience.h"
#import "UIApplication+Convenience.h"
#import "UIViewController+Convenience.h"

@interface FBAdView (Convenience)

+ (instancetype)loadWithPlacementID:(NSString *)placementID rootViewController:(UIViewController *)viewController;
+ (instancetype)loadWithPlacementID:(NSString *)placementID;

@end

@interface FBAdViewDelegate : NSObject <FBAdViewDelegate>

@property (assign, nonatomic, readonly) FBAdSize adSize;

- (FBAdView *)loadWithPlacementID:(NSString *)placementID rootViewController:(UIViewController *)viewController completion:(void (^)(FBAdView *adView))completion;

- (FBAdView *)loadWithPlacementID:(NSString *)placementID completion:(void (^)(FBAdView *adView))completion;

@end
