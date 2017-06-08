//
//  StorageService.m
//  lection14
//
//  Created by 1 on 07.06.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import "SLVStorageService.h"
#import "Item.h"
@import CoreData;
@import UIKit;
#import "CoreDataStack.h"

@implementation SLVStorageService

+ (id)fetchEntity:(NSString *)entity forKey:(NSURL *)key inManagedObjectContext:(NSManagedObjectContext *)moc {
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entity];
    request.predicate = [NSPredicate predicateWithFormat:@"identifier == %@",key];
    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest:request error:&error];
    if (results) {
        return results;
    } else {
        NSLog(@"error while fetching %@",error);
    }
    
    return nil;
}

+ (UIImage *)imageForKey:(NSURL *)key inManagedObjectContext:(NSManagedObjectContext *) moc {
    NSArray *fetched = [SLVStorageService fetchEntity:@"Item" forKey:key inManagedObjectContext:moc];
    if (!fetched || fetched.count == 0) {
        return nil;
    }
    Item *fetchedItem = fetched[0];
    return fetchedItem.largePhoto;
}

+ (UIImage *)thumbnailForKey:(NSURL *)key inManagedObjectContext:(NSManagedObjectContext *) moc {
    NSArray *fetched = [SLVStorageService fetchEntity:@"Item" forKey:key inManagedObjectContext:moc];
    if (!fetched || fetched.count == 0) {
        return nil;
    }
    Item *fetchedItem = fetched[0];
    return fetchedItem.thumbnail;
}

+ (void)saveImage:(UIImage *)image forKey:(NSURL *)key inManagedObjectContext:(NSManagedObjectContext *) moc {
    NSArray *fetched = [SLVStorageService fetchEntity:@"Item" forKey:key inManagedObjectContext:moc];
    Item *fetchedItem = fetched[0];
    fetchedItem.largePhoto = image;
    [SLVStorageService saveInContext:moc];
}

+ (void)saveThumbnail:(UIImage *)image forKey:(NSURL *)key inManagedObjectContext:(NSManagedObjectContext *) moc {
    NSArray *fetched = [SLVStorageService fetchEntity:@"Item" forKey:key inManagedObjectContext:moc];
    Item *fetchedItem = fetched[0];
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

@end
