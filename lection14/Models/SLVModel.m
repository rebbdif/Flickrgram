//
//  SLVModel.m
//  flickrgram
//
//  Created by 1 on 18.06.17.
//  Copyright © 2017 serebryanyy. All rights reserved.
//

#import "SLVModel.h"
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

- (void)loadImageForEntity:(NSString *)entityName withIdentifier:(NSString *)identifier forURL:(NSString *)url forAttribute:(NSString *)attribute withCompletionHandler:(void (^)(void))completionHandler {
    if (!self.imageOperations[identifier] || self.imageOperations[identifier].status == SLVImageStatusNone) {
        SLVImageDownloadOperation *imageDownloadOperation = [[SLVImageDownloadOperation alloc] initWithFacade:self.facade entity:entityName key:identifier url:url attribute:attribute];
        imageDownloadOperation.completionBlock = ^{
            completionHandler();
        };
        [self.imageOperations setObject:imageDownloadOperation forKey:identifier];
        [self.imagesQueue addOperation:imageDownloadOperation];
    } else if (self.imageOperations[identifier].status == SLVImageStatusCancelled) {
        [self.imageOperations[identifier] resume];
    }
}

- (id)fetchEntity:(NSString *)entityName forKey:(NSString *)key {
    return [self.facade fetchEntity:entityName forKey:key];
}

- (void)deleteEntities:(NSString *)entityName entirely:(BOOL)entirely {
    NSString *predicate = nil;
    if (!entirely) predicate = @"isFavorite == NO";
    [self.facade deleteAllEntities:entityName withPredicate:predicate];
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

- (void)clearModel {
    [self.facade clearModel];
}

@end
