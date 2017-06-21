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

@interface SLVModel : NSObject <SLVFacadeProtocol>

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFacade:(id<SLVMediatorProtocol>)facade;

@end
