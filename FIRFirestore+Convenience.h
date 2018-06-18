//
//  FIRFirestore+Convenience.h
//  YoCard
//
//  Created by Alexander Ivanov on 09.05.2018.
//  Copyright © 2018 Alexander Ivanov. All rights reserved.
//

#import <FirebaseFirestore/FirebaseFirestore.h>

#import "NSObject+Convenience.h"

@interface FIRFirestore (Convenience)

@end

@interface FIRCollectionReference (Convenience)

- (void)getDocuments:(void(^)(FIRQuerySnapshot *snapshot))completion;

@end

@interface FIRDocumentReference (Convenience)

- (void)getDocument:(void (^)(FIRDocumentSnapshot *snapshot))completion;

- (void)set:(NSDictionary<NSString *,id> *)documentData completion:(void (^)(BOOL success))completion;
- (void)merge:(NSDictionary<NSString *,id> *)documentData completion:(void (^)(BOOL success))completion;

- (void)update:(NSDictionary<id,id> *)fields completion:(void (^)(BOOL success))completion;

@end
