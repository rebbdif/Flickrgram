//
//  SLVPostModel.m
//  flickrgram
//
//  Created by 1 on 17.06.17.
//  Copyright © 2017 serebryanyy. All rights reserved.
//

#import "SLVPostModel.h"
#import "SLVItem.h"
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

- (void)loadImageForItem:(SLVItem *)item withCompletionHandler:(void (^)(void))completionHandler {
    [self.facade loadImageForEntity:kItemEntity withIdentifier:item.identifier forURL:item.largePhotoURL forAttribute:@"largePhoto" withCompletionHandler:completionHandler];
}

@end
