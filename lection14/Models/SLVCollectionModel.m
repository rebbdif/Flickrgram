//
//  SLVCollectionModel.m
//  lection14
//
//  Created by iOS-School-1 on 04.05.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import "SLVCollectionModel.h"
#import "SLVItem.h"
#import "SLVStorageProtocol.h"
#import "SLVNetworkManager.h"
#import "SLVImageDownloader.h"

@import UIKit;

static NSString *const kItemEntity = @"SLVItem";

@interface SLVCollectionModel()

@property (nonatomic, assign) NSUInteger page;
@property (nonatomic, copy) NSDictionary<NSNumber *, NSString *> *items;
@property (nonatomic, copy) NSDictionary<NSNumber *, NSString *> *itemURLs;
@property (nonatomic, copy) NSString *request;
@property (nonatomic, strong) SLVImageDownloader *imageDownloader;

@end

@implementation SLVCollectionModel

- (instancetype)initWithNetworkManager:(id<SLVNetworkProtocol>)networkManager storageService:(id<SLVStorageProtocol>)storageService {
    self = [super init];
    if (self) {
        _page = 1;
        _items = [NSDictionary new];
        _itemURLs = [NSDictionary new];
        _storageService = storageService;
        _networkManager = networkManager;
        _imageDownloader = [[SLVImageDownloader alloc] initWithNetworkManager:_networkManager storageService:_storageService];
    }
    return self;
}

#pragma mark - first start

- (void)firstStart:(NSString *)searchRequest withCompletionHandler:(voidBlock)completionHandler {
    self.request = searchRequest;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"searchRequest == %@", searchRequest];
    NSArray<SLVItem *> *fetchedItems = [self.storageService fetchEntities:kItemEntity withPredicate:predicate];
    NSUInteger index = 0;
    NSMutableDictionary<NSNumber *, NSString *> *newItems = [NSMutableDictionary new];
    for (SLVItem *item in fetchedItems) {
        [newItems setObject:item.identifier forKey:@(index)];
        ++index;
    }
    self.items = newItems;
    self.itemURLs = newItems;
    ++self.page;
    completionHandler();
}

#pragma mark - downloading items for search request

- (void)getItemsForRequest:(NSString *)request withCompletionHandler:(void (^)(void))completionHandler {
    if (!request) {
        request = self.request;
    } else {
        self.request = request;
    }
    NSURL *url = [self constructURLForRequest:request];
    [self.networkManager getJSONFromURL:url withCompletionHandler:^(NSDictionary *json) {
        NSDictionary<NSNumber *, NSString *> *newItems = [self parseData:json];
        NSMutableDictionary<NSNumber *, NSString *> *oldItems = [self.items mutableCopy];
        [oldItems addEntriesFromDictionary:newItems];
        self.items = [oldItems copy];
        self.itemURLs = [NSDictionary dictionaryWithDictionary:self.items];
        completionHandler();
    }];
    self.page++;
}

- (NSDictionary *)parseData:(NSDictionary *)json {
    if (json) {
        NSMutableDictionary<NSNumber *, NSString *> *parsingResults = [NSMutableDictionary new];
        NSUInteger index = self.items.count;
        for (NSDictionary * dict in json[@"photos"][@"photo"]) {
            NSString *itemIdentifier = [SLVItem identifierForItemWithDictionary:dict storage:self.storageService forRequest:self.request];
            [parsingResults setObject:itemIdentifier forKey:@(index)];
            ++index;
        }
        return [parsingResults copy];
    } else {
        return nil;
    }
}

- (NSURL *)constructURLForRequest:(NSString *)request {
    NSString *normalizedRequest = [request stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *escapedString = [normalizedRequest stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    const char apiKeyChar[] = "&api_key=6a719063cc95dcbcbfb5ee19f627e05e";
    NSString *apiKey = [NSString stringWithCString:apiKeyChar encoding:1];
    NSString *sortBy = @"interestingness-desc";
    NSString *urls = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&format=json&nojsoncallback=1&per_page=30&tags=%@%@&sort=%@&page=%lu", escapedString, apiKey, sortBy, self.page];
    return [NSURL URLWithString:urls];
}

#pragma mark - returning data to viewController

- (UIImage *)imageForIndex:(NSUInteger)index {
    NSString *key = self.items[@(index)];
    SLVItem *item = [self.storageService fetchEntity:kItemEntity forKey:key];
    NSString *destinationPath = [NSHomeDirectory() stringByAppendingPathComponent:item.thumbnail];
    UIImage *result = [UIImage imageWithContentsOfFile:destinationPath];
    return result;
}

- (void)loadImageForIndex:(NSUInteger)index withCompletionHandler:(void (^)(void))completionHandler {
    NSString *identifier = self.items[@(index)];
    NSString *url = self.itemURLs[@(index)];
    [self.imageDownloader loadImageForEntity:kItemEntity withIdentifier:identifier forURL:url forAttribute:@"thumbnail" withCompletionHandler:completionHandler];
}

- (NSUInteger)numberOfItems {
    if (!self.items.count) return 0;
    return self.items.count;
}

- (SLVItem *)itemForIndex:(NSUInteger)index {
    NSString *key = self.items[@(index)];
    SLVItem *result = [self.storageService fetchEntity:kItemEntity forKey:key];
    return result;
}

#pragma mark - utilities

- (void)clearModel {
    self.items = [NSDictionary new];
    self.page = 1;
    [self.imageDownloader cancelOperations];
    NSPredicate *predicate  = [NSPredicate predicateWithFormat:@"isFavorite ==NO"];
    [self.storageService deleteEntities:kItemEntity withPredicate:predicate];
}

- (void)pauseDownloads {
    [self.imageDownloader cancelOperations];
}

@end
