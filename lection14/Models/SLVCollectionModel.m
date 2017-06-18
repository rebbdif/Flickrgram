//
//  SLVCollectionModel.m
//  lection14
//
//  Created by iOS-School-1 on 04.05.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import "SLVCollectionModel.h"
#import "SLVImageDownloadOperation.h"
#import "SLVImageProcessing.h"
#import "SLVNetworkManager.h"
#import "SLVItem.h"
#import "SLVStorageService.h"

@interface SLVCollectionModel()

@property (assign, nonatomic) NSUInteger page;
@property (strong, nonatomic) SLVNetworkManager *networkManager;
@property (copy, nonatomic) NSArray<SLVItem *> *items;

@end

@implementation SLVCollectionModel

- (instancetype)initWithFacade:(id<SLVFacadeProtocol>)facade {
    self = [super initWithFacade:facade];
    if (self) {
        _page = 1;
        _items = [NSArray new];
    }
    return self;
}

- (NSUInteger)numberOfItems {
    return self.items.count;
}

- (void)getItemsForRequest:(NSString*) request withCompletionHandler:(void (^)(void))completionHandler {
    NSString *normalizedRequest = [request stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *escapedString = [normalizedRequest stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSString *apiKey = @"&api_key=6a719063cc95dcbcbfb5ee19f627e05e";
    NSString *urls = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&format=json&nojsoncallback=1&per_page=30&tags=%@%@&page=%lu", escapedString,apiKey, self.page];
    
    NSURL *url = [NSURL URLWithString:urls];
    [SLVNetworkManager getModelWithSession:self.session fromURL:url withCompletionHandler:^(NSDictionary *json) {
        NSArray *newItems = [self parseData:json];
        [SLVStorageService saveInContext:self.privateContext];
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
            SLVItem *item = [SLVItem itemWithDictionary:dict inManagedObjectContext:self.privateContext];
            [parsingResults addObject:item];
        }
        return [parsingResults copy];
    } else {
        return nil;
    }
}





@end
