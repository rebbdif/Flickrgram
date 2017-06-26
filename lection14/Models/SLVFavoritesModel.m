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

@property (nonatomic, strong) NSDictionary<NSNumber *, SLVItem *> *items;
@property (nonatomic, strong, readonly) id<SLVStorageProtocol> storageService;
@property (nonatomic, strong, readonly) id<SLVFacadeProtocol> facade;

@end

@implementation SLVFavoritesModel

- (instancetype)initWithFacade:(id<SLVFacadeProtocol>)facade {
    self = [super init];
    if (self) {
        _facade = facade;
        _storageService = facade.storageService;
        _items = [NSDictionary new];
    }
    return self;
}

- (SLVItem *)itemForIndex:(NSUInteger)index {
    return self.items[@(index)];
}

- (void)getFavoriteItemsWithCompletionHandler:(void (^)(void))completionHandler {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isFavorite ==YES"];
    NSArray *result = [self.storageService fetchEntities:kItemEntity withPredicate:predicate];
    NSUInteger index = 0;
    NSMutableDictionary *newItems = [NSMutableDictionary new];
    for (SLVItem *item in result) {
        newItems[@(index)] = item;
        ++index;
    }
    self.items = [newItems copy];
    completionHandler();
}

- (NSUInteger)numberOfItems {
    return self.items.count;
}

@end
