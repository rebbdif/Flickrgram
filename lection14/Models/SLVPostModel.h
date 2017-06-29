//
//  SLVPostModel.h
//  flickrgram
//
//  Created by 1 on 17.06.17.
//  Copyright © 2017 serebryanyy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLVPostModelProtocol.h"
#import "SLVFacadeProtocol.h"

@interface SLVPostModel : NSObject <SLVPostModelProtocol>

@property (nonatomic, strong, readonly) id<SLVStorageProtocol> storageService;
@property (nonatomic, strong, readonly) id<SLVNetworkProtocol> networkManager;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFacade:(id<SLVFacadeProtocol>)facade;

@end
