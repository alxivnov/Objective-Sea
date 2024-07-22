//
//  XMLParserBase.m
//  Guardian
//
//  Created by Alexander Ivanov on 22.09.14.
//  Copyright (c) 2014 NATEK. All rights reserved.
//

#import "NSXMLDictionaryBase.h"

@implementation NSXMLDictionaryBase

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
	self = [self init];

	if (self)
		self.dictionary = dictionary;

	return self;
}

- (instancetype)initWithData:(NSData *)data {
	return [self initWithDictionary:[NSXMLDictionary parseData:data]];
}

- (NSString *)description {
	return [self.dictionary description];
}

+ (NSString *)fileName {
	return [[[self class] description] stringByAppendingString:@".xml"];
}

+ (NSURL *)filePath {
	return [[NSFileManager URLForDirectory:NSDocumentDirectory] URLByAppendingPathComponent:[self fileName]];
}

+ (instancetype)createWithContentsOfURL:(NSURL *)url {
	NSData *data = [NSData dataWithContentsOfURL:url];

	return data ? [[self alloc] initWithData:data] : Nil;
}

+ (instancetype)createWithString:(NSString *)string {
	NSData *data = [string dataUsingEncoding:NSUnicodeStringEncoding];

	return data ? [[self alloc] initWithData:data] : Nil;
}

+ (instancetype)readFromURL:(NSURL *)url {
	NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfURL:url ? url : [self filePath]];

	return dictionary ? [[self alloc] initWithDictionary:dictionary] : Nil;
}

- (void)writeToURL:(NSURL *)url {
	[self.dictionary writeToURL:url ? url : [[self class] filePath] atomically:YES];
}

@end
