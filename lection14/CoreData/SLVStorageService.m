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
        NSLog(@"there is more than one result for request");
    }
    return results[0];
}

- (void)fetchEntities:(NSString *)entity withPredicate:(NSString *)predicate withCompletionBlock:(void (^)(NSArray *))completion {
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:entity];
    request.predicate = [NSPredicate predicateWithFormat:predicate];
    NSAsynchronousFetchRequest *asyncRequest = [[NSAsynchronousFetchRequest alloc] initWithFetchRequest:request completionBlock:^(NSAsynchronousFetchResult * _Nonnull result) {
        NSArray *fetchedArray = result.finalResult;
        completion(fetchedArray);
    }];
    NSError *error = nil;
    [self.stack.mainContext executeRequest:asyncRequest error:&error];
    if (error) {
        NSLog(@"error while fetching %@",error);
    }
}

- (void)save {
    if (self.stack.privateContext.hasChanges) {
        NSError *error = nil;
        [self.stack.privateContext save:&error];
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        }
    }
}

- (void)deleteEntitiesFromCoreData:(NSString *)entity withPredicate:(NSString *)predicate {
    NSError *error;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entity];
    request.predicate = [NSPredicate predicateWithFormat:predicate];
    NSArray *results = [self.stack.privateContext executeFetchRequest:request error:&error];
    for (id item in results) {
        [self.stack.privateContext deleteObject:item];
    }

}

- (void)saveObject:(id)object forEntity:(NSString *)entity forAttribute:(NSString *)attribute forKey:(NSString *)key {
    id fetchedEntity = [self fetchEntity:entity forKey:key];
    @try {
        [fetchedEntity setValue:object forKey:key];
    } @catch (NSException *exception) {
        NSLog(@"KVC error when saving object for key %@", key);
        return;
    }
    [self save];
}

- (id)insertNewObjectForEntityForName:(NSString *)name {
    id entity = [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:self.stack.privateContext];
    if (!entity) {
        NSLog(@"error when saving new entity for key");
    }
    return entity;
}

@end
