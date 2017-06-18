//
//  SLVPostModelProtocol.h
//  flickrgram
//
//  Created by 1 on 17.06.17.
//  Copyright © 2017 serebryanyy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLVModelProtocol.h"

@class UIImage;
@class SLVItem;

@protocol SLVPostModelProtocol <SLVModelProtocol>

- (void)makeFavorite:(BOOL)favorite;

- (void)setSelectedItem:(SLVItem *)selectedItem;

- (SLVItem *)getSelectedItem;

- (UIImage *)imageForIndex:(NSUInteger)index;

- (void)getFavoriteItemsWithCompletionHandler:(void (^)(NSArray *result))completionHandler;

- (void)loadImageForItem:(SLVItem *)item withCompletionHandler:(void (^)(void))completionHandler;

@end
