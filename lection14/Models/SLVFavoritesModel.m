//
//  SLVFavoritesModel.m
//  flickrgram
//
//  Created by 1 on 26.06.17.
//  Copyright © 2017 serebryanyy. All rights reserved.
//

#import "SLVFavoritesModel.h"
#import "SLVItem.h"
@import UIKit;

static NSString *const kItemEntity = @"SLVItem";

@interface SLVFavoritesModel()

@property (nonatomic, strong) NSDictionary<NSNumber *, NSString *> *items;
@property (nonatomic, strong, readonly) id<SLVStorageProtocol> storageService;
@property (nonatomic, strong, readonly) id<SLVNetworkProtocol> networkManager;
@property (nonatomic, strong, readonly) id<SLVFacadeProtocol> facade;

@end

@implementation SLVFavoritesModel

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

- (UIImage *)imageForIndex:(NSUInteger)index {
    SLVItem *item = [self itemForIndex:index];
    NSString *destinationPath = [NSHomeDirectory() stringByAppendingPathComponent:item.thumbnail];
    UIImage *image = [UIImage imageWithContentsOfFile:destinationPath];
    return image;
}

- (void)getFavoriteItemsWithCompletionHandler:(void (^)(NSArray *))completionHandler {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isFavorite ==YES"];
    NSArray *result = [self.storageService fetchEntities:kItemEntity withPredicate:predicate];
    completionHandler(result);
}


@end
