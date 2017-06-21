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

static NSString *const kItemEntity = @"SLVItem";

@interface SLVCollectionModel()

@property (nonatomic, strong, readonly) id<SLVStorageProtocol> storageService;
@property (nonatomic, strong, readonly) id<SLVNetworkProtocol> networkManager;
@property (nonatomic, assign) NSUInteger page;
@property (nonatomic, copy) NSDictionary<NSNumber *, NSString *> *items;
@property (nonatomic, copy) NSDictionary<NSNumber *, NSString *> *itemURLs;
@property (nonatomic, strong) id<SLVFacadeProtocol> facade;
@property (nonatomic, copy) NSString *request;

@end

@implementation SLVCollectionModel

- (instancetype)initWithFacade:(id<SLVFacadeProtocol>)facade {
    self = [super init];
    if (self) {
        _page = 1;
        _items = [NSDictionary new];
        _itemURLs = [NSDictionary new];
        _facade = facade;
        _storageService = facade.storageService;
        _networkManager = facade.networkManager;
    }
    return self;
}

- (NSUInteger)numberOfItems {
    return self.items.count;
}

- (SLVItem *)itemForIndex:(NSUInteger)index {
    NSString *key = self.items[@(index)];
    SLVItem *result = [self.storageService fetchEntity:kItemEntity forKey:key];
    return result;
}

- (UIImage *)imageForIndex:(NSUInteger)index {
    NSString *key = self.items[@(index)];
    SLVItem *item = [self.storageService fetchEntity:kItemEntity forKey:key];
    UIImage *result = item.thumbnail;
    return result;
}

- (void)loadImageForIndex:(NSUInteger)index withCompletionHandler:(void (^)(void))completionHandler {
    NSString *identifier = self.items[@(index)];
    NSString *url = self.itemURLs[@(index)];
    [self.facade loadImageForEntity:kItemEntity withIdentifier:identifier forURL:url forAttribute:@"thumbnail" withCompletionHandler:completionHandler];
}

- (void)getItemsForRequest:(NSString *)request withCompletionHandler:(void (^)(void))completionHandler {
    if (!request) {
        request = self.request;
    } else {
        self.request = request;
    }
    NSURL *url = [self constructURLForRequest:request];
    [self.networkManager getModelFromURL:url withCompletionHandler:^(NSDictionary *json) {
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
    NSString *apiKey = @"&api_key=6a719063cc95dcbcbfb5ee19f627e05e";
    NSString *urls = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&format=json&nojsoncallback=1&per_page=30&tags=%@%@&page=%lu", escapedString, apiKey, self.page];
    return [NSURL URLWithString:urls];
}

- (void)clearModel {
    NSLog(@"i clear model");
    self.items = [NSDictionary new];
    self.page = 1;
    [self.facade clearOperations];
    [self.storageService deleteEntities:kItemEntity withPredicate:@"isFavorite == NO"];
}

- (id<SLVFacadeProtocol>)getFacade {
    return self.facade;
}

- (void)resumeDownloads {
    [self.facade resumeOperations];
}

- (void)pauseDownloads {
    [self.facade pauseOperations];
}

- (void)firstStart:(NSString *)searchRequest {
    NSString *predicate = [NSString stringWithFormat:@"searchRequest == %@", searchRequest];
    NSArray<SLVItem *> *fetchedItems = [self.storageService fetchEntities:kItemEntity withPredicate:predicate];
    NSUInteger index = 0;
    NSMutableDictionary<NSNumber *, NSString *> *newItems = [NSMutableDictionary new];
    for (SLVItem *item in fetchedItems) {
        [newItems setObject:item.identifier forKey:@(index)];
        ++index;
    }
    self.items = newItems;
    self.itemURLs = newItems;
}

@end
