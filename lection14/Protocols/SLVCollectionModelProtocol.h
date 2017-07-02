//
//  SLVCollectionModelProtocol
//  lection14
//
//  Created by 1 on 17.06.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLVStorageProtocol.h"
#import "SLVNetworkProtocol.h"

@class UIImage;
@class SLVItem;

typedef void (^voidBlock)(void);

@protocol SLVCollectionModelProtocol <NSObject>

@property (nonatomic, strong, readonly) id<SLVStorageProtocol> storageService;
@property (nonatomic, strong, readonly) id<SLVNetworkProtocol> networkManager;

- (NSUInteger)numberOfItems;

- (SLVItem *)itemForIndex:(NSUInteger)index;

- (UIImage *)imageForIndex:(NSUInteger)index;

- (void)loadImageForIndex:(NSUInteger)index withCompletionHandler:(voidBlock)completionHandler;

- (void)getItemsForRequest:(NSString *)request withCompletionHandler:(voidBlock)completionHandler;

- (void)clearModel;

- (void)pauseDownloads;

- (void)firstStart:(NSString *)searchRequest withCompletionHandler:(voidBlock)completionHandler;

@end
