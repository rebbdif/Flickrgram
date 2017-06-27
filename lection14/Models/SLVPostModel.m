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
@property (nonatomic, strong, readonly) id<SLVStorageProtocol> storageService;
@property (nonatomic, strong, readonly) id<SLVNetworkProtocol> networkManager;

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
    
    NSString *path = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.getInfo&format=json&nojsoncallback=1&%@&%@&%@", apiKey, photoID, secret];
    NSURL *url = [NSURL URLWithString:path];
    [self.networkManager getJSONFromURL:url withCompletionHandler:^(NSDictionary *json) {
        [self parse:json];
        if (completionHandler) completionHandler();
    }];
}

- (void)parse:(NSDictionary *)json {
    NSDictionary *photo = json[@"photo"];
    NSArray *comments = photo[@"comments"];
    NSString *country = photo[@"location"][@"country"][@"_content"];
    NSString *city = photo[@"location"][@"locality"][@"_content"];
    NSString *location = [NSString stringWithFormat:@"%@, %@", city, country];
    for (NSDictionary *comment in comments) {
        SLVComment *newComent = [SLVComment commentWithDictionary:comment storage:self.storageService];
        
    }
    SLVHuman *owner = [SLVHuman humanWithDictionary:photo[@"owner"] storage:self.storageService];
    [self.selectedItem addAuthor:owner storage:self.storageService];
    self.selectedItem.location = location;
    [self.storageService save];
}

- (void)getAvatarForHuman:(SLVHuman *)human withCompletionHandler:(void (^)(UIImage *))completionHandler {
    NSURL *url = [NSURL URLWithString:human.avatarURL];
    __weak typeof(self)weakSelf = self;
    [self.networkManager getDataFromURL:url withCompletionHandler:^(NSData *data) {
        UIImage *avatar = [UIImage imageWithData:data];
        human.avatar = avatar;
        [weakSelf.storageService save];
        completionHandler(avatar);
    }];
}


@end
