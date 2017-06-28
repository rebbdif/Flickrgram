//
//  SLVStorageProtocol.h
//  flickrgram
//
//  Created by 1 on 18.06.17.
//  Copyright © 2017 serebryanyy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^voidBlock)(void);

@protocol SLVStorageProtocol <NSObject>

- (id)fetchEntity:(NSString *)entity forKey:(NSString *)key;

- (NSArray *)fetchEntities:(NSString *)entity withPredicate:(NSPredicate *)predicate;

- (void)save;

- (void)performBlockAsynchronously:(voidBlock)block withCompletion:(voidBlock)completion;

- (void)deleteEntities:(NSString *)entity withPredicate:(NSPredicate *)predicate;

- (void)saveObject:(id)object forEntity:(NSString *)entity forAttribute:(NSString *)attribute forKey:(NSString *)key withCompletionHandler:(voidBlock)completionHandler;

- (id)insertNewObjectForEntity:(NSString *)name;

- (void)insertNewObjectForEntityForName:(NSString *)name withDictionary:(NSDictionary<NSString *, id> *)attributes;


@end
