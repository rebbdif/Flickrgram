//
//  ImageDownloadOperation.m
//  lection14
//
//  Created by 1 on 24.05.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import "SLVImageDownloadOperation.h"
#import "SLVCollectionModel.h"
#import "SLVNetworkManager.h"
#import "SLVImageProcessing.h"
#import "SLVStorageService.h"


@interface SLVImageDownloadOperation()

@property (strong, nonatomic) NSOperationQueue *innerQueue;
@property (strong, nonatomic) NSURLSessionTask *task;
@property (strong, nonatomic) NSOperation *downloadOperation;
@property (strong, nonatomic) NSOperation *cropOperation;
@property (strong, nonatomic) NSOperation *applyFilterOperation;
@property (strong, nonatomic) __block UIImage *downloadedImage;

@end

@implementation SLVImageDownloadOperation

- (instancetype)initWithUrl:(NSString *)url andAttribute:(NSString *)attribute {
    self = [super init];
    if (self) {
        _status = SLVImageStatusNone;
        _innerQueue = [NSOperationQueue new];
        _imageViewSize = CGSizeMake(312, 312);
        _large = NO;
    }
    return self;
}

- (void)main {
    dispatch_semaphore_t imageDownloadedSemaphore = dispatch_semaphore_create(0);
    
    self.downloadOperation = [NSBlockOperation blockOperationWithBlock:^{
        __weak typeof(self) weakself = self;
        weakself.task = [SLVNetworkManager downloadImageWithSession:self.session fromURL:[NSURL URLWithString:self.url] withCompletionHandler:^(NSData *data) {
            weakself.downloadedImage = [UIImage imageWithData:data];
            weakself.status = SLVImageStatusDownloaded;
            dispatch_semaphore_signal(imageDownloadedSemaphore);
        }];
    }];
    
    self.status = SLVImageStatusDownloading;
    [self.innerQueue addOperation:self.downloadOperation];
    
    dispatch_semaphore_wait(imageDownloadedSemaphore, DISPATCH_TIME_FOREVER);
    
    if (self.downloadedImage) {
        [self saveImage:self.downloadedImage];
    } else {
        self.status = SLVImageStatusNone;
        NSLog(@"operation %@ failed", self.url);
    }
}

- (void)saveImage:(UIImage *)image {
    if (self.large == YES) {
        [SLVStorageService saveImage:image forKey:self.key inManagedObjectContext:self.context];
    } else {
        [SLVStorageService saveThumbnail:image forKey:self.key inManagedObjectContext:self.context];
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
    NSLog(@"operation %@ paused", (self.url);
}

@end
