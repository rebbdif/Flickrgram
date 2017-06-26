//
//  SLVModel.m
//  flickrgram
//
//  Created by 1 on 18.06.17.
//  Copyright © 2017 serebryanyy. All rights reserved.
//

#import "SLVFacade.h"
#import "SLVImageDownloadOperation.h"

@interface SLVFacade()

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
    [self.imageOperations enumerateKeysAndObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id key, id object, BOOL *stop) {
        SLVImageDownloadOperation *operation = (SLVImageDownloadOperation *)object;
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

#pragma mark - Storage

- (void)destroyEverything {
    [self.storageService deleteEntities:@"SLVItem" withPredicate:nil];
    [self.storageService deleteEntities:@"Human" withPredicate:nil];
    [self.storageService deleteEntities:@"Comment" withPredicate:nil];
    [self.imageOperations removeAllObjects];
}

@end
