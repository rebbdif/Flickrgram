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
@property (nonatomic, strong) NSOperationQueue *imageSaveQueue;

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
        _imageSaveQueue = [NSOperationQueue new];
        _imageSaveQueue.qualityOfService = QOS_CLASS_DEFAULT;
    }
    return self;
}

#pragma mark - Operations

- (void)pauseOperations {
    [self.imageDownloadQueue cancelAllOperations];
}

#pragma mark - Network

- (void)loadImageForEntity:(NSString *)entityName withIdentifier:(NSString *)identifier forURL:(NSString *)url forAttribute:(NSString *)attribute withCompletionHandler:(void (^)(void))completionHandler {
    SLVImageDownloadOperation *imageDownloadOperation = [[SLVImageDownloadOperation alloc] initWithNetworkManager:self.networkManager storageService:self.storageService entity:entityName key:identifier url:url attribute:attribute];
    imageDownloadOperation.completionBlock = ^{
        completionHandler();
    };
}


- (void)main {
    NSAssert(_url, @"no url");
    NSAssert(_key, @"no key");
    
    [self.saveOperation addDependency:self.downloadOperation];
    self.imageDownloadSemaphore = dispatch_semaphore_create(0);
    self.imageSaveSemaphore = dispatch_semaphore_create(0);
    self.status = SLVImageStatusDownloading;
    
    [self dowloadImage];
    dispatch_semaphore_wait(self.imageDownloadSemaphore, DISPATCH_TIME_FOREVER);
    
    if (!_downloadedImageURL) {
        NSLog(@"NSOperation: there is no downloaded image");
        self.status = SLVImageStatusError;
    } else {
        [self saveImage];
        dispatch_semaphore_wait(self.imageSaveSemaphore, DISPATCH_TIME_FOREVER);
    }
}

- (void)dowloadImage {
    __weak typeof(self) weakSelf = self;
    self.downloadOperation = [NSBlockOperation blockOperationWithBlock:^{
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.task = [strongSelf.facade.networkManager downloadImageFromURL:[NSURL URLWithString:strongSelf.url] withCompletionHandler:^(NSString *downloadedImageURL) {
            strongSelf.downloadedImageURL = downloadedImageURL;
            strongSelf.status = SLVImageStatusDownloaded;
            dispatch_semaphore_signal(strongSelf.imageDownloadSemaphore);
        }];
    }];
    [self.innerQueue addOperation:self.downloadOperation];
}

- (void)saveImage {
    __weak typeof(self) weakSelf = self;
    self.saveOperation = [NSBlockOperation blockOperationWithBlock:^{
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.facade.storageService saveObject:strongSelf.downloadedImageURL forEntity:strongSelf.entityName forAttribute:strongSelf.attribute forKey:strongSelf.key withCompletionHandler:^{
            dispatch_semaphore_signal(strongSelf.imageSaveSemaphore);
        }];
    }];
    [self.innerQueue addOperation:self.saveOperation];
}

- (void)resume {
    self.innerQueue.suspended = NO;
    [self.task resume];
}

- (void)cancel {
    self.status = SLVImageStatusCancelled;
    [self.task suspend];
    [self cancel];
}


@end
