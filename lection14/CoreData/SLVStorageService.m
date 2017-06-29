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

- (void)save {
    [self.stack.privateContext performBlock:^{
        if (self.stack.privateContext.hasChanges) {
            NSError *error = nil;
            [self.stack.privateContext save:&error];
            if (error) {
                NSLog(@"storageService - %@", error.localizedDescription);
            }
        }
    }];
    NSLock *lock = [NSLock new];
    [lock lock];
    [self.stack.mainContext performBlockAndWait:^{
        if (self.stack.mainContext.hasChanges) {
            NSError *error = nil;
            [self.stack.mainContext save:&error];
            if (error) {
                NSLog(@"storageService - %@", error.localizedDescription);
            }
        }
    }];
    [lock unlock];
}

- (void)deleteEntities:(NSString *)entity withPredicate:(NSPredicate *)predicate {
    NSError *error;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entity];
    request.predicate = predicate;
    NSArray *results = [self.stack.privateContext executeFetchRequest:request error:&error];
    __weak typeof(self)weakSelf = self;
    [self.stack.privateContext performBlockAndWait:^{
        __strong typeof(weakSelf)strongSelf = weakSelf;
        for (id item in results) {
            [strongSelf.stack.privateContext deleteObject:item];
        }
    }];
    [self save];
}

- (void)saveObject:(id)object forEntity:(NSString *)entity forAttribute:(NSString *)attribute forKey:(NSString *)key withCompletionHandler:(voidBlock)completionHandler {
    id fetchedEntity = [self fetchEntity:entity forKey:key];
    if (!fetchedEntity) {
        NSLog(@"storageService - saveObject couldn't fetch entity for key %@", key);
    }
    __weak typeof(self)weakSelf = self;
    [self.stack.privateContext performBlock:^{
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [fetchedEntity setValue:object forKey:attribute];
        [strongSelf save];
        if (completionHandler) completionHandler();
    }];
}

- (void)insertNewObjectForEntityForName:(NSString *)name withDictionary:(NSDictionary<NSString *, id> *)attributes {
    [self.stack.privateContext performBlock:^{
        id entity = [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:self.stack.privateContext];
        for (NSString *attribute in attributes) {
            [entity setValue:attributes[attribute] forKey:attribute];
        }
        [self save];
    }];
}

- (id)insertNewObjectForEntity:(NSString *)name {
    id entity = [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:self.stack.mainContext];
    [self save];
    return entity;
}

- (void)performBlockAsynchronously:(voidBlock)block withCompletion:(voidBlock)completion {
    [self.stack.privateContext performBlock:^{
        block();
        if (completion) completion();
    }];
}

@end
