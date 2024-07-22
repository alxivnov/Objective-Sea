//
//  NSPropertyList.m
//  Done!
//
//  Created by Alexander Ivanov on 06.01.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "NSPropertyDictionary.h"

@interface NSPropertyDictionary ()
@property (nonatomic, assign) BOOL dontSave;
@end

@implementation NSPropertyDictionary
/*
- (instancetype)init {
    return [self initFromDictionary:Nil];
}
*/
- (instancetype)initFromDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self)
		[self fromDictionary:dictionary dontSave:YES];
    
    return self;
}

- (void)fromDictionary:(NSDictionary *)dictionary dontSave:(BOOL)dontSave {
	if (dontSave)
		self.dontSave = YES;
	
	[self fromDictionary:dictionary];
	
	if (dontSave)
		self.dontSave = NO;
}

- (void)fromDictionary:(NSDictionary *)dictionary {
				// abstract
}

- (NSDictionary *)toDictionary {
	return Nil;	// abstract
}

- (void)load:(NSString *)key {
	NSDictionary *data = [self.dataSource loadByKey:key];
	
	[self fromDictionary:data dontSave:YES];
}

- (void)save:(NSString *)key {
	if (self.dontSave)
		return;
	
	NSDictionary *data = [self toDictionary];
	
	if (![self isChanged])
		return;
	
	[self.dataSource save:data byKey:key];
}

- (void)loadFromFile:(NSURL *)url {
	NSDictionary *data = [[NSDictionary alloc] initWithContentsOfURL:url];
	[self fromDictionary:data dontSave:YES];
}

- (void)saveToFile:(NSURL *)url {
	NSDictionary *data = [self toDictionary];
	[data writeToURL:url atomically:YES];
}

@end
