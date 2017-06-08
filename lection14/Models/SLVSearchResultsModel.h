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

@property (copy, nonatomic) NSArray<SLVItem *> *items;
@property (strong, nonatomic) NSString *searchRequest;
@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) SLVItem *selectedItem;

- (void)getItemsForRequest:(NSString *)request withCompletionHandler: (void (^)(void))completionHandler;
- (UIImage *)imageForIndexPath:(NSIndexPath *)indexPath;
- (void)loadImageForIndexPath:(NSIndexPath *)indexPath withCompletionHandler:(void(^)(void))completionHandler;
- (void)imageForItem:(SLVItem *)currentItem withCompletionHandler:(void (^)(UIImage *image))completionHandler;
- (void)cancelOperations;
- (void)resumeOperations;
- (void)clearModel;

@end
