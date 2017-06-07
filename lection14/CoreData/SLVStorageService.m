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

@implementation SLVStorageService

+ (id)fetchEntity:(NSString *)entity forKey:(NSString *)key inManagedObjectContext:(NSManagedObjectContext *)moc {
    
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

+ (UIImage *)imageForKey:(NSString *)key inManagedObjectContext:(NSManagedObjectContext *) moc {
    NSArray *fetched = [SLVStorageService fetchEntity:@"Item" forKey:key inManagedObjectContext:moc];
    Item *fetchedItem = fetched[0];
    return fetchedItem.largePhoto;
}

+ (UIImage *)thumbnailForKey:(NSString *)key inManagedObjectContext:(NSManagedObjectContext *) moc {
    NSArray *fetched = [SLVStorageService fetchEntity:@"Item" forKey:key inManagedObjectContext:moc];
    Item *fetchedItem = fetched[0];
    return fetchedItem.thumbnail;
}

@end
