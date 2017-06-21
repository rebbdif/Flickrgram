//
//  SLVCollectionModel.h
//  lection14
//
//  Created by iOS-School-1 on 04.05.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLVCollectionModelProtocol.h"
#import "SLVFacadeProtocol.h"

@class SLVItem;
@class NSManagedObjectContext;

@interface SLVCollectionModel : NSObject <SLVCollectionModelProtocol>

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFacade:(id<SLVFacadeProtocol>)facade;

@end
