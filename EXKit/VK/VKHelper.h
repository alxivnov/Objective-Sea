//
//  VKHelper.h
//  Ringo
//
//  Created by Alexander Ivanov on 29.08.15.
//  Copyright (c) 2015 Alexander Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "VKHelperInternal.h"

#import "NSArray+Convenience.h"
#import "NSObject+Convenience.h"

@interface VKHelper : VKHelperInternal

+ (VKRequest *)isMember:(NSUInteger)userID ofGroup:(NSUInteger)groupID handler:(void(^)(BOOL isMember))handler;
+ (VKRequest *)joinGroup:(NSUInteger)ID handler:(void(^)(BOOL success))handler;

+ (VKRequest *)searchNews:(NSString *)text handler:(void(^)(NSArray<VKWallItem *> *items))handler;

//+ (VKRequest *)searchAudio:(NSString *)text handler:(void(^)(NSArray<VKAudioItem *> *items))handler;
//+ (VKRequest *)getAudio:(void(^)(NSArray<VKAudioItem *> *items))handler;

+ (VKRequest *)postMessage:(NSString *)message attachments:(NSArray *)attachments ownerID:(NSInteger)ownerID handler:(void (^)(NSUInteger postID))handler;
+ (VKRequest *)getPosts:(NSUInteger)ID offset:(NSUInteger)offset count:(NSUInteger)count query:(NSString *)query handler:(void (^)(NSArray<VKWallItem *> *items))handler;

+ (VKRequest *)uploadWallPhoto:(UIImage *)image handler:(void (^)(VKPhoto *photo))handler;

+ (VKRequest *)getUsers:(NSArray *)IDs fields:(NSArray<NSString *> *)fields handler:(void(^)(NSArray<VKUser *> *users))handler;

+ (VKRequest *)getGroups:(NSUInteger)ID fields:(NSArray<NSString *> *)fields filter:(NSArray<NSString *> *)filter handler:(void(^)(NSArray<VKGroup *> *groups))handler;
+ (VKRequest *)getGroupsByIDs:(NSArray<NSNumber *> *)IDs fields:(NSArray<NSString *> *)fields handler:(void(^)(NSArray<VKGroup *> *groups))handler;
+ (VKRequest *)getFriends:(NSUInteger)ID fields:(NSArray<NSString *> *)fields handler:(void(^)(NSArray<VKUser *> *groups))handler;

@end
