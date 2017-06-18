//
//  SLVModel.h
//  flickrgram
//
//  Created by 1 on 18.06.17.
//  Copyright © 2017 serebryanyy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLVModelProtocol.h"
#import "SLVFacadeProtocol.h"

@interface SLVModel : NSObject <SLVModelProtocol>

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFacade:(id<SLVFacadeProtocol>)facade;

@end
