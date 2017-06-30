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

@property (nonatomic, strong) NSMutableDictionary<NSString *, SLVImageDownloadOperation *> *imageOperations;
@property (nonatomic, strong) NSOperationQueue *imagesQueue;

@end

@implementation SLVFacade

#pragma mark - Lifecycle

- (instancetype)initWithNetworkManager:(id<SLVNetworkProtocol>)networkManager storageService:(id<SLVStorageProtocol>) storageService {
    self = [super init];
    if (self) {
        _networkManager = networkManager;
        _storageService = storageService;
        _imageOperations = [NSMutableDictionary new];
        _imagesQueue = [NSOperationQueue new];
        _imagesQueue.qualityOfService = QOS_CLASS_DEFAULT;
    }
    return self;
}

#pragma mark - Operations

- (void)pauseOperations {
    [self.imageOperations enumerateKeysAndObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id key, SLVImageDownloadOperation *operation, BOOL *stop) {
        if (operation.isExecuting) {
            [operation pause];
        }
    }];
}

- (void)clearOperations {
    [self.imageOperations removeAllObjects];
}

#pragma mark - Network

- (void)loadImageForEntity:(NSString *)entityName withIdentifier:(NSString *)identifier forURL:(NSString *)url forAttribute:(NSString *)attribute withCompletionHandler:(void (^)(void))completionHandler {
    if (self.imageOperations[identifier].status == SLVImageStatusCancelled) {
        [self.imageOperations[identifier] resume];
    } else  {
        SLVImageDownloadOperation *imageDownloadOperation = [[SLVImageDownloadOperation alloc] initWithFacade:self entity:entityName key:identifier url:url attribute:attribute];
        imageDownloadOperation.completionBlock = ^{
            completionHandler();
        };
        [self.imageOperations setObject:imageDownloadOperation forKey:identifier];
        [self.imagesQueue addOperation:imageDownloadOperation];
    }
}


@end
