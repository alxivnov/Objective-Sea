//
//  SKInAppPurchase.m
//  Ringtonic
//
//  Created by Alexander Ivanov on 13.07.17.
//  Copyright © 2017 Alexander Ivanov. All rights reserved.
//

#import "SKInAppPurchase.h"


#if TARGET_OS_IPHONE
#define APP_VERSION @"CFBundleVersion"
#else
#define APP_VERSION @"CFBundleShortVersionString"
#endif

#if __has_include("RMAppReceipt.h")

@implementation RMAppReceipt (Convenience)

- (BOOL)validateReceiptWithIdentifier:(NSString *)identifier version:(NSString *)version {
	return [self.bundleIdentifier isEqualToString:identifier ?: [NSBundle mainBundle].bundleIdentifier] && [self.appVersion isEqualToString:version ?: [[NSBundle mainBundle] objectForInfoDictionaryKey:APP_VERSION]] && [self verifyReceiptHash];
}

- (BOOL)checkExpirationDate {
	return self.expirationDate == Nil || self.expirationDate.timeIntervalSinceNow > 0.0;
}

+ (RMAppReceipt *)validBundleReceipt {
	RMAppReceipt *receipt = [RMAppReceipt bundleReceipt];

	return [receipt validateReceiptWithIdentifier:Nil version:Nil] && [receipt checkExpirationDate] ? receipt : Nil;
}

@end

#endif

@interface SKInAppPurchase () <SKProductsRequestDelegate, SKPaymentTransactionObserver>
#if __has_include("RMAppReceipt.h")
@property (strong, nonatomic, readonly) RMAppReceipt *receipt;
#endif

@property (strong, nonatomic, readonly) NSURL *cacheURL;
@property (strong, nonatomic) NSDictionary *cache;

@property (copy, nonatomic) void(^productRequestHandler)(SKProduct *, NSError *);
@property (copy, nonatomic) void(^paymentRequestHandler)(NSArray<SKPaymentTransaction *> *);
@end

@implementation SKInAppPurchase

#if __has_include("RMAppReceipt.h")

static RMAppReceipt *_receipt;

- (RMAppReceipt *)receipt {
	if (!_receipt)
		_receipt = [RMAppReceipt validBundleReceipt];

	return _receipt;
}

- (BOOL)purchased {
	return [self.receipt containsInAppPurchaseOfProductIdentifier:self.productIdentifier];
}

#endif

@synthesize cacheURL = _cacheURL;

- (NSURL *)cacheURL {
	if (!_cacheURL)
		_cacheURL = [[[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", self.productIdentifier]];

	return _cacheURL;
}

@synthesize cache = _cache;

- (NSDictionary *)cache {
	if (!_cache)
		_cache = [NSDictionary dictionaryWithContentsOfURL:self.cacheURL];

	return _cache;
}

- (void)setCache:(NSDictionary *)cache {
	_cache = cache;

	if (_cache)
		[_cache writeToURL:self.cacheURL atomically:YES];
	else
		[self.cacheURL removeItem];
}

- (NSString *)localizedDescription {
	return self.cache[@"localizedDescription"];
}

- (NSString *)localizedTitle {
	return self.cache[@"localizedTitle"];
}

- (NSString *)localizedPrice {
	return self.cache[@"localizedPrice"];
}

- (NSDecimalNumber *)price {
	return self.cache[@"price"];
}

- (NSString *)currencyCode {
	return self.cache[@"currencyCode"];
}

- (instancetype)initWithProductIdentifier:(NSString *)productIdentifier {
	self = [self init];

	if (self) {
		_productIdentifier = productIdentifier;

		[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
	}

	return self;
}

- (SKProductsRequest *)requestProduct:(void(^)(SKProduct *, NSError *))handler {
	self.productRequestHandler = handler;

	return [SKProductsRequest startRequestWithProductIdentifier:self.productIdentifier delegate:self];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
	SKProduct *product = [response.products firstObject:^BOOL(SKProduct *obj) {
		return [obj.productIdentifier isEqualToString:self.productIdentifier];
	}];

	if (self.productRequestHandler) {
		self.productRequestHandler(product, Nil);

		self.productRequestHandler = Nil;
	}

	if (product)
		self.cache = @{ @"localizedDescription" : product.localizedDescription ?: STR_EMPTY, @"localizedTitle" : product.localizedTitle ?: STR_EMPTY, @"localizedPrice" : product.localizedPrice ?: STR_EMPTY, @"price" : product.price ?: @0, @"currencyCode" : product.priceLocale.currencyCode ?: STR_EMPTY };
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
	if (self.productRequestHandler) {
		self.productRequestHandler(Nil, error);

		self.productRequestHandler = Nil;
	}

	[error log:@"request:didFailWithError:"];
}

- (SKPayment *)requestPayment:(SKProduct *)product handler:(void (^)(NSArray<SKPaymentTransaction *> *))handler {
	self.paymentRequestHandler = handler;

	return [product queuePayment];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
	transactions = [transactions query:^BOOL(SKPaymentTransaction *obj) {
		return [obj.payment.productIdentifier isEqualToString:self.productIdentifier];
	}];

	if ([transactions any:^BOOL(SKPaymentTransaction *obj) {
		return obj.transactionState != SKPaymentTransactionStatePurchasing;
	}]) {
		if (self.paymentRequestHandler) {
			self.paymentRequestHandler(transactions);

			self.paymentRequestHandler = Nil;
		}

		for (SKPaymentTransaction *transaction in transactions)
			[queue finishTransaction:transaction];
	}

	if (transactions.count)
		[transactions log:@"updatedTransactions:"];
}

- (void)dealloc {
	[[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

static NSMutableDictionary *_purchases;

+ (NSMutableDictionary<NSString *, SKInAppPurchase *> *)purchases {
	if (!_purchases)
		_purchases = [NSMutableDictionary dictionary];

	return _purchases;
}

+ (instancetype)purchaseWithProductIdentifier:(NSString *)productIdentifier {
	if (!productIdentifier)
		return Nil;

	NSMutableDictionary *purchases = [self purchases];

	SKInAppPurchase *purchase = purchases[productIdentifier];

	if (!purchase) {
		SKInAppPurchase *purchase = [[self alloc] initWithProductIdentifier:productIdentifier];
		[purchase requestProduct:Nil];

		purchases[productIdentifier] = purchase;
	}

	return purchase;
}

+ (NSArray<SKInAppPurchase *> *)purchasesWithProductIdentifiers:(NSArray<NSString *> *)productIdentifiers {
	return [productIdentifiers map:^id(NSString *obj) {
		return [self purchaseWithProductIdentifier:obj];
	}];
}

@end
