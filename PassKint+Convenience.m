//
//  PKMutablePass.m
//  vCard
//
//  Created by Alexander Ivanov on 07.04.2018.
//  Copyright © 2018 Alexander Ivanov. All rights reserved.
//

#import "PassKint+Convenience.h"

@implementation PKMutableObject

- (NSDictionary *)dictionary {
	return @{ };
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

@implementation PKMutablePassStyle

- (instancetype)initWithKey:(NSString *)key {
	self = [self init];

	if (self) {
		_key = key;

		_auxiliaryFields = [NSMutableArray array];
		_backFields = [NSMutableArray array];
		_headerFields = [NSMutableArray array];
		_primaryFields = [NSMutableArray array];
		_secondaryFields = [NSMutableArray array];
	}

	return self;
}

+ (instancetype)boardingPass {
	return [[PKMutablePassStyle alloc] initWithKey:@"boardingPass"];
}

+ (instancetype)coupon {
	return [[PKMutablePassStyle alloc] initWithKey:@"coupon"];
}

+ (instancetype)eventTicket {
	return [[PKMutablePassStyle alloc] initWithKey:@"eventTicket"];
}

+ (instancetype)generic {
	return [[PKMutablePassStyle alloc] initWithKey:@"generic"];
}

+ (instancetype)storeCard {
	return [[PKMutablePassStyle alloc] initWithKey:@"storeCard"];
}

- (NSDictionary *)dictionary {
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

@end

@implementation PKMutablePass

- (NSDictionary *)dictionary {
	NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:6];
	dic[@"description"] = self.localizedDescription;
	dic[@"formatVersion"] = @(self.formatVersion);
	dic[@"organizationName"] = self.localizedOrganizationName;
	dic[@"passTypeIdentifier"] = self.passTypeIdentifier;
	dic[@"serialNumber"] = self.serialNumber;
	dic[@"teamIdentifier"] = self.teamIdentifier;
	if (self.style)
		dic[self.style.key] = self.style.dictionary;
	return dic;
}

- (NSData *)data {
	NSURL *url = [[NSBundle mainBundle] URLForResource:@"logo" withExtension:@"png"];
	NSData *dat = [NSData dataWithContentsOfURL:url];
	NSString *sha = [dat hash:SHA1].hexString;
	[sha log:@"hash"];

	NSURL *temp = [NSFileManager URLForDirectory:NSDocumentDirectory];
	NSURL *pass = [temp URLByAppendingPathComponent:@"temp.pass"];
	NSURL *json = [pass URLByAppendingPathComponent:@"pass.json"];
	NSURL *hash = [pass URLByAppendingPathComponent:@"manifest.json"];

	[pass createDirectory];

	[self.dictionary writeJSONToURL:json atomically:YES];

	NSDictionary *dic = [pass.allFiles dictionaryWithKey:^id<NSCopying>(NSURL *obj) {
		return obj.lastPathComponent;
	} value:^id(NSURL *obj, id<NSCopying> key, id val) {
		return [[NSData dataWithContentsOfURL:obj] hash:SHA1].hexString;
	}];
	[dic writeJSONToURL:hash atomically:YES];

	return Nil;
}

@end
