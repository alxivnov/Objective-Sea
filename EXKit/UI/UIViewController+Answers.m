//
//  UIViewController+Answers.m
//  Sleep Diary
//
//  Created by Alexander Ivanov on 16.03.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "UIViewController+Answers.h"

//#import <Crashlytics/Answers.h>

@implementation UIViewController (Answers)

static NSMutableDictionary<NSString *, NSDate *> *_viewControllers;

+ (NSMutableDictionary<NSString *, NSDate *> *)viewControllers {
	if (!_viewControllers)
		_viewControllers = [NSMutableDictionary new];
	
	return _viewControllers;
}

- (NSString *)loggingName {
	return Nil;
}

- (NSDictionary<NSString *,id> *)loggingCustomAttributes {
	return Nil;
}

- (void)startLogging {/*
	return;

	if (![self respondsToSelector:@selector(loggingName)])
		return;
	
	NSString *name = [self performSelector:@selector(loggingName)];
	if (!name.length)
		return;
	
	NSMutableDictionary *viewControllers = [[self class] viewControllers];
	viewControllers[name] = [NSDate date];
*/}

- (void)endLogging {/*
	if (![self respondsToSelector:@selector(loggingName)])
		return;
	
	NSString *name = [self performSelector:@selector(loggingName)];
	if (!name.length)
		return;
	
	NSMutableDictionary *viewControllers = [[self class] viewControllers];
	NSDate *date = viewControllers[name];
	viewControllers[name] = Nil;
	
//	NSLog(@"%@: %@", name, @(fabs([date timeIntervalSinceNow])));
	
	NSDictionary<NSString *, id> *attributes = [self loggingCustomAttributes];
	if (date) {
		NSMutableDictionary<NSString *, id> *mutableAttributes = attributes ? [attributes mutableCopy] : [NSMutableDictionary dictionaryWithCapacity:1];
		mutableAttributes[@"time"] = @(fabs([date timeIntervalSinceNow]));
		attributes = mutableAttributes;
	}
	[Answers logContentViewWithName:name contentType:Nil contentId:Nil customAttributes:attributes];
//	[Answers logCustomEventWithName:[name hasPrefix:@"View"] ? name : [NSString stringWithFormat:@"View %@", name] customAttributes:attributes];
*/}
/*
- (void)viewWillAppearWithName:(NSString *)name {
	[self startLogging:name];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endLogging:) name:UIApplicationDidEnterBackgroundNotification object:name];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startLogging:) name:UIApplicationWillEnterForegroundNotification object:name];
}

- (void)viewDidDisappearWithName:(NSString *)name {
	[self endLogging:name];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:name];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:name];
}
*/
@end
