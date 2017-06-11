//
//  searchResultsModel.h
//  lection14
//
//  Created by iOS-School-1 on 04.05.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage;
@class SLVItem;
@class ImageDownloadOperation;
@class SLVNetworkManager;
@class NSManagedObjectContext;

@interface SLVSearchResultsModel : NSObject

typedef void (^Block)(void);

@property (copy, nonatomic) NSArray<SLVItem *> *items;
@property (strong, nonatomic) NSString *searchRequest;
@property (strong, nonatomic) NSManagedObjectContext *mainContext;
@property (strong, nonatomic) NSManagedObjectContext *privateContext;
@property (strong, nonatomic) SLVItem *selectedItem;

- (void)getItemsForRequest:(NSString *)request withCompletionHandler:(Block)completionHandler;
- (UIImage *)imageForIndexPath:(NSIndexPath *)indexPath;
- (UIImage *)imageForKey:(NSString *)key;
- (void)loadThumbnailForIndexPath:(NSIndexPath *)indexPath withCompletionHandler:(void(^)(void))completionHandler;
- (void)loadImageForItem:(SLVItem *)currentItem withCompletionHandler:(void (^)(UIImage *image))completionHandler;
- (void)cancelOperations;
- (void)resumeOperations;
- (void)clearModel:(BOOL)entirely;
- (void)makeFavorite:(BOOL)favorite;
- (void)getFavoriteItemsWithCompletionHandler:(void (^)(NSArray *result))completionHandler;
- (UIImage *)thumbnailForIndexPath:(NSIndexPath *)indexPath;
- (UIImage *)thumbnailForKey:(NSString *)key;

@end
