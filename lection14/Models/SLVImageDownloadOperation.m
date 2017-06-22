//
//  ImageDownloadOperation.m
//  lection14
//
//  Created by 1 on 24.05.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import "SLVImageDownloadOperation.h"
#import "SLVCollectionModel.h"
#import "SLVImageProcessing.h"

@interface SLVImageDownloadOperation()

@property (nonatomic, strong) NSOperationQueue *innerQueue;
@property (nonatomic, strong) NSURLSessionTask *task;
@property (nonatomic, strong) NSOperation *downloadOperation;
@property (nonatomic, strong) NSOperation *saveOperation;
@property (nonatomic, strong) __block NSString *downloadedImageURL;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *attribute;
@property (nonatomic, strong) NSString *entityName;
@property (nonatomic, strong) id<SLVFacadeProtocol> facade;
@property (nonatomic, strong) dispatch_semaphore_t imageDownloadSemaphore;
@property (nonatomic, strong) dispatch_semaphore_t imageSaveSemaphore;

@end

@implementation SLVImageDownloadOperation

- (instancetype)initWithFacade:(id<SLVFacadeProtocol>)facade entity:(NSString *)entityName key:(NSString *)key url:(NSString *)url attribute:(NSString *)attribute {
    self = [super init];
    if (self) {
        _status = SLVImageStatusNone;
        _innerQueue = [NSOperationQueue new];
        _facade = facade;
        _entityName = entityName;
        _key = key;
        _url = url;
        _attribute = attribute;
    }
    return self;
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
        self.status = SLVImageStatusNone;
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

- (void)pause {
    self.status = SLVImageStatusCancelled;
    [self.task suspend];
    [self cancel];
}

@end
