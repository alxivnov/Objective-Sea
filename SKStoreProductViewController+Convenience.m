//
//  SKStoreProductViewController+Convenience.m
//  Ringtonic
//
//  Created by Alexander Ivanov on 15.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "SKStoreProductViewController+Convenience.h"

@implementation SKStoreProductViewController (Convenience)

- (void)loadProductWithIdentifier:(NSUInteger)identifier affiliateInfo:(NSDictionary *)affiliateInfo completion:(void(^)(BOOL result, NSError *error))completion {
	NSMutableDictionary *parameters = [affiliateInfo mutableCopy];
	parameters[SKStoreProductParameterITunesItemIdentifier] = @(identifier);

	[self loadProductWithParameters:parameters completionBlock:completion];
}

+ (instancetype)storeWithProductIdentifier:(NSUInteger)identifier affiliateInfo:(NSDictionary *)affiliateInfo completion:(void(^)(BOOL result, NSError *error))completion {
	SKStoreProductViewController *instance = [self new];
	[instance loadProductWithIdentifier:identifier affiliateInfo:affiliateInfo completion:completion];
	return instance;
}

+ (instancetype)storeWithProductIdentifier:(NSUInteger)identifier affiliateInfo:(NSDictionary *)affiliateInfo {
	return [self storeWithProductIdentifier:identifier affiliateInfo:affiliateInfo completion:^(BOOL result, NSError *error) {
		[error log:@"loadProductWithParameters:"];
	}];
}

@end

@interface SKStoreProduct ()
@property (assign, nonatomic) BOOL productLoaded;
@end

@implementation SKStoreProduct

- (instancetype)init {
	self = [super init];

	if (self)
		self.delegate = self;

	return self;
}

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
	[viewController dismissViewControllerAnimated:YES completion:Nil];
}

- (void)loadProductWithIdentifier:(NSUInteger)identifier affiliateInfo:(NSDictionary *)affiliateInfo {
	[self loadProductWithIdentifier:identifier affiliateInfo:affiliateInfo completion:^(BOOL result, NSError *error) {
		self.productLoaded = result;

		[error log:@"loadProductWithIdentifier:"];
	}];
}

@end

@implementation UIViewController (SKStoreProductViewController)

- (SKStoreProductViewController *)presentStoreProductWithIdentifier:(NSUInteger)identifier affiliateInfo:(NSDictionary *)affiliateInfo {
	SKStoreProduct *product = [SKStoreProduct storeWithProductIdentifier:identifier affiliateInfo:affiliateInfo];
	[self presentViewController:product animated:YES completion:Nil];
	return product;
}

@end
