//
//  SLVModel.m
//  flickrgram
//
//  Created by 1 on 18.06.17.
//  Copyright © 2017 serebryanyy. All rights reserved.
//

#import "SLVModel.h"
#import "SLVItem.h"
#import "SLVImageDownloadOperation.h"
#import "SLVNetworkManager.h"
#import "SLVStorageService.h"

@interface SLVModel()

@property (strong, nonatomic) NSMutableDictionary<NSString *, SLVImageDownloadOperation *> *imageOperations;
@property (strong, nonatomic) NSOperationQueue *imagesQueue;
@property (strong, nonatomic) SLVNetworkManager *networkManager;
@property (strong, nonatomic) SLVStorageService *storageService;

@end

@implementation SLVModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _imageOperations = [NSMutableDictionary new];
        _imagesQueue = [NSOperationQueue new];
        _imagesQueue.qualityOfService = QOS_CLASS_DEFAULT;
        _networkManager = [[SLVNetworkManager alloc] init];
        _storageService = [[SLVStorageService alloc] init];
    }
    return self;
}

- (void)loadImageForItem:(SLVItem *)currentItem forAttribute:(NSString *)attribute withCompletionHandler:(void (^)(void))completionHandler {
    if (!self.imageOperations[currentItem.identifier]) {
        SLVImageDownloadOperation *imageDownloadOperation = [SLVImageDownloadOperation new];
        imageDownloadOperation.key = currentItem.identifier;
        imageDownloadOperation.url = currentItem.thumbnailURL;
        imageDownloadOperation.completionBlock = ^{
            completionHandler();
        };
        [self.imageOperations setObject:imageDownloadOperation forKey:currentItem.identifier];
        [self.imagesQueue addOperation:imageDownloadOperation];
    } else if (self.imageOperations[currentItem.identifier].status == SLVImageStatusCancelled || self.imageOperations[currentItem.identifier].status == SLVImageStatusNone) {
        [self.imageOperations[currentItem.identifier] resume];
    }
}


- (UIImage *)imageForItem:(SLVItem *)item {
    return nil;
}

- (void)clearModel:(BOOL)entirely {
    
}

- (void)resumeOperations {
    
}

-(void)cancelOperations {
    
}

@end
