//
//  SLVPostModel.m
//  flickrgram
//
//  Created by 1 on 17.06.17.
//  Copyright © 2017 serebryanyy. All rights reserved.
//

#import "SLVPostModel.h"
#import "SLVItem.h"

static NSString *const kItemEntity = @"SLVItem";

@interface SLVPostModel()

@property (nonatomic, strong) id<SLVFacadeProtocol> facade;
@property (nonatomic, strong) SLVItem *selectedItem;

@end

@implementation SLVPostModel

- (instancetype)initWithFacade:(id<SLVFacadeProtocol>)facade {
    self = [super initWithFacade:facade];
    if (self) {
        _facade = facade;
    }
    return self;
}

- (void)setSelectedItem:(SLVItem *)selectedItem {
    _selectedItem = selectedItem;
}

- (SLVItem *)getSelectedItem {
    return self.selectedItem;
}

- (UIImage *)imageForIndex:(NSUInteger)index {
    
    return self.selectedItem.largePhoto;
}

- (void)makeFavorite:(BOOL)favorite {
    self.selectedItem.isFavorite = favorite;
    [self.facade save];
}

- (void)getFavoriteItemsWithCompletionHandler:(void (^)(NSArray *))completionHandler {
    [self.facade fetchEntities:kItemEntity withPredicate:@"isFavorite == YES" withCompletionBlock:^(NSArray *result) {
        completionHandler(result);
    }];
}

- (void)loadImageForItem:(SLVItem *)item withCompletionHandler:(void (^)(void))completionHandler {
    [self loadImageForEntity:kItemEntity withIdentifier:item.identifier forURL:item.largePhotoURL forAttribute:@"largePhoto" withCompletionHandler:completionHandler];
}

@end
