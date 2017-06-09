//
//  ImageDownloadOperation.m
//  lection14
//
//  Created by 1 on 24.05.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import "ImageDownloadOperation.h"
#import "SLVSearchResultsModel.h"
#import "SLVNetworkManager.h"
#import "SLVImageProcessing.h"
#import "SLVStorageService.h"


@interface ImageDownloadOperation()

@property (strong, nonatomic) NSOperationQueue *innerQueue;
@property (strong, nonatomic) NSURLSessionTask *task;
@property (strong, nonatomic) NSOperation *downloadOperation;
@property (strong, nonatomic) NSOperation *cropOperation;
@property (strong, nonatomic) NSOperation *applyFilterOperation;
@property (strong, nonatomic) __block UIImage *downloadedImage;

@end

@implementation ImageDownloadOperation

- (instancetype)init {
    self = [super init];
    if (self) {
        _status = SLVImageStatusNone;
        _innerQueue = [NSOperationQueue new];
        _innerQueue.name = [NSString stringWithFormat:@"innerQueue for index %lu",self.indexPath.row];
        _imageViewSize = CGSizeMake(312, 312);
    }
    return self;
}

- (void)main {
 //   NSLog(@"operation %ld began", (long)self.indexPath.row);
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
  //  NSLog(@"operation %ld downloading", (long)self.indexPath.row);
    [self.innerQueue addOperation:self.downloadOperation];
    
    
    dispatch_semaphore_wait(imageDownloadedSemaphore, DISPATCH_TIME_FOREVER);
  //  NSLog(@"operation %ld downloaded", (long)self.indexPath.row);
    
        if (self.downloadedImage) {
        [self saveImage:self.downloadedImage];
    } else {
        self.status = SLVImageStatusNone;
        NSLog(@"operation %ld failed", (long)self.indexPath.row);
    }
    NSLog(@"operation %ld finished", (long)self.indexPath.row);
}

- (void)saveImage:(UIImage *)image {
    if (self.context) {
        [SLVStorageService saveImage:image forKey:self.key inManagedObjectContext:self.context];
    }
}

- (void)resume {
    self.innerQueue.suspended = NO;
    [self.task resume];
    NSLog(@"operation %ld resumed", (long)self.indexPath.row);
}

- (void)pause {
    self.innerQueue.suspended = YES;
    self.status = SLVImageStatusCancelled;
    [self.task suspend];
    [self cancel];
    NSLog(@"operation %ld paused", (long)self.indexPath.row);
}

@end
