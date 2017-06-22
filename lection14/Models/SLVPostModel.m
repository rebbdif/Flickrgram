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
@property (nonatomic, strong) NSDictionary<NSNumber *, NSString *> *items;
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

- (SLVItem *)itemForIndex:(NSUInteger)index {
    NSString *key = self.items[@(index)];
    SLVItem *result = [self.facade.storageService fetchEntity:kItemEntity forKey:key];
    return result;
}

- (void)passSelectedItem:(SLVItem *)selectedItem {
    self.selectedItem = selectedItem;
    self.items = @{@0: selectedItem.identifier};
}

- (SLVItem *)getSelectedItem {
    NSString *key = self.items[@0];
    self.selectedItem = [self.storageService fetchEntity:kItemEntity forKey:key];
    return self.selectedItem;
}

- (UIImage *)imageForIndex:(NSUInteger)index {
    UIImage *image = [UIImage imageWithContentsOfFile:self.selectedItem.largePhoto];
    return image;
}

- (void)makeFavorite:(BOOL)favorite {
    self.selectedItem.isFavorite = favorite;
    [self.storageService save];
}

- (void)getFavoriteItemsWithCompletionHandler:(void (^)(NSArray *))completionHandler {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isFavorite ==YES"];
    NSArray *result = [self.storageService fetchEntities:kItemEntity withPredicate:predicate];
    completionHandler(result);
}

- (void)loadImageForItem:(SLVItem *)item withCompletionHandler:(void (^)(void))completionHandler {
    [self.facade loadImageForEntity:kItemEntity withIdentifier:item.identifier forURL:item.largePhotoURL forAttribute:@"largePhoto" withCompletionHandler:completionHandler];
}

@end
