//
//  NSUbiquityContainer.m
//  Guardian
//
//  Created by Alexander Ivanov on 13.05.15.
//  Copyright (c) 2015 NATEK. All rights reserved.
//

#import "NSFileManager+Ubiquity.h"
#import "NSUbiquityContainer.h"
#import "NSURL+Ubiquity.h"

@interface NSUbiquityContainer ()
@property (strong, nonatomic) NSString *identifier;

@property (strong, nonatomic) NSURL *url;
@end

@implementation NSUbiquityContainer

- (void)setup {
	__weak NSUbiquityContainer *__self = self;
	[[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:self.identifier handler:^(NSURL *url) {
		__self.url = url;
	}];
}

- (void)ubiquityIdentityDidChange:(NSNotification *)notification {
	if (![self.identifier isEqualToString:notification.object])
		return;
	
	self.url = Nil;
	
	[self setup];
}

- (instancetype)init:(NSString *)identifier {
	self = [super init];
	
	if (self) {
		self.identifier = identifier;
		
		[self setup];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ubiquityIdentityDidChange:) name:NSUbiquityIdentityDidChangeNotification object:self.identifier];
	}
	
	return self;
}

- (instancetype)init {
	return [self init:Nil];
}

- (void)add:(NSURL *)url {
	NSURL *cloudURL = [self.url URLByAppendingPathComponent:url.lastPathComponent];
	
	[url moveToCloud:cloudURL];
}

- (void)remove:(NSURL *)url {
	NSURL *localURL = Nil;
	
	[url moveLocally:localURL];
}

- (NSArray *)items {
	return Nil;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:NSUbiquityIdentityDidChangeNotification object:self.identifier];
}

+ (instancetype)create:(NSString *)identifier {
	if (![[NSFileManager defaultManager] ubiquityIdentityToken])
		return Nil;
	
	return [[self alloc] init:identifier];
}

+ (instancetype)create {
	return [self create:Nil];
}

static id _instance;

+ (instancetype)defaultContainer {
	@synchronized(self) {
		if (!_instance)
			_instance = [self new];
	}
	
	return _instance;
}

@end
