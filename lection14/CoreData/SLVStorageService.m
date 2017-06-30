//
//  StorageService.m
//  lection14
//
//  Created by 1 on 07.06.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import "SLVStorageService.h"
@import CoreData;
@import UIKit;
#import "SLVCoreDataStack.h"

@interface SLVStorageService()

@property (nonatomic, strong) SLVCoreDataStack *stack;

@end

@implementation SLVStorageService

- (instancetype)init {
    self = [super init];
    if (self) {
        _stack = [SLVCoreDataStack stack];
    }
    return self;
}

- (id)fetchEntity:(NSString *)entity forKey:(NSString *)key {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entity];
    request.predicate = [NSPredicate predicateWithFormat:@"identifier == %@", key];
    NSError *error = nil;
    NSArray *results = [self.stack.mainContext executeFetchRequest:request error:&error];
    if (results.count == 0) {
        return nil;
    } else if (results.count > 1) {
        NSLog(@"storageService - there is more than one result for request");
    }
    return results[0];
}

- (NSArray *)fetchEntities:(NSString *)entity withPredicate:(NSPredicate *)predicate {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:entity];
    request.fetchBatchSize = 30;
    request.predicate = predicate;
    NSError *error = nil;
    NSArray *fetchedArray = [self.stack.mainContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"storageService - error while fetching %@", error);
    }
    return fetchedArray;
}

- (void)savePrivateContext:(NSManagedObjectContext *)privateContext {
    [privateContext performBlock:^{
        if (privateContext.hasChanges) {
            NSError *error = nil;
            if (![privateContext save:&error]) {
                NSLog(@"storageService - %@", error.localizedDescription);
            }
        }
    }];
    NSLock *lock = [NSLock new];
    [lock lock];
    [self.stack.mainContext performBlockAndWait:^{
        if (self.stack.mainContext.hasChanges) {
            NSError *error = nil;
            if(![self.stack.mainContext save:&error]) {
                NSLog(@"storageService - %@", error.localizedDescription);
            }
        }
    }];
    [lock unlock];
}

- (void)save {
    NSLock *lock = [NSLock new];
    [lock lock];
    [self.stack.mainContext performBlockAndWait:^{
        if (self.stack.mainContext.hasChanges) {
            NSError *error = nil;
            if(![self.stack.mainContext save:&error]) {
                NSLog(@"storageService - %@", error.localizedDescription);
                NSLog(@"storageService - %@", error.userInfo);
            }
        }
    }];
    [lock unlock];
}

- (void)deleteEntities:(NSString *)entity withPredicate:(NSPredicate *)predicate {
    NSManagedObjectContext *privateContext = [self.stack setupPrivateContext];
    NSError *error;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entity];
    request.predicate = predicate;
    NSArray *results = [privateContext executeFetchRequest:request error:&error];
    __weak typeof(self)weakSelf = self;
    [privateContext performBlockAndWait:^{
        __strong typeof(weakSelf)strongSelf = weakSelf;
        for (id item in results) {
            [privateContext deleteObject:item];
        }
        [strongSelf savePrivateContext:privateContext];
    }];
}

- (void)saveObject:(id)object forEntity:(NSString *)entity forAttribute:(NSString *)attribute forKey:(NSString *)key withCompletionHandler:(voidBlock)completionHandler {
    NSManagedObjectContext *privateContext = [self.stack setupPrivateContext];
    id fetchedEntity = [self fetchEntity:entity forKey:key];
    if (!fetchedEntity) {
        NSLog(@"storageService - saveObject couldn't fetch entity for key %@", key);
    }
    __weak typeof(self)weakSelf = self;
    [privateContext performBlockAndWait:^{
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [fetchedEntity setValue:object forKey:attribute];
        [strongSelf savePrivateContext:privateContext];
        if (completionHandler) completionHandler();
    }];
}

- (void)insertNewObjectForEntityForName:(NSString *)name withDictionary:(NSDictionary<NSString *, id> *)attributes {
    NSManagedObjectContext *privateContext = [self.stack setupPrivateContext];
    [privateContext performBlockAndWait:^{
        id entity = [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:privateContext];
        for (NSString *attribute in attributes) {
            [entity setValue:attributes[attribute] forKey:attribute];
        }
        [self savePrivateContext:privateContext];
    }];
}

- (id)insertNewObjectForEntity:(NSString *)name {
    NSManagedObject *entity = [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:self.stack.mainContext];
    return entity;
}

- (void)performBlockAsynchronously:(voidBlock)block withCompletion:(voidBlock)completion {
    NSManagedObjectContext *privateContext = [self.stack setupPrivateContext];
    [privateContext performBlockAndWait:^{
        block();
        [self savePrivateContext:privateContext];
        if (completion) completion();
    }];
}

@end
