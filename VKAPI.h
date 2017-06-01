//
//  VKAPI.h
//  Ringtonic
//
//  Created by Alexander Ivanov on 28.05.17.
//  Copyright © 2017 Alexander Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSDictionary+Convenience.h"
#import "NSURLSession+Convenience.h"
#import "VKItem.h"

typedef enum : NSUInteger {
	VKScopeNotify			= 1,			// Пользователь разрешил отправлять ему уведомления (для flash/iframe-приложений).
	VKScopeFriends			= 2,			// Доступ к друзьям.
	VKScopePhotos			= 4,			// Доступ к фотографиям.
	VKScopeAudio			= 8,			// Доступ к аудиозаписям.
	VKScopeVideo			= 16,			// Доступ к видеозаписям.
	VKScopePages			= 128,			// Доступ к wiki-страницам.
	VKScope256				= 256,			// Добавление ссылки на приложение в меню слева.
	VKScopeStatus			= 1024,			// Доступ к статусу пользователя.
	VKScopeNotes			= 2048,			// Доступ к заметкам пользователя.
	VKScopeMessages			= 4096,			// Доступ к расширенным методам работы с сообщениями (только для Standalone-приложений).
	VKScopeWall				= 8192,			// Доступ к обычным и расширенным методам работы со стеной. Данное право доступа по умолчанию недоступно для сайтов при использовании OAuth-авторизации (игнорируется при попытке авторизации).
	VKScopeAds				= 32768,		// Доступ к расширенным методам работы с рекламным API.
	VKScopeOffline			= 65536,		// Доступ к API в любое время (при использовании этой опции параметр expires_in, возвращаемый вместе с access_token, содержит 0 — токен бессрочный). Не применяется в Open API.
	VKScopeDocs				= 131072,		// Доступ к документам.
	VKScopeGroups			= 262144,		// Доступ к группам пользователя.
	VKScopeNotifications	= 524288,		// Доступ к оповещениям об ответах пользователю.
	VKScopeStats			= 1048576,		// Доступ к статистике групп и приложений пользователя, администратором которых он является.
	VKScopeEmail			= 4194304,		// Доступ к email пользователя.
	VKScopeMarket			= 134217728,	// Доступ к товарам.
} VKScope;

//#APP_ID = "2054573"
//#VKSECRET = "KUPNPTTQGApLFVOVgqdx"
#define VK_IPHONE_ID @"3140623"
#define VK_IPHONE_SECRET @"VeWdmVclDCtn6ihuP1nt"
#define VK_IPAD_ID @"3682744"
#define VK_IPAD_SECRET @"mY6CDUswIVdJLCD3j15n"
#define VK_ANDROID_ID @"2274003"
#define VK_ANDROID_SECRET @"hHbZxrka2uZ6jB1inYsH"

#define VK_IPHONE_USER_AGENT @"com.vk.vkclient (unknown, iPhone OS 10.0.0, iPhone, Scale/2.000000)"
#define VK_ANDROID_USER_AGENT @"VKAndroidApp/3.5-303 (Android 5.1; SDK 22; x86; Nexus - 5.1.0 - API 22 - 768x1280; en)"
#define VK_KATE_MOBILE_USER_AGENT @"KateMobileAndroid/39.3-384 (Android 4.2.2; SDK 17; x86; Genymotion Custom Phone - 4.2.2 - API 17 - 768x1280_2; en)"

#define VK_SCOPE VKScopePhotos | VKScopeAudio | VKScopeWall | VKScopeGroups

@interface VKAPI : NSObject

@property (strong, nonatomic) NSString *userAgent;

@property (strong, nonatomic) NSString *version;

@property (strong, nonatomic, readonly) NSString *accessToken;

- (NSURLSessionDataTask *)authorizeWithClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret scope:(NSUInteger)scope username:(NSString *)username password:(NSString *)password handler:(void(^)(NSDictionary *response))handler;

- (NSURLSessionDataTask *)getAudio:(void (^)(NSArray<VKAudioItem *> *))handler;
- (NSURLSessionDataTask *)searchAudio:(NSString *)query handler:(void(^)(NSArray<VKAudioItem *> *items))handler;

+ (instancetype)api;

@end
