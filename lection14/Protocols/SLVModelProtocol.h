//
//  SLVCollectionModelProtocol
//  lection14
//
//  Created by 1 on 17.06.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UIImage;
@class SLVItem;

typedef void (^Block)(void);

@protocol SLVModelProtocol <NSObject>

- (NSUInteger)numberOfItems;
- (void)cancelOperations;
- (void)resumeOperations;
- (void)clearModel:(BOOL)entirely;

- (void)loadThumbnailForIndexPath:(NSIndexPath *)indexPath withCompletionHandler:(void(^)(void))completionHandler;
- (UIImage *)thumbnailForIndexPath:(NSIndexPath *)indexPath;
- (UIImage *)thumbnailForKey:(NSString *)key;
- (void)getItemsForRequest:(NSString *)request withCompletionHandler:(Block)completionHandler;


@end
