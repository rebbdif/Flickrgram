//
//  SLVFavoritesModel.h
//  flickrgram
//
//  Created by 1 on 26.06.17.
//  Copyright © 2017 serebryanyy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLVFacadeProtocol.h"

@interface SLVFavoritesModel : NSObject

- (instancetype)initWithFacade:(id<SLVFacadeProtocol>)facade;
- (void)getFavoriteItemsWithCompletionHandler:(void (^)(NSArray *))completionHandler;


@end
