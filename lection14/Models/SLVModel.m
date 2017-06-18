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

static NSString *const item = @"SLVItem";

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

- (void)loadImageForItem:(SLVItem *)currentItem forURL:(NSString *)url forAttribute:(NSString *)attribute withCompletionHandler:(void (^)(void))completionHandler {
    if (!self.imageOperations[currentItem.identifier] || self.imageOperations[currentItem.identifier].status == SLVImageStatusNone) {
        SLVImageDownloadOperation *imageDownloadOperation = [[SLVImageDownloadOperation alloc] initWithFacade:self.facade entity:item key:currentItem.identifier url:url attribute:attribute];
        imageDownloadOperation.completionBlock = ^{
            completionHandler();
        };
        [self.imageOperations setObject:imageDownloadOperation forKey:currentItem.identifier];
        [self.imagesQueue addOperation:imageDownloadOperation];
    } else if (self.imageOperations[currentItem.identifier].status == SLVImageStatusCancelled) {
        [self.imageOperations[currentItem.identifier] resume];
    }
}

- (SLVItem *)fetchItemForKey:(NSString *)key {
    return [self.facade fetchEntity:item forKey:key];
}

- (void)clearModel:(BOOL)entirely {
    NSString *predicate = nil;
    if (!entirely) predicate = @"isFavorite == NO";
    [self.facade deleteAllEntities:item withPredicate:predicate];
    [self.imageOperations removeAllObjects];
}

- (void)cancelOperations {
    [self.imageOperations enumerateKeysAndObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id key, id object, BOOL *stop) {
        SLVImageDownloadOperation *operation = (SLVImageDownloadOperation *)object;
        if (operation.isExecuting) {
            [operation pause];
        }
    }];
}

- (void)resumeOperations {
    [self.imageOperations enumerateKeysAndObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id key, id object, BOOL *stop) {
        SLVImageDownloadOperation *operation = (SLVImageDownloadOperation *)object;
        if (operation.isCancelled) {
            [operation resume];
        }
    }];
}

- (id<SLVFacadeProtocol>)returnFacade {
    return self.facade;
}

@end
