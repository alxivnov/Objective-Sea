//
//  SLHelper.m
//  Done!
//
//  Created by Alexander Ivanov on 01.11.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import "Localization.h"
#import "LocalizationCompose.h"
#import "LocalizationRating.h"
#import "NSObject+Convenience.h"
#import "Palette.h"
#import "SLHelper.h"
#import "UIActivityViewController+Convenience.h"

@interface SLHelper ()
@property (strong, nonatomic) NSString *initialText;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSURL *appStoreURL;
@property (strong, nonatomic) NSURL *websiteURL;
@property (strong, nonatomic) NSURL *emailURL;

@property (weak, nonatomic) UIViewController *presentingViewController;

@property (nonatomic, assign) id <SLHelperDelegate> delegate;
@end

@implementation SLHelper

+ (NSString *)appStore {
	return APP_STORE;
}

+ (NSString *)facebook {
	return FACEBOOK;
}

+ (NSString *)twitter {
	return TWITTER;
}

+ (NSString *)website {
	return WEBSITE;
}

+ (NSString *)email {
	return EMAIL;
}

static id _instance;

+ (instancetype)instance {
	@synchronized(self) {
		if (!_instance)
			_instance = [self new];
	}
	
	return _instance;
}

+ (UIViewController *)composeWithServiceType:(NSString *)serviceType initialText:(NSString *)text image:(UIImage *)image url:(NSURL *)url completion:(void (^)(NSString *activityType, BOOL completed))completion {
	text = text ? [NSString stringWithFormat:@"%@ #%@", text, HASHTAG] : [NSString stringWithFormat:@"#%@", HASHTAG];
	
	if (serviceType) {
		SLComposeViewController *compose = [SLComposeViewController composeViewControllerForServiceType:serviceType];
		
		[compose setInitialText:text];
		if (image)
			[compose addImage:image];
		if (url)
			[compose addURL:url];
		if (completion)
			compose.completionHandler = ^(SLComposeViewControllerResult result) {
				completion(serviceType, result == SLComposeViewControllerResultDone);
			};
		
		return compose;
	} else {
		NSMutableArray *items = [[NSMutableArray alloc] init];
		[items addObject:text];
		if (image)
			[items addObject:image];
		if (url)
			[items addObject:url];

		return [UIActivityViewController activityWithActivityItems:items applicationActivities:Nil excludedActivityTypes:Nil completionHandler:^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
			if (completion)
				completion(activityType, completed);
		}];
	}
}

+ (void)composeWithTitle:(NSString *)title presentingViewController:(UIViewController *)presentingViewController appStore:(BOOL)appStore initialText:(NSString *)initialText image:(UIImage *)image appStoreURL:(NSURL *)appStoreURL websiteURL:(NSURL *)websiteURL email:(NSString *)email delegate:(id <SLHelperDelegate>)delegate alert:(BOOL)alert {
	
	SLHelper *instance = [self instance];
	
	instance.initialText = initialText;
	instance.image = image;
	instance.appStoreURL = appStoreURL;
	instance.websiteURL = websiteURL;
	if (email)
		instance.emailURL = [NSURL URLWithString:[NSString stringWithFormat:@"mailto:%@", email]];
	
	instance.presentingViewController = presentingViewController;
	
	instance.delegate = delegate;
	
	if (alert)
		[[[UIAlertView alloc] initWithTitle:title message:[STR_NEW_LINE stringByAppendingString:[LocalizationRating message]] delegate:instance cancelButtonTitle:Nil otherButtonTitles:[LocalizationRating now:Nil], [LocalizationRating never], [LocalizationRating later], Nil] show];
	else
		[[[UIAlertView alloc] initWithTitle:title message:[STR_NEW_LINE stringByAppendingString:[LocalizationCompose message]] delegate:instance cancelButtonTitle:[Localization cancel] otherButtonTitles:[LocalizationCompose happy], [LocalizationCompose confused], [LocalizationCompose unhappy], Nil] show];
}

- (UIViewController *)composeViewControllerForServiceType:(NSString *)serviceType {
	UIViewController *compose = [[self class] composeWithServiceType:serviceType initialText:self.initialText image:self.image url:self.appStoreURL completion:Nil];
	if (![compose isKindOfClass:[SLComposeViewController class]])
		return compose;
	
	__weak SLComposeViewController *__compose = (SLComposeViewController *)compose;
	((SLComposeViewController *)compose).completionHandler = ^(SLComposeViewControllerResult result) {
		if (result == SLComposeViewControllerResultDone)
			[self.delegate composeDone:__compose];
		else
			[self.delegate composeCancelled:__compose];
	};
	
	return compose;
}

- (void)clickedButtonWithTitle:(NSString *)buttonTitle {
	if ([buttonTitle isEqualToString:[LocalizationRating now:Nil]])
		buttonTitle = APP_STORE;
	else if ([buttonTitle isEqualToString:[LocalizationRating never]])
		buttonTitle = Nil;
	
	if (NSStringIsEqualToString([LocalizationCompose happy], buttonTitle)) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[LocalizationCompose happyTitle] message:Nil delegate:self cancelButtonTitle:Nil otherButtonTitles:Nil];
		
		if (self.appStoreURL) {
			[alert addButtonWithTitle:APP_STORE];
			alert.cancelButtonIndex++;
		}
		
		if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
			[alert addButtonWithTitle:FACEBOOK];
			alert.cancelButtonIndex++;
		}
		
		if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
			[alert addButtonWithTitle:TWITTER];
			alert.cancelButtonIndex++;
		}
		
		[alert addButtonWithTitle:[Localization cancel]];
		alert.cancelButtonIndex++;
		
		[alert show];
	} else if (NSStringIsEqualToString([LocalizationCompose confused], buttonTitle)) {
		[[[UIAlertView alloc] initWithTitle:[LocalizationCompose confusedTitle] message:Nil delegate:self cancelButtonTitle:[Localization cancel] otherButtonTitles:WEBSITE, EMAIL, Nil] show];
	} else if (NSStringIsEqualToString([LocalizationCompose unhappy], buttonTitle)) {
		[[[UIAlertView alloc] initWithTitle:[LocalizationCompose unhappyTitle] message:Nil delegate:self cancelButtonTitle:[Localization cancel] otherButtonTitles:EMAIL, Nil] show];
	} else if (NSStringIsEqualToString(APP_STORE, buttonTitle))
		[[UIApplication sharedApplication] openURL:self.appStoreURL];
	else if (NSStringIsEqualToString(FACEBOOK, buttonTitle))
		[self.presentingViewController presentViewController:[self composeViewControllerForServiceType:SLServiceTypeFacebook] animated:YES completion:Nil];
	else if (NSStringIsEqualToString(TWITTER, buttonTitle))
		[self.presentingViewController presentViewController:[self composeViewControllerForServiceType:SLServiceTypeTwitter] animated:YES completion:Nil];
	else if (NSStringIsEqualToString(WEBSITE, buttonTitle))
		[[UIApplication sharedApplication] openURL:self.websiteURL];
	else if (NSStringIsEqualToString(EMAIL, buttonTitle))
		[[UIApplication sharedApplication] openURL:self.emailURL];
	
	[self.delegate composeClickedButtonWithTitle:buttonTitle];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSString *buttonTitle = alertView.cancelButtonIndex == buttonIndex ? Nil : [alertView buttonTitleAtIndex:buttonIndex];
	
	[self clickedButtonWithTitle:buttonTitle];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSString *buttonTitle = actionSheet.cancelButtonIndex == buttonIndex ? Nil : [actionSheet buttonTitleAtIndex:buttonIndex];
	
	[self clickedButtonWithTitle:buttonTitle];
}

@end
