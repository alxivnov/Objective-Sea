//
//  VKItem.m
//  Ringo
//
//  Created by Alexander Ivanov on 21.10.15.
//  Copyright © 2015 Alexander Ivanov. All rights reserved.
//

#import "VKItem.h"

@interface VKItem ()
@property (strong, nonatomic) NSDictionary *dictionary;
@end

@implementation VKItem

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
	self = [super init];

	if (self)
		self.dictionary = dictionary;

	return self;
}

- (NSString *)description {
	return self.dictionary.description;
}

- (NSInteger)ID {
	return [self.dictionary[@"id"] integerValue];
}

- (NSURL *)url {
	NSString *screenName = self.dictionary[VK_PARAM_SCREEN_NAME];
	NSNumber *ID = self.dictionary[VK_PARAM_ID];
	NSString *url = screenName.length ? [NSString stringWithFormat:@"https://vk.com/%@", screenName] : ID.integerValue ? [NSString stringWithFormat:@"https://vk.com/id%ld", labs(ID.integerValue)] : Nil;
	return url ? [NSURL URLWithString:url] : Nil;
}

@end

#define VK_KEY_ARTIST @"artist"
#define VK_KEY_TITLE @"title"
#define VK_KEY_DURATION @"duration"
#define VK_KEY_URL @"url"

#define VK_KEY_ID @"id"
#define VK_KEY_OWNER_ID @"owner_id"

@implementation VKAudioItem

__synthesize(NSURL *, assetURL, [NSURL URLWithString:self.dictionary[VK_KEY_URL]])

- (NSString *)artist {
	return self.dictionary[VK_KEY_ARTIST];
}

- (NSString *)title {
	return self.dictionary[VK_KEY_TITLE];
}

- (NSTimeInterval)duration {
	return [self.dictionary[VK_KEY_DURATION] longValue];
}

- (NSString *)attachmentString {
	return [NSString stringWithFormat:@"audio%@_%@", self.dictionary[VK_KEY_OWNER_ID], self.dictionary[VK_KEY_ID]];
}
/*
 - (NSString *)description {
	return [NSString stringWithFormat:@"%@ - %@ (%@)", self.artist, self.title, @(self.duration)];
 }
*/
@end

#define VK_KEY_FIRST_NAME @"first_name"
#define VK_KEY_LAST_NAME @"last_name"
#define VK_KEY_COUNTERS @"counters"
#define VK_KEY_FRIENDS @"friends"
#define VK_KEY_SEX @"sex"

@implementation VKUserItem

- (NSString *)firstName {
	return self.dictionary[VK_KEY_FIRST_NAME];
}

- (NSString *)lastName {
	return self.dictionary[VK_KEY_LAST_NAME];
}

- (NSString *)fullName {
	return [[NSArray arrayWithObject:self.firstName withObject:self.lastName withObject:Nil] componentsJoinedByString:STR_SPACE];
}

- (NSURL *)photo50 {
	return [NSURL URLWithString:self.dictionary[VK_PARAM_PHOTO_50]];
}

- (NSInteger)friendsCount {
	return [self.dictionary[VK_KEY_COUNTERS][VK_KEY_FRIENDS] integerValue];
}

- (NSInteger)sex {
	return [self.dictionary[VK_KEY_SEX] integerValue];
}

@end

#define VK_KEY_TEXT @"text"
#define VK_KEY_ATTACHMENTS @"attachments"
#define VK_KEY_AUDIO @"audio"
#define VK_KEY_PHOTO @"photo"
#define VK_KEY_PHOTO_75 @"photo_75"
#define VK_KEY_PHOTO_130 @"photo_130"
#define VK_KEY_LINK @"link"
#define VK_KEY_URL @"url"

#define VK_KEY_LIKES @"likes"
#define VK_KEY_COUNT @"count"

@implementation VKWallItem

- (NSString *)text {
	return self.dictionary[VK_KEY_TEXT];
}

__synthesize(NSArray<NSDictionary *> *, attachments, self.dictionary[VK_KEY_ATTACHMENTS])

__synthesize(NSArray<VKAudioItem *> *, audioItems, [self.attachments map:^id(NSDictionary *obj) {
	NSDictionary *audio = obj[VK_KEY_AUDIO];
	NSString *url = audio[VK_KEY_URL];
	return url.length ? [[VKAudioItem alloc] initWithDictionary:audio] : Nil;
}])

__synthesize(NSArray<NSURL *> *, photoURLs, [self.attachments map:^id(NSDictionary *obj) {
	NSDictionary *photo = obj[VK_KEY_PHOTO];
	NSString *url = photo[VK_KEY_PHOTO_75];
	return url ? [NSURL URLWithString:url] : Nil;
}])

__synthesize(NSArray<NSURL *> *, linkURLs, [self.attachments map:^id(NSDictionary *obj) {
	NSDictionary *link = obj[VK_KEY_LINK];
	NSString *url = link[VK_KEY_URL];
	return url ? [NSURL URLWithString:url] : Nil;
}])

__synthesize(NSNumber *, likesCount, [[self.dictionary objectForKey:VK_KEY_LIKES] objectForKey:VK_KEY_COUNT])

- (NSString *)description {
	return self.text;
}

@end
