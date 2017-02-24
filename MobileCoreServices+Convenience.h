//
//  MobileCoreServices+Convenience.h
//  Offcloud
//
//  Created by Alexander Ivanov on 23.02.17.
//  Copyright © 2017 Alexander Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface UTType : NSObject

+ (NSString *)mimeTypeFromFilenameExtension:(NSString *)filenameExtension;

+ (NSArray<NSString *> *)filenameExtensionsFromMimeType:(NSString *)mimeType;

@end
