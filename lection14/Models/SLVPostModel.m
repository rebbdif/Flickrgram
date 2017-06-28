//
//  SLVPostModel.m
//  flickrgram
//
//  Created by 1 on 17.06.17.
//  Copyright © 2017 serebryanyy. All rights reserved.
//

#import "SLVPostModel.h"
#import "SLVItem.h"
#import "SLVHuman.h"
#import "SLVComment.h"
#import "SLVStorageProtocol.h"
#import "SLVNetworkProtocol.h"
@import UIKit;

static NSString *const kItemEntity = @"SLVItem";

@interface SLVPostModel()

@property (nonatomic, strong, readonly) id<SLVFacadeProtocol> facade;
@property (nonatomic, strong) SLVItem *selectedItem;

@end

@implementation SLVPostModel

- (instancetype)initWithFacade:(id<SLVFacadeProtocol>)facade {
    self = [super init];
    if (self) {
        _facade = facade;
        _storageService = facade.storageService;
        _networkManager = facade.networkManager;
    }
    return self;
}

- (void)passSelectedItem:(SLVItem *)selectedItem {
    self.selectedItem = selectedItem;
}

- (SLVItem *)getSelectedItem {
    return self.selectedItem;
}

- (void)makeFavorite:(BOOL)favorite {
    self.selectedItem.isFavorite = favorite;
    [self.storageService save];
}

- (void)loadImageForItem:(SLVItem *)item withCompletionHandler:(voidBlock)completionHandler {
    [self.facade loadImageForEntity:kItemEntity withIdentifier:item.identifier forURL:item.largePhotoURL forAttribute:@"largePhoto" withCompletionHandler:completionHandler];
}

#pragma mark - metadata

- (void)getMetadataForSelectedItemWithCompletionHandler:(voidBlock)completionHandler {
    const char apiKeyChar[] = "api_key=6a719063cc95dcbcbfb5ee19f627e05e";
    NSString *apiKey = [NSString stringWithCString:apiKeyChar encoding:1];
    NSString *photoID = [NSString stringWithFormat:@"photo_id=%@", self.selectedItem.photoID];
    NSString *secret = [NSString stringWithFormat:@"secret=%@", self.selectedItem.photoSecret];
    
    NSString *infoPath = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.getInfo&format=json&nojsoncallback=1&%@&%@&%@", apiKey, photoID, secret];
    NSURL *infoURL = [NSURL URLWithString:infoPath];
    [self.networkManager getJSONFromURL:infoURL withCompletionHandler:^(NSDictionary *json) {
        [self parseInfo:json];
        if (completionHandler) completionHandler();
    }];

    NSString *favoritesPath = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.getFavorites&format=json&nojsoncallback=1&%@&%@&", apiKey, photoID];
    NSURL *favoritesURL = [NSURL URLWithString:favoritesPath];
    [self.networkManager getJSONFromURL:favoritesURL withCompletionHandler:^(NSDictionary *json) {
        [self parseFavorites:json];
        if (completionHandler) completionHandler();
    }];
}

- (void)parseInfo:(NSDictionary *)json {
    NSDictionary *photo = json[@"photo"];
    
    NSString *country = photo[@"location"][@"country"][@"_content"];
    NSString *city = photo[@"location"][@"locality"][@"_content"];
    NSString *location = [NSString stringWithFormat:@"%@, %@", city, country];

    SLVHuman *owner = [SLVHuman humanWithDictionary:photo[@"owner"] storage:self.storageService];
    [self.selectedItem addAuthor:owner storage:self.storageService];
    self.selectedItem.location = location;
    NSString *numberOfComments = photo[@"comments"][@"_content"];
    self.selectedItem.numberOfComments = numberOfComments;
    [self.storageService save];
}

- (void)parseFavorites:(NSDictionary *)json {
    NSString *numberOfLikes = json[@"photo"][@"total"];
    self.selectedItem.numberOfLikes = numberOfLikes;
    [self.storageService save];
}

@end
