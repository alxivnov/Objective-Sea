//
//  FBSDKCoreKit+Convenience.h
//  Crowd Guard
//
//  Created by Alexander Ivanov on 07.04.17.
//  Copyright © 2017 Alexander Ivanov. All rights reserved.
//

#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import "NSURLSession+Convenience.h"
#import "UIImage+Convenience.h"

@interface FBNode : NSObject
@property (strong, nonatomic, readonly) NSDictionary *fields;
- (instancetype)initWithFields:(NSDictionary *)fields;
+ (instancetype)nodeWithFields:(NSDictionary *)fields;

+ (NSArray *)nodesFromArray:(NSArray *)array;
@end

@interface FBUser : FBNode
@property (strong, nonatomic, readonly) NSString *ID;
@property (strong, nonatomic, readonly) NSString *name;
@property (strong, nonatomic, readonly) NSURL *picture;
@property (assign, nonatomic, readonly) BOOL isSilhouette;

- (void)pictureWithScale:(CGFloat)scale completion:(void (^)(UIImage *picture))completion;
@end

@interface FBSDKGraphRequest (Convenience)

+ (instancetype)startRequestWithGraphPath:(NSString *)graphPath parameters:(NSDictionary *)parameters completion:(FBSDKGraphRequestHandler)completion;

+ (instancetype)requestProfile:(NSString *)userID completion:(void (^)(FBSDKProfile *profile))completion;
+ (instancetype)requestFriends:(NSString *)userID completion:(void (^)(NSArray<FBSDKProfile *> *friends))completion;

@end

@interface FBSDKProfile (Convenience)

+ (instancetype)profileWithDictionary:(NSDictionary *)dictionary;

- (NSURL *)imageForPictureMode:(FBSDKProfilePictureMode)mode size:(CGSize)size scale:(CGFloat)scale completion:(void (^)(UIImage *image))completion;

@end
