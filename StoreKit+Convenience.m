//
//  StoreKit+Convenience.m
//  Ringtonic
//
//  Created by Alexander Ivanov on 13.07.17.
//  Copyright © 2017 Alexander Ivanov. All rights reserved.
//

#import "StoreKit+Convenience.h"

@implementation SKProduct (Convenience)

- (NSString *)localizedPrice {
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	[formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
	[formatter setLocale:self.priceLocale];
	return [formatter stringFromNumber:self.price];
}

- (SKPayment *)queuePayment:(NSInteger)quantity {
	SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:self];
	if (quantity > 0)
		payment.quantity = quantity;
	if (IS_DEBUGGING)
		payment.simulatesAskToBuyInSandbox = YES;
	[[SKPaymentQueue defaultQueue] addPayment:payment];
	return payment;
}

- (SKPayment *)queuePayment {
	return [self queuePayment:0];
}

@end


@implementation SKProductsRequest (Convenience)

+ (instancetype)requestWithProductIdentifiers:(NSArray<NSString *> *)productIdentifiers {
	return productIdentifiers ? [[self alloc] initWithProductIdentifiers:[NSSet setWithArray:productIdentifiers]] : Nil;
}

+ (instancetype)requestWithProductIdentifier:(NSString *)productIdentifier {
	return productIdentifier ? [[self alloc] initWithProductIdentifiers:[NSSet setWithObject:productIdentifier]] : Nil;
}

@end


@implementation SKPaymentTransaction (Convenience)

- (void)finishTransaction {
	[[SKPaymentQueue defaultQueue] finishTransaction:self];

	[self.error log:@"finishTransaction:"];
}

- (NSString *)debugDescription {
	return [NSString stringWithFormat:@"<SKPaymentTransaction productIdentifier=%@, transactionState=%ld, error=%@>", self.payment.productIdentifier, self.transactionState, [self.error debugDescription]];
}

@end


@implementation SKStoreProductViewController (Convenience)

- (void)loadProductWithIdentifier:(NSUInteger)identifier parameters:(NSDictionary *)parameters completionBlock:(void(^)(BOOL, NSError *))block {
	NSMutableDictionary *mutableParameters = [parameters mutableCopy];
	mutableParameters[SKStoreProductParameterITunesItemIdentifier] = @(identifier);

	[self loadProductWithParameters:mutableParameters completionBlock:block];
}

+ (instancetype)loadProductWithIdentifier:(NSUInteger)identifier parameters:(NSDictionary *)parameters completionBlock:(void(^)(BOOL, NSError *))block {
	SKStoreProductViewController *instance = [[self alloc] init];
	[instance loadProductWithIdentifier:identifier parameters:parameters completionBlock:block];
	return instance;
}

+ (instancetype)loadProductWithIdentifier:(NSUInteger)identifier parameters:(NSDictionary *)parameters {
	return [self loadProductWithIdentifier:identifier parameters:parameters completionBlock:^(BOOL result, NSError *error) {
		[error log:@"loadProductWithParameters:"];
	}];
}

@end


@interface SKStoreProductViewControllerExt : SKStoreProductViewController <SKStoreProductViewControllerDelegate>
@property (assign, nonatomic) BOOL productLoaded;
@end

@implementation SKStoreProductViewControllerExt

- (instancetype)init {
	self = [super init];

	if (self)
		self.delegate = self;

	return self;
}

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
	[viewController dismissViewControllerAnimated:YES completion:Nil];
}

- (void)loadProductWithIdentifier:(NSUInteger)identifier parameters:(NSDictionary *)parameters {
	[self loadProductWithIdentifier:identifier parameters:parameters completionBlock:^(BOOL result, NSError *error) {
		self.productLoaded = result;

		[error log:@"loadProductWithParameters:"];
	}];
}

@end


@implementation UIViewController (SKStoreProductViewController)

- (SKStoreProductViewController *)presentProductWithIdentifier:(NSUInteger)identifier parameters:(NSDictionary *)parameters {
	SKStoreProductViewController *vc = [SKStoreProductViewControllerExt loadProductWithIdentifier:identifier parameters:parameters];
	[self presentViewController:vc animated:YES completion:Nil];
	return vc;
}

@end

@implementation NSError (StoreKit)

- (NSString *)shortDescription {
	if ([self.domain isEqualToString:SKErrorDomain]) {
		if (self.code == SKErrorUnknown)
			return @"SKErrorUnknown";
		else if (self.code == SKErrorClientInvalid)
			return @"SKErrorClientInvalid";
		else if (self.code == SKErrorPaymentCancelled)
			return @"SKErrorPaymentCancelled";
		else if (self.code == SKErrorPaymentInvalid)
			return @"SKErrorPaymentInvalid";
		else if (self.code == SKErrorPaymentNotAllowed)
			return @"SKErrorPaymentNotAllowed";
		else if (self.code == SKErrorStoreProductNotAvailable)
			return @"SKErrorStoreProductNotAvailable";
		else if (self.code == SKErrorCloudServicePermissionDenied)
			return @"SKErrorCloudServicePermissionDenied";
		else if (self.code == SKErrorCloudServiceNetworkConnectionFailed)
			return @"SKErrorCloudServiceNetworkConnectionFailed";
		else if (self.code == SKErrorCloudServiceRevoked)
			return @"SKErrorCloudServiceRevoked";
	}

	return [NSString stringWithFormat:@"%@ %ld", self.domain, (long)self.code];
}

@end
