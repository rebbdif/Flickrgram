//
//  SLVPostModel.m
//  flickrgram
//
//  Created by 1 on 17.06.17.
//  Copyright © 2017 serebryanyy. All rights reserved.
//

#import "SLVPostModel.h"

@implementation SLVPostModel

- (void)clearModel:(BOOL)entirely {
    self.items = [NSArray new];
    [SLVStorageService clearCoreData:entirely inManagedObjectContext: self.privateContext];
    self.page = 0;
    [self.imageOperations removeAllObjects];
    [SLVStorageService saveInContext:self.privateContext];
}

- (void)makeFavorite:(BOOL)favorite {
    self.selectedItem.isFavorite = favorite;
    [SLVStorageService saveInContext:self.privateContext];
}

- (void)getFavoriteItemsWithCompletionHandler:(void (^)(NSArray *))completionHandler {
    [SLVStorageService fetchEntities:@"SLVItem" withPredicate:@"isFavorite == YES" inManagedObjectContext:self.mainContext withCompletionBlock:^(NSArray *result) {
        completionHandler(result);
    }];
}


- (void)loadImageForItem:(SLVItem *)currentItem withCompletionHandler:(void (^)(UIImage *image))completionHandler {
    if (![SLVStorageService imageForKey:currentItem.thumbnailURL inManagedObjectContext:self.mainContext]) {
        ImageDownloadOperation *imageDownloadOperation = [ImageDownloadOperation new];
        imageDownloadOperation.key = currentItem.thumbnailURL;
        imageDownloadOperation.url = currentItem.largePhotoURL;
        imageDownloadOperation.session = self.session;
        imageDownloadOperation.context = self.privateContext;
        imageDownloadOperation.large = YES;
        imageDownloadOperation.name = [NSString stringWithFormat:@"imageDownloadOperation for url %@",currentItem.largePhotoURL];
        imageDownloadOperation.completionBlock = ^{
            UIImage *image = [SLVStorageService imageForKey:currentItem.thumbnailURL inManagedObjectContext:self.mainContext];
            completionHandler(image);
        };
        [self.imagesQueue addOperation:imageDownloadOperation];
    } else {
        UIImage *image = [SLVStorageService imageForKey:currentItem.thumbnailURL inManagedObjectContext:self.mainContext];
        completionHandler(image);
    }
}

- (void)cancelOperations {
    [self.imageOperations enumerateKeysAndObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id key, id object, BOOL *stop) {
        ImageDownloadOperation *operation = (ImageDownloadOperation *)object;
        if (operation.isExecuting) {
            [operation pause];
        }
    }];
}

- (void)resumeOperations {
    [self.imageOperations enumerateKeysAndObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id key, id object, BOOL *stop) {
        ImageDownloadOperation *operation = (ImageDownloadOperation *)object;
        if (operation.isCancelled) {
            [operation resume];
        }
    }];
}

@end
