//
//  SLVModelProtocol.h
//  flickrgram
//
//  Created by 1 on 17.06.17.
//  Copyright © 2017 serebryanyy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLVNetworkProtocol.h"
#import "SLVStorageProtocol.h"

@protocol SLVImageDownloaderProtocol <NSObject>

@property (nonatomic, strong, readonly) id<SLVNetworkProtocol> networkManager;
@property (nonatomic, strong, readonly) id<SLVStorageProtocol> storageService;

- (void)pauseOperations;

- (void)clearOperations;

- (void)loadImageForEntity:(NSString *)entityName withIdentifier:(NSString *)identifier forURL:(NSString *)url forAttribute:(NSString *)attribute withCompletionHandler:(void (^)(void))completionHandler;

@end
