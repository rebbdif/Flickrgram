//
//  SLVCollectionModel.h
//  lection14
//
//  Created by iOS-School-1 on 04.05.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLVCollectionModelProtocol.h"
#import "SLVStorageService.h"
#import "SLVNetworkManager.h"

@class SLVItem;
@class NSManagedObjectContext;

@interface SLVCollectionModel : NSObject <SLVCollectionModelProtocol>

@property (nonatomic, strong, readonly) id<SLVStorageProtocol> storageService;
@property (nonatomic, strong, readonly) id<SLVNetworkProtocol> networkManager;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithNetworkManager:(id<SLVNetworkProtocol>)networkManager storageService:(id<SLVStorageProtocol>)storageService;

@end
