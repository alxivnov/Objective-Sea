//
//  NSPropertyFile.h
//  Done!
//
//  Created by Alexander Ivanov on 11.01.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FILE_EXTENSION_PLIST @".plist"

@protocol NSPropertyDataSource <NSObject>

- (id)loadByKey:(NSString *)key;
- (void)save:(id)object byKey:(NSString *)key;

@optional

- (void)removeByKey:(NSString *)key;

@end

@interface NSPropertyFile : NSObject

@property (strong, nonatomic) id <NSPropertyDataSource> dataSource;

- (BOOL)isChanged;					// abstract (opt)

@property (strong, nonatomic, readonly) NSString *key;

- (instancetype)initWithKey:(NSString *)key;

- (void)load:(NSString *)key;		// abstract
- (void)save:(NSString *)key;		// abstract

- (void)load;
- (void)save;

- (void)loadFromFile:(NSURL *)url;	// abstract
- (void)saveToFile:(NSURL *)url;	// abstract

+ (NSURL *)urlFromKey:(NSString *)key extension:(NSString *)extension;
+ (NSURL *)urlFromKey:(NSString *)key;

+ (instancetype)create:(NSString *)key dataSource:(id <NSPropertyDataSource>)dataSource;
+ (instancetype)create:(NSString *)key;
+ (instancetype)create;

@end
