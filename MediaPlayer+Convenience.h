//
//  MediaPlayer+Convenience.h
//  Ringtonic
//
//  Created by Alexander Ivanov on 15.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>

#import "CoreGraphics+Convenience.h"
#import "NSCalendar+Convenience.h"
#import "NSURLSession+Convenience.h"
#import "UIImage+Convenience.h"
#import "UIViewController+Convenience.h"

@interface MPMediaItem (Convenience)

- (NSUInteger)year;

@end

@interface MPMediaItemArtwork (Convenience)

- (UIImage *)image;

- (void)fetchImage:(void(^)(UIImage *image))handler;

@end

@interface MPMediaQuery (Convenience)

+ (instancetype)createWithComparisonType:(MPMediaPredicateComparison)comparisonType predicates:(NSDictionary *)predicates;

+ (instancetype)createWithComparisonType:(MPMediaPredicateComparison)comparisonType artist:(NSString *)artist album:(NSString *)album title:(NSString *)title;

@end

@interface MPMusicPlayerController (Convenience)

@property (assign, nonatomic, readonly) BOOL isPlaying;

- (void)playItem:(MPMediaItem *)item startTime:(NSTimeInterval)startTime endTime:(NSTimeInterval)endTime completionHandler:(void (^)(BOOL success))completionHandler;
- (void)playStoreID:(NSString *)storeID startTime:(NSTimeInterval)startTime endTime:(NSTimeInterval)endTime completionHandler:(void (^)(MPMediaItem *nowPlayingItem))completionHandler;

- (void)beginGeneratingPlaybackNotificationsForObserver:(id)observer selector:(SEL)selector;
- (void)endGeneratingPlaybackNotificationsForObserver:(id)observer;

@end

@interface MPMediaPicker : MPMediaPickerController <MPMediaPickerControllerDelegate>

@property (copy, nonatomic) void(^completion)(MPMediaPicker *sender, MPMediaItemCollection *mediaItemCollection);

@end

@interface UIViewController (MPMediaPickerController)

- (MPMediaPickerController *)presentMediaPicker:(MPMediaType)types completion:(void(^)(MPMediaPickerController *sender, MPMediaItemCollection *items))completion fromView:(UIView *)source;
- (MPMediaPickerController *)presentMediaPicker:(MPMediaType)types completion:(void(^)(MPMediaPickerController *sender, MPMediaItemCollection *items))completion fromButton:(UIBarButtonItem *)source;
- (MPMediaPickerController *)presentMediaPicker:(MPMediaType)types completion:(void(^)(MPMediaPickerController *sender, MPMediaItemCollection *items))completion;

@end
