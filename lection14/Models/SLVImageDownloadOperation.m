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
@property (nonatomic, strong) __block UIImage *downloadedImage;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *attribute;
@property (nonatomic, strong) NSString *entityName;
@property (nonatomic, strong) id<SLVFacadeProtocol> facade;

@end

@implementation SLVImageDownloadOperation

- (instancetype)initWithFacade:(id<SLVFacadeProtocol>)facade entity:(NSString *)entityName key:(NSString *)key url:(NSString *)url attribute:(NSString *)attribute {
    self = [super init];
    if (self) {
        _status = SLVImageStatusNone;
        _innerQueue = [NSOperationQueue new];
        _imageViewSize = CGSizeMake(312, 312);
        _facade = facade;
        _entityName = entityName;
        _key = key;
        _url = url;
        _attribute = attribute;
    }
    return self;
}

- (void)main {
    dispatch_semaphore_t imageDownloadSemaphore = dispatch_semaphore_create(0);
    self.status = SLVImageStatusDownloading;
    
    __weak typeof(self) weakSelf = self;
    self.downloadOperation = [NSBlockOperation blockOperationWithBlock:^{
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.task = [strongSelf.facade downloadImageFromURL:[NSURL URLWithString:self.url] withCompletionHandler:^(NSData *data) {
            strongSelf.downloadedImage = [UIImage imageWithData:data];
            strongSelf.status = SLVImageStatusDownloaded;
            dispatch_semaphore_signal(imageDownloadSemaphore);
        }];
    }];
    
    [self.innerQueue addOperation:self.downloadOperation];
    dispatch_semaphore_wait(imageDownloadSemaphore, DISPATCH_TIME_FOREVER);
    
    if (!_downloadedImage) {
        NSLog(@"error when downloading image");
        self.status = SLVImageStatusNone;
    } else {
        self.saveOperation = [NSBlockOperation blockOperationWithBlock:^{
            [self.facade saveObject:self.downloadedImage forEntity:self.entityName forAttribute:self.attribute forKey:self.key];
        }];
        [self.saveOperation addDependency:self.downloadOperation];
        [self.innerQueue addOperation:self.saveOperation];
    }
}

- (void)resume {
    self.innerQueue.suspended = NO;
    [self.task resume];
    NSLog(@"operation %@ resumed", self.url);
}

- (void)pause {
    self.innerQueue.suspended = YES;
    self.status = SLVImageStatusCancelled;
    [self.task suspend];
    [self cancel];
    NSLog(@"operation %@ paused", self.url);
}

@end
