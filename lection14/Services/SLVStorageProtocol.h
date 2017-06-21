//
//  SLVStorageProtocol.h
//  flickrgram
//
//  Created by 1 on 18.06.17.
//  Copyright © 2017 serebryanyy. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SLVStorageProtocol <NSObject>

- (id)fetchEntity:(NSString *)entity forKey:(NSString *)key;

- (NSArray *)fetchEntities:(NSString *)entity withPredicate:(NSString *)predicate;

- (void)save;

- (void)deleteEntitiesFromCoreData:(NSString *)entity withPredicate:(NSString *)predicate;

- (void)saveObject:(id)object forEntity:(NSString *)entity forAttribute:(NSString *)attribute forKey:(NSString *)key withCompletionHandler:(void (^)(void))completionHandler;

- (void)insertNewObjectForEntityForName:(NSString *)name withDictionary:(NSDictionary<NSString *, id> *)attributes;

@end
