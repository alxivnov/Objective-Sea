//
//  FTPUpload.m
//  Done!
//
//  Created by Alexander Ivanov on 13.03.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "CFFTPUpload.h"
#import "NSHelper.h"

@interface CFFTPUpload ()
@property (strong, nonatomic, readwrite) NSString *url;
@property (strong, nonatomic, readwrite) NSString *username;
@property (strong, nonatomic, readwrite) NSString *password;

@property (strong, nonatomic) NSInputStream *fileStream;
@property (strong, nonatomic) NSOutputStream *networkStream;

@property (assign, nonatomic, readonly) uint8_t *buffer;
@property (assign, nonatomic) NSUInteger bufferOffset;
@property (assign, nonatomic) NSUInteger bufferLength;
@end

@implementation CFFTPUpload {
	uint8_t _buffer[FTP_BUFFER_LENGTH];
}

- (uint8_t *)buffer {
	return self->_buffer;
}

+ (CFFTPUpload *)uploadFile:(NSString *)file toURL:(NSString *)url withUsername:(NSString *)username andPassword:(NSString *)password completion:(void(^)(BOOL))completion {
	CFFTPUpload *upload = [[CFFTPUpload alloc] initWithURL:url username:username password:password];
	upload.completion = completion;
	[upload start:file];
	return upload;
}

- (id)initWithURL:(NSString *)url username:(NSString *)username password:(NSString *)password {
	self = [super init];
	
	if (self) {
		self.url = url;
		self.username = username;
		self.password = password;
	}
	
	return self;
}

- (void)start:(NSString *)file {
	NSURL *fileURL = [NSHelper documentsDirectory:file];
	
	self.fileStream = [NSInputStream inputStreamWithURL:fileURL];
	[self.fileStream open];
	
	NSURL *ftpURL = [NSURL URLWithString:self.url];
	self.networkStream = CFBridgingRelease(CFWriteStreamCreateWithFTPURL(NULL, (__bridge CFURLRef)ftpURL));

	if (self.username && self.password) {
		[self.networkStream setProperty:self.username forKey:(id)kCFStreamPropertyFTPUserName];
		[self.networkStream setProperty:self.password forKey:(id)kCFStreamPropertyFTPPassword];
	}
	
	self.networkStream.delegate = self;
	[self.networkStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[self.networkStream open];
}

- (void)stop {
	[self stop:NO];
}

- (void)stop:(BOOL)success {
    if (self.networkStream) {
        [self.networkStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        self.networkStream.delegate = Nil;
        
		[self.networkStream close];
        self.networkStream = Nil;
    }
	
    if (self.fileStream) {
        [self.fileStream close];
        self.fileStream = Nil;
    }
	
	if (self.completion)
		self.completion(success);
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
    if (eventCode == NSStreamEventHasSpaceAvailable) {
		if (self.bufferOffset == self.bufferLength) {
			NSInteger read = [self.fileStream read:self.buffer maxLength:FTP_BUFFER_LENGTH];
			
			if (read > 0) {
				self.bufferOffset = 0;
				self.bufferLength = read;
			} else if (read == 0) {
				[self stop:YES];
			} else {
				[self stop:NO];
			}
		}
		
		if (self.bufferOffset != self.bufferLength) {
			NSInteger written = [self.networkStream write:&self.buffer[self.bufferOffset] maxLength:self.bufferLength - self.bufferOffset];
			
			if (written > 0) {
				self.bufferOffset += written;
			} else if (written == 0) {
				[self stop:NO];
			} else {
				[self stop:NO];
			}
		}
	} else if (eventCode == NSStreamEventErrorOccurred) {
		[self stop:NO];
	}
}

@end
