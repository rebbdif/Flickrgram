//
//  SLVPostModelProtocol.h
//  flickrgram
//
//  Created by 1 on 17.06.17.
//  Copyright © 2017 serebryanyy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UIImage;
@class SLVItem;

@protocol SLVPostModelProtocol <NSObject>

#pragma mark - SLVPost&FavoritesMethods
- (void)loadImageForItem:(SLVItem *)currentItem withCompletionHandler:(void (^)(UIImage *image))completionHandler;
- (UIImage *)imageForIndexPath:(NSIndexPath *)indexPath;
- (UIImage *)imageForKey:(NSString *)key;
- (void)makeFavorite:(BOOL)favorite;
- (void)setSelectedItem:(SLVItem *)selectedItem;
- (SLVItem *)getSelectedItem;
- (void)getFavoriteItemsWithCompletionHandler:(void (^)(NSArray *result))completionHandler;

@end
