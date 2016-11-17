//
//  UIActivity+Convenience.h
//  Ringtonic
//
//  Created by Alexander Ivanov on 14.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@import Social;

#import "NSBundle+Convenience.h"
#import "NSURL+Convenience.h"
#import "UIApplication+Convenience.h"

@interface UIWebActivity : UIActivity

+ (NSURL *)activityURL;										// abstract
+ (NSString *)activityURLKey;								// abstract
+ (BOOL)canPerform:(id)activityItem;						// abstract
+ (NSDictionary *)prepareQuery:(NSArray *)activityItems;	// abstract

@property (strong, nonatomic, class) NSURL *defaultURL;
@property (strong, nonatomic, class) NSArray<NSString *> *hashtags;

+ (NSArray<__kindof UIWebActivity *> *)webActivities:(NSString *)facebookAppID;

@end

// https://developers.facebook.com/docs/sharing/reference/share-dialog?locale=ru_RU

#define FBActivityType @"facebook.com"
#define FBActivityTitle @"Facebook"
#define FBActivityURL @"https://www.facebook.com/dialog/share"

#define FBKeyURL @"href"
#define FBKeyAppID @"app_id"
#define FBKeyRedirect @"redirect_uri"

@interface FBWebActivity : UIWebActivity

@property (strong, nonatomic, class) NSString *appID;

@end

// https://developers.google.com/+/web/share/

#define GPActivityType @"plus.google.com"
#define GPActivityTitle @"Google+"
#define GPActivityURL @"https://plus.google.com/share"

#define GPKeyURL @"url"

@interface GPWebActivity : UIWebActivity

@end

// https://dev.twitter.com/web/tweet-button/web-intent

#define TWActivityType @"twitter.com"
#define TWActivityTitle @"Twitter"
#define TWActivityURL @"https://twitter.com/intent/tweet"

#define TWKeyText @"text"
#define TWKeyURL @"url"
#define TWKeyHashtags @"hashtags"
#define TWKeyVia @"via"
#define TWKeyRelated "related"
#define TWKeyInDefineTo "in-reply-to"

@interface TWWebActivity : UIWebActivity

@end

// http://vk.com/dev/share_details

#define VKActivityType @"vk.com"
#define VKActivityTitle @"VK"
#define VKActivityURL @"http://vk.com/share.php"

#define VKKeyURL @"url"
#define VKKeyTitle @"title"
#define VKKeyDescription @"description"
#define VKKeyImage @"image"

@interface VKWebActivity : UIWebActivity

@end
