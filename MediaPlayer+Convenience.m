//
//  MediaPlayer+Convenience.m
//  Ringtonic
//
//  Created by Alexander Ivanov on 15.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "MediaPlayer+Convenience.h"

@implementation MPMediaItem (Convenience)

- (NSUInteger)year {
	NSUInteger year = [[self valueForProperty:@"year"] unsignedIntegerValue];

	return year ? year : [self.releaseDate componentValue:NSCalendarUnitYear];
}

@end

@implementation MPMediaItemArtwork (Convenience)

- (UIImage *)image {
	UIScreen *screen = [UIScreen mainScreen];
	CGFloat size = fmax(screen.bounds.size.width, screen.bounds.size.height);
	return [self imageWithSize:CGSizeMake(size, size)];
}

- (void)fetchImage:(void(^)(UIImage *image))handler {
	if (!handler)
		return;

	id catalog = ret_(self, tryGetValueForKey:, @"_catalog");
	id token = ret_(catalog, tryGetValueForKey:, @"_token");
	id url = ret_(token, tryGetValueForKey:, @"_fetchableArtworkToken");

	[[NSURL URLWithString:url] cache:^(NSURL *cachedURL) {
		handler([UIImage imageWithContentsOfURL:cachedURL]);
	}];
}

@end

@implementation MPMediaQuery (Convenience)

+ (instancetype)createWithComparisonType:(MPMediaPredicateComparison)comparisonType predicates:(NSDictionary *)predicates {
	NSMutableSet *set = [NSMutableSet set];

	for (NSString *key in predicates)
		[set addObject:[MPMediaPropertyPredicate predicateWithValue:predicates[key] forProperty:key comparisonType:comparisonType]];

	return [[self alloc] initWithFilterPredicates:set];
}

+ (instancetype)createWithComparisonType:(MPMediaPredicateComparison)comparisonType artist:(NSString *)artist album:(NSString *)album title:(NSString *)title {
	NSMutableDictionary *predicates = [NSMutableDictionary dictionaryWithCapacity:3];

	if (artist.length)
		predicates[MPMediaItemPropertyArtist] = artist;
	if (album.length)
		predicates[MPMediaItemPropertyAlbumTitle] = album;
	if (title.length)
		predicates[MPMediaItemPropertyTitle] = title;

	return [self createWithComparisonType:comparisonType predicates:predicates];
}

@end

@implementation MPMusicPlayerController (Convenience)

- (BOOL)isPlaying {
	return self.playbackState == MPMusicPlaybackStatePlaying;
}

- (void)playWithCompletionHandler:(void (^)(BOOL))completionHandler {
	[self prepareToPlayWithCompletionHandler:^(NSError * _Nullable error) {
		[self play];

		if (completionHandler)
			completionHandler(error == Nil);

		[error log:@"prepareToPlayWithCompletionHandler:"];
	}];
}

- (void)playItem:(MPMediaItem *)item startTime:(NSTimeInterval)startTime endTime:(NSTimeInterval)endTime completionHandler:(void (^)(BOOL))completionHandler {
	if (!item)
		return;

	MPMediaItemCollection *collection = [MPMediaItemCollection collectionWithItems:@[ item ]];
	MPMusicPlayerMediaItemQueueDescriptor *descriptor = [[MPMusicPlayerMediaItemQueueDescriptor alloc] initWithItemCollection:collection];
	if (startTime)
		[descriptor setStartTime:startTime forItem:item];
	if (endTime)
		[descriptor setEndTime:endTime forItem:item];
	[self setQueueWithDescriptor:descriptor];
	[self prepareToPlayWithCompletionHandler:^(NSError * _Nullable error) {
		self.currentPlaybackTime = startTime;

		[self play];

		if (completionHandler)
			completionHandler(error == Nil);

		[error log:@"prepareToPlayWithCompletionHandler:"];
	}];
}

- (void)playStoreID:(NSString *)storeID startTime:(NSTimeInterval)startTime endTime:(NSTimeInterval)endTime completionHandler:(void (^)(MPMediaItem *))completionHandler {
	if (!storeID)
		return;
/*
	 self.nowPlayingItem = Nil;

	 [self setQueueWithStoreIDs:@[ storeID ]];

	 [self prepareToPlay];
	 for (NSUInteger index = 0; index < 10 && !self.nowPlayingItem; index++)
	 [NSThread sleepForTimeInterval:0.1];

	 self.currentPlaybackTime = startTime;
	 [self play];
*/
	MPMusicPlayerStoreQueueDescriptor *descriptor = [[MPMusicPlayerStoreQueueDescriptor alloc] initWithStoreIDs:@[ storeID ]];
	if (startTime)
		[descriptor setStartTime:startTime forItemWithStoreID:storeID];
	if (endTime)
		[descriptor setEndTime:endTime forItemWithStoreID:storeID];
	[self setQueueWithDescriptor:descriptor];
	[self prepareToPlayWithCompletionHandler:^(NSError * _Nullable error) {
		self.currentPlaybackTime = startTime;

		[self play];

		if (completionHandler)
			completionHandler(self.nowPlayingItem);

		[error log:@"prepareToPlayWithCompletionHandler:"];
	}];
}

- (void)beginGeneratingPlaybackNotificationsForObserver:(id)observer selector:(SEL)selector {
	if (observer && selector)
		[[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:self];

	[self beginGeneratingPlaybackNotifications];
}

- (void)endGeneratingPlaybackNotificationsForObserver:(id)observer {
	[self endGeneratingPlaybackNotifications];

	if (observer)
		[[NSNotificationCenter defaultCenter] removeObserver:observer name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:self];
}

@end

@implementation MPMediaPicker

- (void)performCompletion:(MPMediaItemCollection *)mediaItemCollection {
	__weak MPMediaPicker *__self = self;
	if (self.completion)
		self.completion(__self, mediaItemCollection);
}

- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
	[self dismissViewControllerAnimated:YES completion:Nil];

	[self performCompletion:mediaItemCollection];
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
	[self dismissViewControllerAnimated:YES completion:Nil];

	[self performCompletion:Nil];
}

- (instancetype)initWithMediaTypes:(MPMediaType)mediaTypes {
	self = [super initWithMediaTypes:mediaTypes];

	if (self)
		self.delegate = self;

	return self;
}

@end

@implementation UIViewController (MPMediaPickerController)

- (MPMediaPicker *)presentMediaPicker:(MPMediaType)types showsCloudItems:(BOOL)showsCloudItems completion:(void(^)(MPMediaPicker *sender, MPMediaItemCollection *items))completion from:(id)source {
	MPMediaPicker *picker = [[MPMediaPicker alloc] initWithMediaTypes:types];
	picker.completion = completion;
	picker.showsCloudItems = showsCloudItems;

	return [self popoverViewController:picker from:source] ? picker : Nil;
}

- (MPMediaPickerController *)presentMediaPicker:(MPMediaType)types completion:(void(^)(MPMediaPickerController *sender, MPMediaItemCollection *items))completion fromView:(UIView *)source {
	return [self presentMediaPicker:types showsCloudItems:NO completion:completion from:source];
}

- (MPMediaPickerController *)presentMediaPicker:(MPMediaType)types completion:(void(^)(MPMediaPickerController *sender, MPMediaItemCollection *items))completion fromButton:(UIBarButtonItem *)source {
	return [self presentMediaPicker:types showsCloudItems:NO completion:completion from:source];
}

- (MPMediaPickerController *)presentMediaPicker:(MPMediaType)types completion:(void(^)(MPMediaPickerController *sender, MPMediaItemCollection *items))completion {
	return [self presentMediaPicker:types showsCloudItems:NO completion:completion from:Nil];
}

@end
