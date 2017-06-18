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

@interface SLVModel()

@property (nonatomic, strong) NSMutableDictionary<NSString *, SLVImageDownloadOperation *> *imageOperations;
@property (nonatomic, strong) NSOperationQueue *imagesQueue;
@property (nonatomic, strong) id<SLVFacadeProtocol> facade;

@end

@implementation SLVModel

- (instancetype)initWithFacade:(id<SLVFacadeProtocol>)facade {
    self = [super init];
    if (self) {
        _imageOperations = [NSMutableDictionary new];
        _imagesQueue = [NSOperationQueue new];
        _imagesQueue.qualityOfService = QOS_CLASS_DEFAULT;
        _facade = facade;
    }
    return self;
}

- (void)loadImageForItem:(SLVItem *)currentItem forAttribute:(NSString *)attribute withCompletionHandler:(void (^)(void))completionHandler {
    if (!self.imageOperations[currentItem.identifier] || self.imageOperations[currentItem.identifier].status == SLVImageStatusNone) {
        SLVImageDownloadOperation *imageDownloadOperation = [[SLVImageDownloadOperation alloc] init];
        imageDownloadOperation.attr = currentItem.identifier;
        imageDownloadOperation.url = currentItem.thumbnailURL;
        imageDownloadOperation.completionBlock = ^{
            completionHandler();
        };
        [self.imageOperations setObject:imageDownloadOperation forKey:currentItem.identifier];
        [self.imagesQueue addOperation:imageDownloadOperation];
    } else if (self.imageOperations[currentItem.identifier].status == SLVImageStatusCancelled) {
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
