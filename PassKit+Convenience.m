//
//  PKMutablePass.m
//  vCard
//
//  Created by Alexander Ivanov on 07.04.2018.
//  Copyright © 2018 Alexander Ivanov. All rights reserved.
//

#import "PassKit+Convenience.h"

@implementation UIViewController (PassKit)

- (PKAddPassesViewController *)presentPasses:(NSArray<PKPass *> *)passes {
	if (!passes)
		return Nil;

	PKAddPassesViewController *vc = [[PKAddPassesViewController alloc] initWithPasses:passes];
	[self presentViewController:vc animated:YES completion:Nil];
	return vc;
}

- (PKAddPassesViewController *)presentPass:(PKPass *)pass {
	if (!pass)
		return Nil;

	PKAddPassesViewController *vc = [[PKAddPassesViewController alloc] initWithPass:pass];
	[self presentViewController:vc animated:YES completion:Nil];
	return vc;
}

@end

@implementation PKMutableObject

- (NSDictionary *)dictionary {
	return Nil;
}

@end

@implementation PKMutablePassField

- (instancetype)initWithKey:(NSString *)key value:(NSString *)value {
	self = [self init];

	if (self) {
		_key = key;
		_value = value;
	}

	return self;
}

+ (instancetype)fieldWithKey:(NSString *)key value:(NSString *)value label:(NSString *)label {
	PKMutablePassField *field = [[PKMutablePassField alloc] initWithKey:key value:value];
	field.localizedLabel = label;
	return field;
}

- (NSDictionary *)dictionary {
	NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:13];
	dic[@"key"] = self.key;
	dic[@"value"] = self.value;
	dic[@"label"] = self.localizedLabel;
	return dic;
}

@end

#define MSG_ENC_ISO @"iso-8859-1"
#define MSG_ENC_UTF @"UTF-8"

@implementation PKMutablePassBarcode

- (instancetype)initWithFormat:(NSString *)format message:(NSString *)message messageEncoding:(NSString *)messageEncoding altText:(NSString *)altText {
	self = [super init];

	if (self) {
		_format = format;
		_message = message;
		_messageEncoding = messageEncoding;
		_altText = altText;
	}

	return self;
}

+ (instancetype)qr:(NSString *)message {
	return message ? [[self alloc] initWithFormat:@"PKBarcodeFormatQR" message:message messageEncoding:MSG_ENC_UTF altText:Nil] : Nil;
}

+ (instancetype)pdf417:(NSString *)message {
	return message ? [[self alloc] initWithFormat:@"PKBarcodeFormatPDF417" message:message messageEncoding:MSG_ENC_UTF altText:Nil] : Nil;
}

+ (instancetype)aztec:(NSString *)message {
	return message ? [[self alloc] initWithFormat:@"PKBarcodeFormatAztec" message:message messageEncoding:MSG_ENC_UTF altText:Nil] : Nil;
}

- (NSDictionary *)dictionary {
	NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:3];
	dic[@"format"] = self.format;
	dic[@"message"] = self.message;
	dic[@"messageEncoding"] = self.messageEncoding;
	dic[@"altText"] = self.altText;
	return dic;
}

@end

@implementation PKMutablePass

- (instancetype)init {
	self = [super init];

	if (self) {
		_auxiliaryFields = [NSMutableArray array];
		_backFields = [NSMutableArray array];
		_headerFields = [NSMutableArray array];
		_primaryFields = [NSMutableArray array];
		_secondaryFields = [NSMutableArray array];
	}

	return self;
}

- (NSUInteger)formatVersion {
	return 1;
}

- (NSDictionary *)styleDictionary {
	NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:6];
	dic[@"auxiliaryFields"] = [self.auxiliaryFields map:^id(PKMutablePassField *obj) {
		return obj.dictionary;
	}];
	dic[@"backFields"] = [self.backFields map:^id(PKMutablePassField *obj) {
		return obj.dictionary;
	}];
	dic[@"headerFields"] = [self.headerFields map:^id(PKMutablePassField *obj) {
		return obj.dictionary;
	}];
	dic[@"primaryFields"] = [self.primaryFields map:^id(PKMutablePassField *obj) {
		return obj.dictionary;
	}];
	dic[@"secondaryFields"] = [self.secondaryFields map:^id(PKMutablePassField *obj) {
		return obj.dictionary;
	}];
	dic[@"transitType"] = self.transitType;
	return dic;
}

- (NSDictionary *)dictionary {
	NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:6];
	dic[@"description"] = self.localizedDescription;
	dic[@"formatVersion"] = @(self.formatVersion);
	dic[@"organizationName"] = self.localizedOrganizationName;
	dic[@"passTypeIdentifier"] = self.passTypeIdentifier;
	dic[@"serialNumber"] = self.serialNumber;
	dic[@"teamIdentifier"] = self.teamIdentifier;
	dic[self.style ?: @"generic"] = [self styleDictionary];
	dic[@"logoText"] = self.localizedLogoText;
	dic[@"backgroundColor"] = self.backgroundColor.cssString;
	dic[@"foregroundColor"] = self.foregroundColor.cssString;
	dic[@"labelColor"] = self.labelColor.cssString;
	dic[@"barcode"] = self.barcode.dictionary;
	return dic;
}

- (NSData *)data {
	NSDictionary *dic = [self dictionary];
	NSData *data = [NSJSONSerialization dataWithJSONObject:dic];
	return data;
}

@end
