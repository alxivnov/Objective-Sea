//
//  CCHasher.m
//  Guardian
//
//  Created by Alexander Ivanov on 08.05.15.
//  Copyright (c) 2015 NATEK. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>

#import "CCHasher.h"

@interface CCHasher ()
@property (assign, nonatomic) HASH_ALGORITHM algorithm;

@property (assign, nonatomic) CC_SHA256_CTX sha256;
@end

@implementation CCHasher

- (instancetype)initWithAlgorithm:(HASH_ALGORITHM)algorithm {
	self = [super init];
	
	if (self) {
		self.algorithm = algorithm;
		
		if (algorithm == HASH_ALGORITHM_SHA256)
			CC_SHA256_Init(&_sha256);
	}
	
	return self;
}

- (void)update:(NSData *)data {
	if (self.algorithm == HASH_ALGORITHM_SHA256)
		CC_SHA256_Update(&_sha256, data.bytes, (CC_LONG)data.length);
}

- (NSData *)final {
	unsigned char *buffer = Nil;
	NSUInteger length = 0;
	
	if (self.algorithm == HASH_ALGORITHM_SHA256) {
		length = CC_SHA256_DIGEST_LENGTH;
		buffer = malloc(length);
		CC_SHA256_Final(buffer, &_sha256);
	}
	
	if (buffer)
		return [NSData dataWithBytesNoCopy:buffer length:length freeWhenDone:YES];
	
	free(buffer);
	return Nil;
}

+ (NSData *)hash:(HASH_ALGORITHM)algorithm fromStream:(NSInputStream *)stream {
	if (!stream)
		return Nil;
	
	CCHasher *instance = [[CCHasher alloc] initWithAlgorithm:algorithm];
	
	uint8_t *buffer = malloc(MEM_PAGE_SIZE);
	
	[stream open];
	while ([stream hasBytesAvailable]) {
		NSInteger length = [stream read:buffer maxLength:MEM_PAGE_SIZE];
		if (length <= 0)
			break;

		[instance update:[NSData dataWithBytesNoCopy:buffer length:length freeWhenDone:NO]];
	}
	[stream close];
	
	free(buffer);
	
	return [instance final];
}

+ (NSData *)hash:(HASH_ALGORITHM)algorithm fromData:(NSData *)data {
	NSInputStream *stream = data ? [NSInputStream inputStreamWithData:data] : Nil;
	
	return [self hash:algorithm fromStream:stream];
}

+ (NSData *)hash:(HASH_ALGORITHM)algorithm fromURL:(NSURL *)url {
	NSInputStream *stream = [url isExistingFile] ? [NSInputStream inputStreamWithURL:url] : Nil;
	
	return [self hash:algorithm fromStream:stream];
}

@end
