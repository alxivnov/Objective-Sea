//
//  CoreImage+Convenience.h
//  Poisk
//
//  Created by Alexander Ivanov on 13.06.17.
//  Copyright © 2017 Pine 9. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImage (CoreImage)

- (NSArray<CIFeature *> *)featuresOfType:(NSString *)type options:(NSDictionary<NSString *, id> *)options;

- (CGRect)boundsForFeature:(CIFeature *)feature;

- (UIImage *)imageWithFeature:(CIFeature *)feature;

+ (UIImage *)imageWithFilter:(NSString *)name parameters:(NSDictionary<NSString *, id> *)params scale:(CGFloat)scale orientation:(UIImageOrientation)orientation;
+ (UIImage *)imageWithFilter:(NSString *)name parameters:(NSDictionary<NSString *, id> *)params scale:(CGFloat)scale;
+ (UIImage *)imageWithFilter:(NSString *)name parameters:(NSDictionary<NSString *, id> *)params;

- (UIImage *)filterWithName:(NSString *)name parameters:(NSDictionary<NSString *, id> *)params createCGImage:(BOOL)flag;
- (UIImage *)filterWithName:(NSString *)name parameters:(NSDictionary<NSString *, id> *)params;
- (UIImage *)filterWithName:(NSString *)name;

@end

@interface NSData (CoreImage)

- (UIImage *)qrCode:(NSString *)inputCorrectionLevel;

@end
