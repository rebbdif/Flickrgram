//
//  SLVModel.h
//  flickrgram
//
//  Created by 1 on 18.06.17.
//  Copyright © 2017 serebryanyy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLVFacadeProtocol.h"
#import "SLVNetworkProtocol.h"
#import "SLVStorageProtocol.h"

@interface SLVImageDownloader : NSObject <SLVFacadeProtocol>

@property (nonatomic, strong) id<SLVNetworkProtocol> networkManager;
@property (nonatomic, strong) id<SLVStorageProtocol> storageService;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithNetworkManager:(id<SLVNetworkProtocol>)networkManager storageService:(id<SLVStorageProtocol>) storageService;

@end
