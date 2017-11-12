//
//  VKItem.h
//  Ringo
//
//  Created by Alexander Ivanov on 21.10.15.
//  Copyright © 2015 Alexander Ivanov. All rights reserved.
//

#import "NSArray+Convenience.h"
#import "NSObject+Convenience.h"

#define VK_METHOD_AUDIO_GET @"audio.get"				// audio
#define VK_METHOD_AUDIO_SEARCH @"audio.search"			// audio
#define VK_METHOD_FRIENDS_GET @"friends.get"
#define VK_METHOD_GROUPS_IS_MEMBER @"groups.isMember"
#define VK_METHOD_GROUPS_GET @"groups.get"				//
#define VK_METHOD_GROUPS_GET_BY_ID @"groups.getById"
#define VK_METHOD_GROUPS_JOIN @"groups.join"			// groups
#define VK_METHOD_NEWSFEED_SEARCH @"newsfeed.search"
#define VK_METHOD_USERS_GET @"users.get"
#define VK_METHOD_WALL_GET @"wall.get"
#define VK_METHOD_WALL_SEARCH @"wall.search"
#define VK_METHOD_WALL_POST @"wall.post"				// wall

#define VK_HTTP_METHOD_GET @"GET"

#define VK_PARAM_Q @"q"
#define VK_PARAM_QUERY @"query"
#define VK_PARAM_V @"v"
#define VK_PARAM_ACCESS_TOKEN @"access_token"
#define VK_PARAM_ID @"id"
#define VK_PARAM_GROUP_ID @"group_id"
#define VK_PARAM_GROUP_IDS @"group_ids"
#define VK_PARAM_OWNER_ID @"owner_id"
#define VK_PARAM_MESSAGE @"message"
#define VK_PARAM_ATTACHMENTS @"attachments"
#define VK_PARAM_USER_ID @"user_id"
#define VK_PARAM_USER_IDS @"user_ids"
#define VK_PARAM_FIRST_NAME @"first_name"
#define VK_PARAM_LAST_NAME @"last_name"
#define VK_PARAM_EXTENDED @"extended"
#define VK_PARAM_FILTER @"filter"
#define VK_PARAM_OFFSET @"offset"
#define VK_PARAM_COUNT @"count"
#define VK_PARAM_ITEMS @"items"
#define VK_PARAM_POST_ID @"post_id"
#define VK_PARAM_FIELDS @"fields"
#define VK_PARAM_MEMBERS_COUNT @"members_count"
#define VK_PARAM_WALL_COMMENTS @"wall_comments"
#define VK_PARAM_COUNTERS @"counters"
#define VK_PARAM_FRIENDS @"friends"
#define VK_PARAM_PHOTO_50 @"photo_50"
#define VK_PARAM_CAN_POST @"can_post"
#define VK_PARAM_SCREEN_NAME @"screen_name"
#define VK_PARAM_MEMBER @"member"
#define VK_PARAM_SEX @"sex"
#define VK_PARAM_NAME_CASE @"name_case"

#define VK_PARAM_FILTER_ADMIN @"admin"
#define VK_PARAM_FILTER_EDITOR @"editor"
#define VK_PARAM_FILTER_MODER @"moder"
#define VK_PARAM_FILTER_GROUPS @"groups"
#define VK_PARAM_FILTER_PUBLICS @"publics"
#define VK_PARAM_FILTER_EVENTS @"events"

@interface VKItem : NSObject

@property (strong, nonatomic, readonly) NSDictionary *dictionary;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@property (assign, nonatomic, readonly) NSInteger ID;

@property (strong, nonatomic, readonly) NSURL *url;

@end

@interface VKAudioItem : VKItem

@property (strong, nonatomic, readonly) NSURL *assetURL;
@property (strong, nonatomic, readonly) NSString *artist;
@property (strong, nonatomic, readonly) NSString *title;
@property (assign, nonatomic, readonly) NSTimeInterval duration;

@property (strong, nonatomic, readonly) NSString *attachmentString;

@end

@interface VKUserItem : VKItem

@property (strong, nonatomic, readonly) NSString *firstName;
@property (strong, nonatomic, readonly) NSString *lastName;
@property (strong, nonatomic, readonly) NSString *fullName;
@property (strong, nonatomic, readonly) NSURL *photo50;
@property (assign, nonatomic, readonly) NSInteger friendsCount;
@property (assign, nonatomic, readonly) NSInteger sex;

@end

@interface VKWallItem : VKItem

@property (strong, nonatomic, readonly) NSString *text;

@property (strong, nonatomic, readonly) NSArray<NSDictionary *> *attachments;
@property (strong, nonatomic, readonly) NSArray<VKAudioItem *> *audioItems;
@property (strong, nonatomic, readonly) NSArray<NSURL *> *photoURLs;
@property (strong, nonatomic, readonly) NSArray<NSURL *> *linkURLs;

@property (strong, nonatomic, readonly) NSNumber *likesCount;

@end
