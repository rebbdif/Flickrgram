//
//  SLVPostModel.m
//  flickrgram
//
//  Created by 1 on 17.06.17.
//  Copyright © 2017 serebryanyy. All rights reserved.
//

#import "SLVPostModel.h"

@implementation SLVPostModel

- (instancetype)initWithFacade:(id<SLVFacadeProtocol>)facade {
    self = [super initWithFacade:facade];
    if (self) {
        
    }
    return self;
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



@end
