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
#import "CoreDataStack.h"

@interface SLVStorageService()

@property (nonatomic, strong) CoreDataStack *stack;

@end

@implementation SLVStorageService

- (instancetype)init {
    self = [super init];
    if (self) {
        _stack = [CoreDataStack stack];
    }
    return self;
}

- (id)fetchEntity:(NSString *)entity forKey:(NSString *)key {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entity];
    request.predicate = [NSPredicate predicateWithFormat:@"identifier ==%@", key];
    NSError *error = nil;
    NSArray *results = [self.stack.mainContext executeFetchRequest:request error:&error];
    if (results.count == 0) {
        return nil;
    } else if (results.count > 1) {
        NSLog(@"storageService - there is more than one result for request");
    }
    return results[0];
}

- (NSArray *)fetchEntities:(NSString *)entity withPredicate:(NSString *)predicate {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:entity];
    request.fetchBatchSize = 30;
    //    request.predicate = [NSPredicate predicateWithFormat:predicate];
#warning wtf with request.predicate
    NSError *error = nil;
    NSArray *fetchedArray = [self.stack.mainContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"storageService - error while fetching %@", error);
    }
    return fetchedArray;
}

- (void)save {
    [self.stack.privateContext performBlockAndWait:^{
        if (self.stack.privateContext.hasChanges) {
            NSError *error = nil;
            [self.stack.privateContext save:&error];
            if (error) {
                NSLog(@"storageService -%@", error.localizedDescription);
            }
        }
    }];
    [self.stack.mainContext performBlock:^{
        if (self.stack.mainContext.hasChanges) {
            NSError *error = nil;
            [self.stack.mainContext save:&error];
            if (error) {
                NSLog(@"storageService - %@", error.localizedDescription);
            }
        }
    }];
}

- (void)deleteEntities:(NSString *)entity withPredicate:(NSString *)predicate {
    NSError *error;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entity];
    request.predicate = [NSPredicate predicateWithFormat:predicate];
    NSArray *results = [self.stack.privateContext executeFetchRequest:request error:&error];
    [self.stack.privateContext performBlockAndWait:^{
        for (id item in results) {
            [self.stack.privateContext deleteObject:item];
        }
    }];
    [self save];
}

- (void)saveObject:(id)object forEntity:(NSString *)entity forAttribute:(NSString *)attribute forKey:(NSString *)key withCompletionHandler:(void (^)(void))completionHandler {
    id fetchedEntity = [self fetchEntity:entity forKey:key];
    if (!fetchedEntity) {
        NSLog(@"storageService - saveObject couldn't fetch entity for key %@", key);
    }
    [self.stack.privateContext performBlock:^{
        [fetchedEntity setValue:object forKey:attribute];
        [self save];
        completionHandler();
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

@end
