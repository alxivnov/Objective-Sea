//
//  SKStoreProductViewController+Convenience.h
//  Ringtonic
//
//  Created by Alexander Ivanov on 15.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import <StoreKit/StoreKit.h>

#import "NSObject+Convenience.h"

@interface SKStoreProductViewController (Convenience)

- (void)loadProductWithIdentifier:(NSUInteger)identifier affiliateInfo:(NSDictionary *)affiliateInfo completion:(void(^)(BOOL result, NSError *error))completion;

+ (instancetype)storeWithProductIdentifier:(NSUInteger)identifier affiliateInfo:(NSDictionary *)affiliateInfo completion:(void(^)(BOOL result, NSError *error))completion;
+ (instancetype)storeWithProductIdentifier:(NSUInteger)identifier affiliateInfo:(NSDictionary *)affiliateInfo;

@end

@interface SKStoreProduct : SKStoreProductViewController <SKStoreProductViewControllerDelegate>

@property (assign, nonatomic, readonly) BOOL productLoaded;

- (void)loadProductWithIdentifier:(NSUInteger)identifier affiliateInfo:(NSDictionary *)affiliateInfo;

@end

@interface UIViewController (SKStoreProductViewController)

- (SKStoreProductViewController *)presentStoreProductWithIdentifier:(NSUInteger)identifier affiliateInfo:(NSDictionary *)affiliateInfo;

@end
