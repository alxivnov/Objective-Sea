//
//  FIRFirestore+Convenience.m
//  YoCard
//
//  Created by Alexander Ivanov on 09.05.2018.
//  Copyright © 2018 Alexander Ivanov. All rights reserved.
//

#import "FIRFirestore+Convenience.h"

@implementation FIRFirestore (Convenience)

@end

@implementation FIRCollectionReference (Convenience)

- (void)getDocuments:(void(^)(FIRQuerySnapshot *))completion {
	[self getDocumentsWithCompletion:^(FIRQuerySnapshot *snapshot, NSError *error) {
		if (completion)
			completion(snapshot);

		[error log:@"getDocumentsWithCompletion:"];
	}];
}

@end

@implementation FIRDocumentReference (Convenience)

- (void)getDocument:(void (^)(FIRDocumentSnapshot *))completion {
	[self getDocumentWithCompletion:^(FIRDocumentSnapshot * _Nullable snapshot, NSError * _Nullable error) {
		if (completion)
			completion(snapshot);

		[error log:@"getDocumentWithCompletion:"];
	}];
}

- (void)set:(NSDictionary<NSString *,id> *)documentData completion:(void (^)(BOOL))completion {
	[self setData:documentData completion:^(NSError * _Nullable error) {
		if (completion)
			completion(error == Nil);

		[error log:@"setData:"];
	}];
}

- (void)merge:(NSDictionary<NSString *,id> *)documentData completion:(void (^)(BOOL))completion {
	[self setData:documentData options:[FIRSetOptions merge] completion:^(NSError * _Nullable error) {
		if (completion)
			completion(error == Nil);

		[error log:@"setData:"];
	}];
}

- (void)update:(NSDictionary<id,id> *)fields completion:(void (^)(BOOL))completion {
	[self updateData:fields completion:^(NSError * _Nullable error) {
		if (completion)
			completion(error == Nil);

		[error log:@"updateData:"];
	}];
}

@end
