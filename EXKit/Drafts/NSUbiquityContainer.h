//
//  NSUbiquityContainer.h
//  Guardian
//
//  Created by Alexander Ivanov on 13.05.15.
//  Copyright (c) 2015 NATEK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUbiquityContainer : NSObject

@property (strong, nonatomic, readonly) NSURL *url;

- (instancetype)init:(NSString *)identifier;
- (instancetype)init;

- (void)add:(NSURL *)url;
- (void)remove:(NSURL *)url;
- (NSArray *)items;

+ (instancetype)create:(NSString *)identifier;
+ (instancetype)create;

+ (instancetype)defaultContainer;

@end
