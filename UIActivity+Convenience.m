//
//  UIActivity+Convenience.m
//  Ringtonic
//
//  Created by Alexander Ivanov on 14.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "UIActivity+Convenience.h"

@interface UIWebActivity ()
@property (strong, nonatomic) NSDictionary *query;
@end

@implementation UIWebActivity

- (UIImage *)activityImage {
	return [UIImage imageNamed:[[self activityTitle] stringByAppendingString:[UIApplication sharedApplication].iPad ? @"-76" : @"-60"]];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
	return [activityItems any:^BOOL(id item) {
		return [[self class] canPerform:item];
	}];
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
	self.query = [[self class] prepareQuery:activityItems];
}

+ (UIActivityCategory)activityCategory {
	return UIActivityCategoryShare;
}

- (void)performActivity {
	[UIApplication openURL:[[[self class] activityURL] URLByAppendingQueryDictionary:self.query]];

	[self activityDidFinish:YES];
}

+ (NSURL *)activityURL {
	return Nil;																// abstract
}

+ (NSString *)activityURLKey {
	return Nil;																// abstract
}

+ (BOOL)canPerform:(id)activityItem {
	return [cls(NSURL, activityItem) isWebAddress];							// abstract
}

+ (NSDictionary *)prepareQuery:(NSArray *)activityItems {
	NSMutableDictionary *dictionary = [NSMutableDictionary new];
	dictionary[[self activityURLKey]] = [activityItems firstObject:^BOOL(id item) {
		return [cls(NSURL, item) isWebAddress];
	}] ?: self.defaultURL;
	return dictionary;														// abstract
}

__static(NSMutableDictionary *, defaultURLs, [NSMutableDictionary new])

+ (NSURL *)defaultURL {
	return [self defaultURLs][[[self class] description]];
}

+ (void)setDefaultURL:(NSURL *)url {
	[self defaultURLs][[[self class] description]] = url;
}

__static(NSMutableDictionary *, hashtagArrs, [NSMutableDictionary new])

+ (NSArray<NSString *> *)hashtags {
	return [self hashtagArrs][[[self class] description]];
}

+ (void)setHashtags:(NSArray<NSString *> *)hashtags {
	[self hashtagArrs][[[self class] description]] = hashtags;
}

+ (NSArray<__kindof UIWebActivity *> *)webActivities:(NSString *)facebookAppID {
	if (facebookAppID.length)
		[FBWebActivity setAppID:facebookAppID];

	NSMutableArray *activities = [NSMutableArray arrayWithCapacity:4];

	if ([NSBundle isPreferredLocalization:LNG_RU])
		[activities addObject:[VKWebActivity new]];

//	if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
		[activities addObject:[FBWebActivity new]];

//	if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
		[activities addObject:[TWWebActivity new]];

	[activities addObject:[GPWebActivity new]];

	return activities;
}

@end

@implementation FBWebActivity

- (NSString *)activityType {
	return FBActivityType;
}

- (NSString *)activityTitle {
	return FBActivityTitle;
}

+ (NSURL *)activityURL {
	return [NSURL URLWithString:FBActivityURL];
}

+ (NSString *)activityURLKey {
	return FBKeyURL;
}

+ (BOOL)canPerform:(id)activityItem {
	return [super canPerform:activityItem] && self.appID;
}

+ (NSDictionary *)prepareQuery:(NSArray *)activityItems {
	NSMutableDictionary *dictionary = (NSMutableDictionary *)[super prepareQuery:activityItems];
	
	dictionary[FBKeyAppID] = self.appID;
	dictionary[FBKeyRedirect] = FBKeyRedirect;

	return dictionary;
}

__class(NSString *, appID, setAppID)

@end

@implementation GPWebActivity

- (NSString *)activityType {
	return GPActivityType;
}

- (NSString *)activityTitle {
	return GPActivityTitle;
}

+ (NSURL *)activityURL {
	return [NSURL URLWithString:GPActivityURL];
}

+ (NSString *)activityURLKey {
	return GPKeyURL;
}

@end

@implementation TWWebActivity

- (NSString *)activityType {
	return TWActivityType;
}

- (NSString *)activityTitle {
	return TWActivityTitle;
}

+ (NSURL *)activityURL {
	return [NSURL URLWithString:TWActivityURL];
}

+ (NSString *)activityURLKey {
	return TWKeyURL;
}

+ (BOOL)canPerform:(id)activityItem {
	return [super canPerform:activityItem] || [activityItem isKindOfClass:[NSString class]];
}

+ (NSDictionary *)prepareQuery:(NSArray *)activityItems {
	NSMutableDictionary *dictionary = (NSMutableDictionary *)[super prepareQuery:activityItems];

	NSString *text = [activityItems firstObject:^BOOL(id obj) {
		return [obj isKindOfClass:[NSString class]];
	}];
	NSArray *hashtags = [self.hashtags map:^id(NSString *obj) {
		NSString *hashtag = [obj hasPrefix:STR_NUMBER] ? obj : [NSString stringWithFormat:@"#%@", obj];
		return [text rangeOfString:hashtag].length ? Nil : obj;
	}];

	dictionary[TWKeyText] = text.length ? text : Nil;
	dictionary[TWKeyHashtags] = hashtags.count ? [hashtags componentsJoinedByString:STR_SPACE] : Nil;

	return dictionary;
}

@end

@implementation VKWebActivity

- (NSString *)activityType {
	return VKActivityType;
}

- (NSString *)activityTitle {
	return VKActivityTitle;
}

+ (NSURL *)activityURL {
	return [NSURL URLWithString:VKActivityURL];
}

+ (NSString *)activityURLKey {
	return VKKeyURL;
}

+ (BOOL)canPerform:(id)activityItem {
	return [super canPerform:activityItem] || [activityItem isKindOfClass:[NSString class]];
}

+ (NSDictionary *)prepareQuery:(NSArray *)activityItems {
	NSMutableDictionary *dictionary = (NSMutableDictionary *)[super prepareQuery:activityItems];

	NSString *title = [activityItems firstObject:^BOOL(id obj) {
		return [obj isKindOfClass:[NSString class]];
	}];
	NSArray *hashtags = [self.hashtags map:^id(NSString *obj) {
		NSString *hashtag = [obj hasPrefix:STR_NUMBER] ? obj : [NSString stringWithFormat:@"#%@", obj];
		return [title rangeOfString:hashtag].length ? Nil : hashtag;
	}];

	dictionary[VKKeyTitle] = title.length ? title : Nil;
	dictionary[VKKeyDescription] = hashtags.count ? [hashtags componentsJoinedByString:STR_SPACE] : [NSBundle bundleDisplayName];
	
	return dictionary;
}

@end
