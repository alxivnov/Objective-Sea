//
//  SKInAppPurchase.h
//  Ringtonic
//
//  Created by Alexander Ivanov on 13.07.17.
//  Copyright © 2017 Alexander Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "StoreKit+Convenience.h"
#import "NSArray+Convenience.h"
#import "NSFileManager+Convenience.h"

#if __has_include("RMAppReceipt.h")
#import "RMAppReceipt.h"
#endif


@interface SKInAppPurchase : NSObject

@property (strong, nonatomic, readonly) NSString *productIdentifier;

@property (strong, nonatomic, readonly) NSString *localizedDescription;
@property (strong, nonatomic, readonly) NSString *localizedTitle;
@property (strong, nonatomic, readonly) NSString *localizedPrice;
@property (strong, nonatomic, readonly) NSDecimalNumber *price;
@property (strong, nonatomic, readonly) NSString *currencyCode;

@property (assign, nonatomic, readonly) BOOL purchased;

- (instancetype)initWithProductIdentifier:(NSString *)productIdentifier;

- (SKProductsRequest *)requestProduct:(void(^)(SKProduct *product, NSError *error))handler;

- (SKPayment *)requestPayment:(SKProduct *)product handler:(void(^)(NSArray<SKPaymentTransaction *> *transactions))handler;

+ (SKInAppPurchase *)purchaseWithProductIdentifier:(NSString *)productIdentifier;

+ (NSArray<SKInAppPurchase *> *)purchasesWithProductIdentifiers:(NSArray<NSString *> *)productIdentifiers;

@end
