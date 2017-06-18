//
//  StorageService.h
//  lection14
//
//  Created by 1 on 07.06.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSManagedObjectContext;

@interface SLVStorageService : NSObject

- (id)fetchEntity:(NSString *)entity forKey:(NSString *)key;
- (void)fetchEntities:(NSString *)entity withPredicate:(NSString *)predicate withCompletionBlock:(void (^)(NSArray *result))completion;
- (void)save;
- (void)deleteEntitiesFromCoreData:(NSString *)entity withPredicate:(NSString *)predicate;
- (void)saveObject:(id)object forEntity:(NSString *)entity forAttribute:(NSString *)attribute forKey:(NSString *)key;

@end
