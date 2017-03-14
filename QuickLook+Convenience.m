//
//  QuickLook+Convenience.m
//  Guardian
//
//  Created by Alexander Ivanov on 16.12.16.
//  Copyright © 2016 NATEK. All rights reserved.
//

#import "QuickLook+Convenience.h"

#if TARGET_OS_IPHONE
@interface QLPreview ()
@property (strong, nonatomic) QLPreviewDataSource *previewDataSource;
@end

@implementation QLPreview
/*
- (UIImage *)previewController:(QLPreviewController *)controller transitionImageForPreviewItem:(id <QLPreviewItem>)item contentRect:(CGRect *)contentRect {
	return Nil;
}
*/
- (void)previewControllerWillDismiss:(QLPreviewController *)controller {
	if (self.willDismiss)
		self.willDismiss(self, self.previewDataSource.URLs.allKeys);
}

- (void)previewControllerDidDismiss:(QLPreviewController *)controller {
	if (self.didDismiss)
		self.didDismiss(self, self.previewDataSource.URLs.allKeys);
}

+ (instancetype)createWithURLs:(NSDictionary<NSURL *, NSString *> *)urls {
	if (![urls.allKeys any:^BOOL(id item) {
		return [QLPreviewController canPreviewItem:item];
	}])
		return Nil;

	QLPreview *preview = [QLPreview new];
	preview.previewDataSource = [[QLPreviewDataSource alloc] initWithURLs:urls];
	preview.dataSource = preview.previewDataSource;
	preview.delegate = preview;
	return preview;
}

+ (instancetype)createWithURL:(NSURL *)url {
	return [self createWithURLs:dic_(url, [NSNull null])];
}

- (IBAction)disableActionBarButtonItem:(UIBarButtonItem *)sender {
	sender.enabled = NO;
}

- (void)replaceActionBarButtonItem {
	if (!self.actionDisabled)
		return;

	UIBarButtonItem *item = self.navigationItem.rightBarButtonItem.enabled ? self.navigationItem.rightBarButtonItem : self.toolbarItems.count ? self.toolbarItems.firstObject : Nil;
	if (!item)
		return;

	item.target = self;
	item.action = @selector(disableActionBarButtonItem:);

	[self performSelector:@selector(replaceActionBarButtonItem) withObject:Nil afterDelay:0.1];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

	[self replaceActionBarButtonItem];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
	[super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

	[self replaceActionBarButtonItem];
}

@end
#endif

@interface QLPreviewItem : NSObject <QLPreviewItem>
@property (strong, nonatomic, readonly) NSURL *previewItemURL;
@property (strong, nonatomic, readonly) NSString *previewItemTitle;
@end

@implementation QLPreviewItem

- (instancetype)initWithURL:(NSURL *)url title:(NSString *)title {
	self = [self init];

	if (self) {
		_previewItemURL = url;
		_previewItemTitle = title;
	}

	return self;
}

@end

@interface QLPreviewDataSource ()
@property (strong, nonatomic) NSDictionary<NSURL *, NSString *> *URLs;
@end

@implementation QLPreviewDataSource

- (instancetype)initWithURLs:(NSDictionary<NSURL *,NSString *> *)URLs {
	self = [super init];

	if (self)
		self.URLs = URLs;

	return self;
}

- (instancetype)initWithURL:(NSURL *)URL {
	return [self initWithURLs:dic_(URL, [NSNull null])];
}

#if TARGET_OS_IPHONE
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
#else
- (NSInteger)numberOfPreviewItemsInPreviewPanel:(QLPreviewPanel *)panel {
#endif
	return self.URLs.count;
}

#if TARGET_OS_IPHONE
- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
#else
- (id<QLPreviewItem>)previewPanel:(QLPreviewPanel *)panel previewItemAtIndex:(NSInteger)index {
#endif
	NSURL *url = idx(self.URLs.allKeys, index);
	NSString *title = url ? self.URLs[url] : Nil;
	id <QLPreviewItem> item = [[QLPreviewItem alloc] initWithURL:url title:title.isNull ? Nil : title];
	return item;
}
		
@end

#if TARGET_OS_IPHONE
@implementation UIViewController (QuickLook)

- (void)presentPreviewWithURLs:(NSDictionary<NSURL *,NSString *> *)URLs animated:(BOOL)flag completion:(void (^)(void))completion {
	QLPreview *preview = [QLPreview createWithURLs:URLs];
	if (preview)
		[self presentViewController:preview animated:flag completion:completion];
}

@end

@implementation UINavigationController (QuickLook)

- (void)pushPreviewWithURLs:(NSDictionary<NSURL *,NSString *> *)URLs animated:(BOOL)animated {
	QLPreview *preview = [QLPreview createWithURLs:URLs];
	if (preview)
		[self pushViewController:preview animated:animated];

}

@end
#endif
