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

@interface SLVSearchResultsModel : NSObject

@property (copy, nonatomic) NSArray<SLVItem *> *items;
@property (strong, nonatomic) NSString *searchRequest;
@property (strong, nonatomic) NSCache *imageCache;
@property (strong, nonatomic) SLVItem *selectedItem;

- (void)getItemsForRequest:(NSString *)request withCompletionHandler: (void (^)(void))completionHandler;
- (void)loadImageForIndexPath:(NSIndexPath *)indexPath withCompletionHandler:(void(^)(void))completionHandler;
- (void)loadImageForItem:(SLVItem *)currentItem withCompletionHandler:(void(^)(void))completionHandler;
- (void)cancelOperations;
- (void)resumeOperations;
- (void)filterItemAtIndexPath:(NSIndexPath *)indexPath filter:(BOOL)filter withCompletionBlock:(void(^)(UIImage *image))completion;
- (void)clearModel;

@end
