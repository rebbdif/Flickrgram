//
//  searchResultsModel.m
//  lection14
//
//  Created by iOS-School-1 on 04.05.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import "SLVSearchResultsModel.h"
#import "ImageDownloadOperation.h"
#import "SLVImageProcessing.h"
#import "SLVNetworkManager.h"
#import "SLVItem.h"
#import "SLVStorageService.h"

@interface SLVSearchResultsModel()

@property (assign, nonatomic) NSUInteger page;
@property (strong, nonatomic) NSMutableDictionary<NSIndexPath *, ImageDownloadOperation *> *imageOperations;
@property (strong, nonatomic) NSOperationQueue *imagesQueue;
@property (strong, nonatomic) SLVNetworkManager *networkManager;
@property (strong, nonatomic) NSURLSession *session;

@end

@implementation SLVSearchResultsModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _imageOperations = [NSMutableDictionary new];
        _imagesQueue = [NSOperationQueue new];
        _imagesQueue.name = @"imagesQueue";
        _imagesQueue.qualityOfService = QOS_CLASS_DEFAULT;
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        _page = 1;
        _items = [NSArray new];
    }
    return self;
}

- (void)getItemsForRequest:(NSString*) request withCompletionHandler:(void (^)(void))completionHandler {
    NSString *normalizedRequest = [request stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *escapedString = [normalizedRequest stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSString *apiKey = @"&api_key=6a719063cc95dcbcbfb5ee19f627e05e";
    NSString *urls = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&format=json&nojsoncallback=1&per_page=30&tags=%@%@&page=%lu",escapedString,apiKey,self.page];
    
    NSURL *url = [NSURL URLWithString:urls];
    [SLVNetworkManager getModelWithSession:self.session fromURL:url withCompletionHandler:^(NSDictionary *json) {
        NSArray *newItems = [self parseData:json];
        [SLVStorageService saveInContext:self.context];
        self.items = [self.items arrayByAddingObjectsFromArray:newItems];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler();
        });
    }];
    self.page++;
}

- (NSArray *)parseData:(NSDictionary *)json {
    if (json) {
        NSMutableArray *parsingResults = [NSMutableArray new];
        for (NSDictionary * dict in json[@"photos"][@"photo"]) {
            SLVItem *item = [SLVItem itemWithDictionary:dict inManagedObjectContext:self.context];
            [parsingResults addObject:item];
        }
        return [parsingResults copy];
    } else {
        return nil;
    }
}

- (UIImage *)imageForIndexPath:(NSIndexPath *)indexPath {
    SLVItem *currentItem = self.items[indexPath.row];
    NSString *key = currentItem.thumbnailURL;
    UIImage *image = [SLVStorageService imageForKey:key inManagedObjectContext:self.context];
    return image;
}

- (UIImage *)imageForKey:(NSString *)key {
    UIImage *image = [SLVStorageService imageForKey:key inManagedObjectContext:self.context];
    return image;
}

- (void)loadImageForIndexPath:(NSIndexPath *)indexPath withCompletionHandler:(void(^)(void))completionHandler {
    SLVItem *currentItem = self.items[indexPath.row];
    if (![SLVStorageService imageForKey:currentItem.thumbnailURL inManagedObjectContext:self.context]) {
        if (!self.imageOperations[indexPath]) {
            ImageDownloadOperation *imageDownloadOperation = [ImageDownloadOperation new];
            imageDownloadOperation.indexPath = indexPath;
            imageDownloadOperation.key = currentItem.thumbnailURL;
            imageDownloadOperation.url = currentItem.thumbnailURL;
            imageDownloadOperation.session = self.session;
            imageDownloadOperation.context = self.context;
            imageDownloadOperation.name = [NSString stringWithFormat:@"imageDownloadOperation for index %lu",indexPath.row];
            imageDownloadOperation.completionBlock = ^{
                completionHandler();
            };
            [self.imageOperations setObject:imageDownloadOperation forKey:indexPath];
            [self.imagesQueue addOperation:imageDownloadOperation];
        } else {
            if (self.imageOperations[indexPath].status == SLVImageStatusCancelled || self.imageOperations[indexPath].status == SLVImageStatusNone) {
                [self.imageOperations[indexPath] resume];
            }
        }
    } else {
        completionHandler();
    }
}

- (void)loadImageForItem:(SLVItem *)currentItem withCompletionHandler:(void (^)(UIImage *image))completionHandler {
    if (![SLVStorageService imageForKey:currentItem.largePhotoURL inManagedObjectContext:self.context]) {
        ImageDownloadOperation *imageDownloadOperation = [ImageDownloadOperation new];
        imageDownloadOperation.key = currentItem.thumbnailURL;
        imageDownloadOperation.url = currentItem.largePhotoURL;
        imageDownloadOperation.session = self.session;
        imageDownloadOperation.context = self.context;
        imageDownloadOperation.name = [NSString stringWithFormat:@"imageDownloadOperation for url %@",currentItem.largePhotoURL];
        imageDownloadOperation.completionBlock = ^{
            UIImage *image = [SLVStorageService imageForKey:currentItem.thumbnailURL inManagedObjectContext:self.context];
            completionHandler(image);
        };
        [self.imagesQueue addOperation:imageDownloadOperation];
    } else {
        UIImage *image = [SLVStorageService imageForKey:currentItem.thumbnailURL inManagedObjectContext:self.context];
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

- (void)clearModel {
    self.items = [NSArray new];
    [SLVStorageService clearCoreData:self.context];
    self.page = 0;
    [self.imageOperations removeAllObjects];
}

- (void)makeFavorite:(BOOL)favorite {
    self.selectedItem.isFavorite = favorite;
    [SLVStorageService saveInContext:self.context];
}

- (void)getFavoriteItemsWithCompletionHandler:(Block)completionHandler {
    [SLVStorageService fetchEntities:@"SLVItem" withPredicate:@"isFavorite == YES" inManagedObjectContext:self.context withCompletionBlock:^(NSArray *result) {
        completionHandler();
    }];
}


@end
