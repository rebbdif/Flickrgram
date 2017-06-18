//
//  SLVCollectionModel.m
//  lection14
//
//  Created by iOS-School-1 on 04.05.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import "SLVCollectionModel.h"
#import "SLVItem.h"

@interface SLVCollectionModel()

@property (nonatomic, assign) NSUInteger page;
@property (nonatomic, copy) NSDictionary<NSNumber *, NSString *> *items;
@property (nonatomic, strong) id<SLVFacadeProtocol> facade;

@end

@implementation SLVCollectionModel

- (instancetype)initWithFacade:(id<SLVFacadeProtocol>)facade {
    self = [super initWithFacade:facade];
    if (self) {
        _page = 1;
        _items = [NSDictionary new];
        _facade = facade;
    }
    return self;
}

- (NSUInteger)numberOfItems {
    return self.items.count;
}

- (UIImage *)imageForIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (void)getItemsForRequest:(NSString*)request withCompletionHandler:(void (^)(void))completionHandler {
    NSURL *url = [self constructURLForRequest:request];
    [self.facade getModelFromURL:url withCompletionHandler:^(NSDictionary *json) {
        NSDictionary<NSNumber *, NSString *> *newItems = [self parseData:json];
        NSMutableDictionary<NSNumber *, NSString *> *oldItems = [self.items mutableCopy];
        [oldItems addEntriesFromDictionary:newItems];
        self.items = [oldItems copy];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler();
        });
    }];
    self.page++;
}

- (NSURL *)constructURLForRequest:(NSString *)request {
    NSString *normalizedRequest = [request stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *escapedString = [normalizedRequest stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSString *apiKey = @"&api_key=6a719063cc95dcbcbfb5ee19f627e05e";
    NSString *urls = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&format=json&nojsoncallback=1&per_page=30&tags=%@%@&page=%lu", escapedString,apiKey, self.page];
    return [NSURL URLWithString:urls];
}

- (NSDictionary *)parseData:(NSDictionary *)json {
    if (json) {
        NSMutableDictionary<NSNumber *, NSString *> *parsingResults = [NSMutableDictionary new];
        NSUInteger index = self.items.count;
        for (NSDictionary * dict in json[@"photos"][@"photo"]) {
            SLVItem *item = [SLVItem itemWithDictionary:dict facade:self.facade];
            [parsingResults setObject:item.identifier forKey:@(index)];
            ++index;
        }
        return [parsingResults copy];
    } else {
        return nil;
    }
}

@end
