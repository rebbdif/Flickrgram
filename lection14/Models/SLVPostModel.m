//
//  SLVPostModel.m
//  flickrgram
//
//  Created by 1 on 17.06.17.
//  Copyright © 2017 serebryanyy. All rights reserved.
//

#import "SLVPostModel.h"
#import "SLVItem.h"

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

- (UIImage *)imageForIndexPath:(NSIndexPath *)indexPath {
    return self.selectedItem.largePhoto;
}

- (void)makeFavorite:(BOOL)favorite {
    self.selectedItem.isFavorite = favorite;
    [self.facade save];
}

- (void)getFavoriteItemsWithCompletionHandler:(void (^)(NSArray *))completionHandler {
    [self.facade fetchEntities:@"SLVItem" withPredicate:@"isFavorite == YES" withCompletionBlock:^(NSArray *result) {
        completionHandler(result);
    }];
}

@end
