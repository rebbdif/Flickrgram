//
//  SLVMetadataLoadOperation.h
//  flickrgram
//
//  Created by 1 on 28.06.17.
//  Copyright © 2017 serebryanyy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLVStorageProtocol.h"
#import "SLVNetworkProtocol.h"

@class SLVItem;

@interface SLVMetadataLoadOperation : NSOperation

- (instancetype)initWithItem:(SLVItem *)item storageService:(id<SLVStorageProtocol>)storageService networkManager:(id<SLVNetworkProtocol>)networkManager;

@end
