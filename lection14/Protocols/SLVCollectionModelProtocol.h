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

@protocol SLVCollectionModelProtocol <NSObject>

- (NSUInteger)numberOfItems;
- (void)cancelOperations;
- (void)resumeOperations;
- (void)clearModel:(BOOL)entirely;

- (void)getItemsForRequest:(NSString*) request withCompletionHandler:(void (^)(void))completionHandler;
- (void)loadImageForItem:(SLVItem *)currentItem withCompletionHandler:(void (^)(UIImage *image))completionHandler;
- (UIImage *)imageForIndexPath:(NSIndexPath *)indexPath;
- (UIImage *)imageForKey:(NSString *)key;

@end
