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
#import "SLVModel.h"

@interface SLVPostModel : SLVModel <SLVPostModelProtocol>

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFacade:(id<SLVFacadeProtocol>)facade;

@end
