//
//  SLVModel.m
//  flickrgram
//
//  Created by 1 on 18.06.17.
//  Copyright © 2017 serebryanyy. All rights reserved.
//

#import "SLVImageDownloader.h"
#import "SLVImageDownloadOperation.h"

@interface SLVImageDownloader()

@property (nonatomic, strong) NSOperationQueue *imageDownloadQueue;

@end

@implementation SLVImageDownloader

#pragma mark - Lifecycle

- (instancetype)initWithNetworkManager:(id<SLVNetworkProtocol>)networkManager storageService:(id<SLVStorageProtocol>) storageService {
    self = [super init];
    if (self) {
        _networkManager = networkManager;
        _storageService = storageService;
        _imageDownloadQueue = [NSOperationQueue new];
        _imageDownloadQueue.qualityOfService = QOS_CLASS_DEFAULT;
    }
    return self;
}

#pragma mark - Operations

- (void)cancelOperations {
    for (SLVImageDownloadOperation *operation in self.imageDownloadQueue.operations) {
        [operation pause];
    };
}

#pragma mark - Network

- (void)loadImageForEntity:(NSString *)entityName withIdentifier:(NSString *)identifier forURL:(NSString *)url forAttribute:(NSString *)attribute withCompletionHandler:(void (^)(void))completionHandler {
    SLVImageDownloadOperation *imageDownloadOperation = [[SLVImageDownloadOperation alloc] initWithNetworkManager:self.networkManager storageService:self.storageService entity:entityName key:identifier url:url attribute:attribute completion:^{
        completionHandler();
    }];
    [self.imageDownloadQueue addOperation:imageDownloadOperation];
}

@end
