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
#import "SLVItem.h"

@implementation SLVStorageService

static NSString *const item = @"SLVItem";

+ (id)fetchEntity:(NSString *)entity forKey:(NSString *)key inManagedObjectContext:(NSManagedObjectContext *)moc {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entity];
    request.predicate = [NSPredicate predicateWithFormat:@"identifier ==%@", key];
    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest:request error:&error];
    if (!results) {
        NSLog(@"error while fetching %@",error);
    }
    return results;
}

+ (void)fetchEntities:(NSString *)entity withPredicate:(NSString *)predicate inManagedObjectContext:(NSManagedObjectContext *)moc withCompletionBlock:(void (^)(NSArray *))completion {
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:entity];
    request.predicate = [NSPredicate predicateWithFormat:predicate];
    NSAsynchronousFetchRequest *asyncRequest = [[NSAsynchronousFetchRequest alloc] initWithFetchRequest:request completionBlock:^(NSAsynchronousFetchResult * _Nonnull result) {
        NSArray *fetchedArray = result.finalResult;
        completion(fetchedArray);
    }];
    NSError *error = nil;
    [moc executeRequest:asyncRequest error:&error];
    if (error) {
        NSLog(@"error while fetching %@",error);
    }
}

+ (UIImage *)imageForKey:(NSString *)key inManagedObjectContext:(NSManagedObjectContext *) moc {
    NSArray *fetched = [SLVStorageService fetchEntity:item forKey:key inManagedObjectContext:moc];
    if (!fetched || fetched.count == 0) {
        return nil;
    }
    SLVItem *fetchedItem = fetched[0];
    return fetchedItem.largePhoto;
}

+ (UIImage *)thumbnailForKey:(NSString *)key inManagedObjectContext:(NSManagedObjectContext *) moc {
    NSArray *fetched = [SLVStorageService fetchEntity:item forKey:key inManagedObjectContext:moc];
    if (!fetched || fetched.count == 0) {
        return nil;
    }
    SLVItem *fetchedItem = fetched[0];
    return fetchedItem.thumbnail;
}

+ (void)saveImage:(UIImage *)image forKey:(NSString *)key inManagedObjectContext:(NSManagedObjectContext *) moc {
    NSArray *fetched = [SLVStorageService fetchEntity:item forKey:key inManagedObjectContext:moc];
    SLVItem *fetchedItem = fetched[0];
    fetchedItem.largePhoto = image;
    [SLVStorageService saveInContext:moc];
}

+ (void)saveThumbnail:(UIImage *)image forKey:(NSString *)key inManagedObjectContext:(NSManagedObjectContext *) moc {
    NSArray *fetched = [SLVStorageService fetchEntity:item forKey:key inManagedObjectContext:moc];
    SLVItem *fetchedItem = fetched[0];
    fetchedItem.thumbnail = image;
    [SLVStorageService saveInContext:moc];
}

+ (void)saveInContext:(NSManagedObjectContext *)moc {
    if (moc.hasChanges) {
        NSError *error = nil;
        [moc save:&error];
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        }
    }
}

+ (void)clearCoreData:(NSManagedObjectContext *)moc {
    NSError *error;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:item];
    request.predicate = [NSPredicate predicateWithFormat:@"isFavorite == NO"];
    
    NSArray<SLVItem *> *results = [moc executeFetchRequest:request error:&error];
    for (__strong SLVItem *item in results) {
        item = nil;
    }
    if (error) {
        NSLog(@"error, %@",error);
    }
}


@end
