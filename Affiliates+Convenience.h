//
//  Affiliates+Convenience.h
//  Ringtonic
//
//  Created by Alexander Ivanov on 14.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSArray+Convenience.h"
#import "NSBundle+Convenience.h"
#import "NSObject+Convenience.h"
#import "NSURLSession+Convenience.h"

#define SKStoreProductParameterAffiliateToken_IOS_8_0 @"at"
#define SKStoreProductParameterCampaignToken_IOS_8_0 @"ct"
#define SKStoreProductParameterProviderToken_IOS_8_3 @"pt"

@interface NSDictionary (Affiliates)

+ (instancetype)dictionaryWithProvider:(NSString *)provider affiliate:(NSString *)affiliate campaign:(NSString *)campaign;
+ (instancetype)dictionaryWithProvider:(NSString *)provider affiliate:(NSString *)affiliate;

@end

@interface NSURL (Affiliates)

+ (NSURL *)URLForMediaType:(NSUInteger)mediaType identifier:(NSUInteger)identifier affiliateInfo:(NSDictionary *)affiliateInfo;
+ (NSURL *)URLForMobileAppWithIdentifier:(NSUInteger)identifier affiliateInfo:(NSDictionary *)affiliateInfo;

@end

#define kWrapperTypeTrack @"track"
#define kWrapperTypeCollection @"collection"
#define kWrapperTypeArtist @"artist"

#define kExplicitnessExplicit @"explicit"
#define kExplicitnessCleaned @"cleaned"
#define kExplicitnessNotExplicit @"notExplicit"

#define kKindBook @"book"
#define kKindAlbum @"album"
#define kKindCoachedAudio @"coached-audio"
#define kKindFeatureMovie @"feature-movie"
#define kKindInteractiveBooklet @"interactive-booklet"
#define kKindMusicVideo @"music-video"
#define kKindPDF @"pdf"
#define kKindPodcast @"podcast"
#define kKindPodcastEpisode @"podcast-episode"
#define kKindSoftwarePackage @"software-package"
#define kKindSong @"song"
#define kKindTVEpisode @"tv-episode"
#define kKindArtist @"artist"

@interface AFMediaItem : NSObject

@property (strong, nonatomic, readonly) NSDictionary *dictionary;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@property (strong, nonatomic, readonly) NSString *wrapperType;
@property (strong, nonatomic, readonly) NSString *explicitness;
@property (strong, nonatomic, readonly) NSString *kind;
@property (strong, nonatomic, readonly) NSNumber *trackId;
@property (strong, nonatomic, readonly) NSNumber *artistId;
@property (strong, nonatomic, readonly) NSNumber *collectionId;
@property (strong, nonatomic, readonly) NSString *trackName;
@property (strong, nonatomic, readonly) NSString *artistName;
@property (strong, nonatomic, readonly) NSString *collectionName;
@property (strong, nonatomic, readonly) NSString *censoredName;
@property (strong, nonatomic, readonly) NSURL *artworkUrl100;
@property (strong, nonatomic, readonly) NSURL *artworkUrl60;
@property (strong, nonatomic, readonly) NSURL *viewUrl;
@property (strong, nonatomic, readonly) NSURL *previewUrl;
@property (assign, nonatomic, readonly) NSTimeInterval trackTime;

@property (assign, nonatomic, readonly) BOOL isTrack;
@property (assign, nonatomic, readonly) BOOL isCollection;
@property (assign, nonatomic, readonly) BOOL isArtist;

#define URL_LOOKUP @"https://itunes.apple.com/lookup"
#define URL_SEARCH @"https://itunes.apple.com/search"

#define KEY_ID @"id"

#define KEY_TERM @"term"		// required
#define KEY_COUNTRY @"country"	// required
#define KEY_MEDIA @"media"
#define KEY_ENTITY @"entity"
#define KEY_ATTRIBUTE @"attribute"
//#define KEY_CALLBACK @"callback"
#define KEY_LIMIT @"limit"
#define KEY_LANG @"lang"
#define KEY_VERSION @"version"
#define KEY_EXPLICIT @"explicit"

#define kMediaMovie @"movie"
#define kMediaPodcast @"podcast"
#define kMediaMusic @"music"
#define kMediaMusicVideo @"musicVideo"
#define kMediaAudiobook @"audiobook"
#define kMediaShortFilm @"shortFilm"
#define kMediaTVShow @"tvShow"
#define kMediaSoftware @"software"
#define kMediaEbook @"ebook"
#define kMediaAll @"all"

#define kEntityMusicArtist @"musicArtist"
#define kEntityMusicTrack @"musicTrack"
#define kEntityAlbum @"album"
#define kEntityMusicVideo @"musicVideo"
#define kEntityMix @"mix"
#define kEntitySong @"song"

#define kAttributeMixTerm @"mixTerm"
#define kAttributeGenreIndex @"genreIndex"
#define kAttributeArtistTerm @"artistTerm"
#define kAttributeComposerTerm @"composerTerm"
#define kAttributeAlbumTerm @"albumTerm"
#define kAttributeRatingIndex @"ratingIndex"
#define kAttributeSongTerm @"songTerm"

+ (BOOL)lookup:(NSUInteger)ID handler:(void(^)(NSArray<AFMediaItem *> *results))handler;
+ (BOOL)search:(NSString *)tearm handler:(void(^)(NSArray<AFMediaItem *> *results))handler;

@end
