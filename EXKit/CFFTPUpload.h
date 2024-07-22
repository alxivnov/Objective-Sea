//
//  FTPUpload.h
//  Done!
//
//  Created by Alexander Ivanov on 13.03.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FTP_BUFFER_LENGTH 32768

@interface CFFTPUpload : NSObject <NSStreamDelegate>

+ (CFFTPUpload *)uploadFile:(NSString *)file toURL:(NSString *)url withUsername:(NSString *)username andPassword:(NSString *)password completion:(void (^)(BOOL))completion;

@property (strong, nonatomic, readonly) NSString *url;
@property (strong, nonatomic, readonly) NSString *username;
@property (strong, nonatomic, readonly) NSString *password;

@property (copy) void (^completion) (BOOL);

- (id)initWithURL:(NSString *)url username:(NSString *)username password:(NSString *)password;

- (void)start:(NSString *)file;

- (void)stop;

@end
