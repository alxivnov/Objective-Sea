//
//  StoreKit+Convenience.h
//  Ringtonic
//
//  Created by Alexander Ivanov on 13.07.17.
//  Copyright © 2017 Alexander Ivanov. All rights reserved.
//

#import <StoreKit/StoreKit.h>

#import "NSObject+Convenience.h"


@interface SKProduct (Convenience)

@property (strong, nonatomic, readonly) NSString *localizedPrice;
@property (strong, nonatomic, readonly) NSString *currencyCode;

- (SKPayment *)queuePayment:(NSInteger)quantity;
- (SKPayment *)queuePayment;

@end


@interface SKProductsRequest (Convenience)

+ (instancetype)startRequestWithProductIdentifiers:(NSArray<NSString *> *)productIdentifiers delegate:(id <SKProductsRequestDelegate>)delegate;
+ (instancetype)startRequestWithProductIdentifier:(NSString *)productIdentifier delegate:(id <SKProductsRequestDelegate>)delegate;

@end


@interface SKPaymentTransaction	(Convenience)

- (void)finishTransaction;

@end


@interface SKPaymentQueue (Convenience)

- (void)addPaymentWithProduct:(SKProduct *)product;

@end


@interface SKStoreProductViewController (Convenience)

- (void)loadProductWithIdentifier:(NSUInteger)identifier parameters:(NSDictionary *)parameters completionBlock:(void(^)(BOOL result, NSError *error))block;

+ (instancetype)loadProductWithIdentifier:(NSUInteger)identifier parameters:(NSDictionary *)parameters completionBlock:(void(^)(BOOL result, NSError *error))block;
+ (instancetype)loadProductWithIdentifier:(NSUInteger)identifier parameters:(NSDictionary *)parameters;

@end


@interface UIViewController (SKStoreProductViewController)

- (SKStoreProductViewController *)presentProductWithIdentifier:(NSUInteger)identifier parameters:(NSDictionary *)parameters;

@end


@interface NSError (StoreKit)

@property (strong, nonatomic, readonly) NSString *shortDescription;

@end

@interface NSBundle (StoreKit)

@property (strong, nonatomic, readonly) NSData *appStoreReceipt;

@end
