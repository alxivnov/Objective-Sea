//
//  Affiliates+Convenience.m
//  Ringtonic
//
//  Created by Alexander Ivanov on 14.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "Affiliates+Convenience.h"

// http://www.apple.com/itunes/affiliates/resources/documentation/itunes-store-web-service-search-api.html

#define KEY_MEDIA_TYPE @"mt"
#define VAL_MEDIA_TYPE_PODCAST 2
#define VAL_MEDIA_TYPE_APP 8
#define VAL_MEDIA_TYPE_BOOK 11
#define URL_MEDIA_TYPE_APP @"https://itunes.apple.com/app/apple-store/id"

@implementation NSDictionary (Affiliates)

+ (instancetype)dictionaryWithProvider:(NSString *)provider affiliate:(NSString *)affiliate campaign:(NSString *)campaign {
	NSMutableDictionary *query = [NSMutableDictionary new];

	if (provider.length)
		query[SKStoreProductParameterProviderToken_IOS_8_3] = provider;
	if (affiliate.length)
		query[SKStoreProductParameterAffiliateToken_IOS_8_0] = affiliate;
	if (campaign.length)
		query[SKStoreProductParameterCampaignToken_IOS_8_0] = campaign;

	return query;
}

+ (instancetype)dictionaryWithProvider:(NSString *)provider affiliate:(NSString *)affiliate {
	return [self dictionaryWithProvider:provider affiliate:affiliate campaign:[NSBundle bundleDisplayName]];
}

@end

@implementation NSURL (Affiliates)

+ (NSURL *)URLForMediaType:(NSUInteger)mediaType identifier:(NSUInteger)identifier affiliateInfo:(NSDictionary *)affiliateInfo {
	NSMutableDictionary *query = affiliateInfo ? [affiliateInfo mutableCopy] : [NSMutableDictionary new];
	query[KEY_MEDIA_TYPE] = @(mediaType);

	return [[NSURL URLWithString:[URL_MEDIA_TYPE_APP stringByAppendingString:[@(identifier) description]]] URLByAppendingQueryDictionary:query];
}

+ (NSURL *)URLForMobileAppWithIdentifier:(NSUInteger)identifier affiliateInfo:(NSDictionary *)affiliateInfo {
	return [self URLForMediaType:VAL_MEDIA_TYPE_APP identifier:identifier affiliateInfo:affiliateInfo];
}

@end

#define KEY_WRAPPER_TYPE @"wrapperType"
#define KEY_EXPLICITNESS @"Explicitness"			// *
#define KEY_KIND @"kind"
#define KEY_TRACK_ID @"trackId"
#define KEY_ARTIST_ID @"artistId"
#define KEY_COLLECTION_ID @"collectionId"
#define KEY_TRACK_NAME @"trackName"
#define KEY_ARTIST_NAME @"artistName"
#define KEY_COLLECTION_NAME @"collectionName"
#define KEY_CENSORED_NAME @"CensoredName"			// *
#define KEY_ARTWORK_URL_100 @"artworkUrl100"
#define KEY_ARTWORK_URL_60 @"artworkUrl60"
#define KEY_VIEW_URL @"ViewUrl"						// *
#define KEY_PREVIEW_URL @"previewUrl"
#define KEY_TRACK_TIME_MILLIS @"trackTimeMillis"

@interface AFMediaItem ()
@property (strong, nonatomic) NSDictionary *dictionary;
@end

@implementation AFMediaItem

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
	self = [super init];

	if (self)
		self.dictionary = dictionary;

	return self;
}

- (NSString *)wrapperType {
	return self.dictionary[KEY_WRAPPER_TYPE];
}

- (NSString *)explicitness {
	return self.dictionary[[self.wrapperType stringByAppendingString:KEY_EXPLICITNESS]];
}

- (NSString *)kind {
	return self.dictionary[KEY_KIND];
}

- (NSNumber *)trackId {
	return self.dictionary[KEY_TRACK_ID];
}

- (NSNumber *)artistId {
	return self.dictionary[KEY_ARTIST_ID];
}

- (NSNumber *)collectionId {
	return self.dictionary[KEY_COLLECTION_ID];
}

- (NSString *)trackName {
	return self.dictionary[KEY_TRACK_NAME];
}

- (NSString *)artistName {
	return self.dictionary[KEY_ARTIST_NAME];
}

- (NSString *)collectionName {
	return self.dictionary[KEY_COLLECTION_NAME];
}

- (NSString *)censoredName {
	return self.dictionary[[self.wrapperType stringByAppendingString:KEY_CENSORED_NAME]];
}

- (NSURL *)artworkUrl100 {
	return [NSURL URLWithString:self.dictionary[KEY_ARTWORK_URL_100]];
}

- (NSURL *)artworkUrl60 {
	return [NSURL URLWithString:self.dictionary[KEY_ARTWORK_URL_60]];
}

- (NSURL *)viewUrl {
	return [NSURL URLWithString:self.dictionary[[self.wrapperType stringByAppendingString:KEY_VIEW_URL]]];
}

- (NSURL *)previewUrl {
	return [NSURL URLWithString:self.dictionary[KEY_PREVIEW_URL]];
}

- (NSTimeInterval)trackTime {
	return [self.dictionary[KEY_TRACK_TIME_MILLIS] longValue] / 1000.0;
}

- (BOOL)isTrack {
	return [self.wrapperType isEqualToString:kWrapperTypeTrack];
}

- (BOOL)isCollection {
	return [self.wrapperType isEqualToString:kWrapperTypeCollection];
}

- (BOOL)isArtist {
	return [self.wrapperType isEqualToString:kWrapperTypeArtist];
}

- (NSString *)description {
	return self.trackName.length && self.artistName.length ? [@[ self.artistName, STR_HYPHEN, self.trackName ] componentsJoinedByString:STR_SPACE] : self.trackName.length ? self.trackName : self.artistName.length ? self.artistName : self.collectionName.length ? self.collectionName : STR_EMPTY;
}

- (NSString *)debugDescription {
	return [self.dictionary debugDescription];
}

#define KEY_RESULTS @"results"
#define KEY_RESULTS_COUNT @"resultsCount"

+ (void)sendAsynchronousRequestWithURL:(NSURL *)url handler:(void(^)(NSArray<AFMediaItem *> *))handler {
	if (!handler)
		return;

	[[NSURLSession sharedSession] dataTaskWithURL:url priority:NSURLSessionTaskPriorityHigh completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		[error log:@"sendAsynchronousRequest:"];

		NSError *jsonError = Nil;
		NSDictionary *json = data ? [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError] : Nil;
		[jsonError log:@"JSONObjectWithData:"];

		NSArray<AFMediaItem *> *results = json ? [json[KEY_RESULTS] map:^id(id obj) {
			return [[AFMediaItem alloc] initWithDictionary:obj];
		}] : Nil;
		handler(results);
	}];
}

+ (BOOL)lookup:(NSUInteger)ID handler:(void(^)(NSArray<AFMediaItem *> *))handler {
	if (!ID)
		return NO;

	NSDictionary *parameters = @{ KEY_ID : @(ID) };
	NSURL *url = [[NSURL URLWithString:URL_LOOKUP] URLByAppendingQueryDictionary:parameters];
	[self sendAsynchronousRequestWithURL:url handler:handler];

	return YES;
}

+ (BOOL)search:(NSString *)tearm handler:(void(^)(NSArray<AFMediaItem *> *))handler {
	if (!tearm.length)
		return NO;

	NSDictionary *parameters = @{ KEY_TERM : tearm, KEY_MEDIA : kMediaMusic, KEY_ENTITY : kEntitySong };
	NSURL *url = [[NSURL URLWithString:URL_SEARCH] URLByAppendingQueryDictionary:parameters];
	[self sendAsynchronousRequestWithURL:url handler:handler];

	return YES;
}

@end
