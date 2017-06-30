//
//  SLVPostModel.m
//  flickrgram
//
//  Created by 1 on 17.06.17.
//  Copyright © 2017 serebryanyy. All rights reserved.
//

#import "SLVPostModel.h"
#import "SLVItem.h"
#import "SLVHuman.h"
#import "SLVComment.h"
#import "SLVImageDownloader.h"

#import "SLVMetadataLoadOperation.h"

@import UIKit;

static NSString *const kItemEntity = @"SLVItem";

@interface SLVPostModel()

@property (nonatomic, strong) SLVItem *selectedItem;
@property (nonatomic, strong) SLVImageDownloader *imageDownloader;

@end

@implementation SLVPostModel

- (instancetype)initWithNetworkManager:(id<SLVNetworkProtocol>)networkManager storageService:(id<SLVStorageProtocol>)storageService {
    self = [super init];
    if (self) {
        _storageService = storageService;
        _networkManager = networkManager;
        _imageDownloader = [[SLVImageDownloader alloc] initWithNetworkManager:_networkManager storageService:_storageService];
    }
    return self;
}

- (void)passSelectedItem:(SLVItem *)selectedItem {
    self.selectedItem = selectedItem;
}

- (SLVItem *)getSelectedItem {
    return self.selectedItem;
}

- (void)makeFavorite:(BOOL)favorite {
    self.selectedItem.isFavorite = favorite;
    [self.storageService save];
}

- (void)loadImageForItem:(SLVItem *)item withCompletionHandler:(voidBlock)completionHandler {
    [self.imageDownloader loadImageForEntity:kItemEntity withIdentifier:item.identifier forURL:item.largePhotoURL forAttribute:@"largePhoto" withCompletionHandler:completionHandler];
}

#pragma mark - metadata

- (void)getMetadataForSelectedItemWithCompletionHandler:(voidBlock)completionHandler {
    SLVMetadataLoadOperation *loadOperation = [[SLVMetadataLoadOperation alloc] initWithItem:self.selectedItem storageService:self.storageService networkManager:self.networkManager];
    loadOperation.completionBlock = completionHandler;
    NSOperationQueue *queue = [NSOperationQueue new];
    queue.qualityOfService = QOS_CLASS_DEFAULT;
    [queue addOperation:loadOperation];
}

@end
