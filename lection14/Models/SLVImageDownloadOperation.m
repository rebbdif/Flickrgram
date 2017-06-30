//
//  ImageDownloadOperation.m
//  lection14
//
//  Created by 1 on 24.05.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import "SLVImageDownloadOperation.h"

@interface SLVImageDownloadOperation()

@property (nonatomic, strong) id<SLVNetworkProtocol> networkManager;
@property (nonatomic, strong) id<SLVStorageProtocol> storageService;

@property (nonatomic, strong) __block NSString *downloadedImageURL;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *attribute;
@property (nonatomic, strong) NSString *entityName;
@property (nonatomic, copy, nullable) void(^completion)(void);
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;

@end

@implementation SLVImageDownloadOperation

- (instancetype)initWithNetworkManager:(id<SLVNetworkProtocol>)networkManager storageService:(id<SLVStorageProtocol>)storageService entity:(NSString *)entityName key:(NSString *)key url:(NSString *)url attribute:(NSString *)attribute completion:(void (^)(void))completion {
    self = [super init];
    if (self) {
        _storageService = storageService;
        _networkManager = networkManager;
        _entityName = entityName;
        _key = key;
        _url = url;
        _attribute = attribute;
        _completion = completion;
    }
    return self;
}

- (void)main {
    NSAssert(_url, @"no url");
    NSAssert(_key, @"no key");
    NSLog(@"started");
    
    self.downloadTask = [self.networkManager downloadImageFromURL:[NSURL URLWithString:self.url] withCompletionHandler:^(NSString *downloadedImageURL) {
        self.downloadedImageURL = downloadedImageURL;
        NSLog(@"downloaded");
        [self saveImage];
    }];
}

- (void)saveImage {
    NSLog(@"saving...");
    __weak typeof(self) weakSelf = self;
    [self.storageService saveObject:self.downloadedImageURL forEntity:self.entityName forAttribute:self.attribute forKey:self.key withCompletionHandler:^{
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if (!strongSelf.isCancelled) {
            NSLog(@"saved");
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.completion();
            });
        }  else {
            NSLog(@"went wrong");
        }
    }];
}

- (void)pause {
    NSLog(@"cancelled");
    [self.downloadTask suspend];
    [self cancel];
}

- (void)dealloc {
    NSLog(@"dealloc");
}

@end
