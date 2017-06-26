//
//  SLVFavoritesModel.h
//  flickrgram
//
//  Created by 1 on 26.06.17.
//  Copyright © 2017 serebryanyy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLVFacadeProtocol.h"

@class SLVItem;

@interface SLVFavoritesModel : NSObject

- (instancetype)initWithFacade:(id<SLVFacadeProtocol>)facade;

- (void)getFavoriteItemsWithCompletionHandler:(void (^)(void))completionHandler;

- (SLVItem *)itemForIndex:(NSUInteger)index;

- (NSUInteger)numberOfItems;

@end
