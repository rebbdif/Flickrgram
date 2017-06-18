//
//  SLVCollectionModelProtocol
//  lection14
//
//  Created by 1 on 17.06.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLVModelProtocol.h"

@class UIImage;
@class SLVItem;

typedef void (^Block)(void);

@protocol SLVCollectionModelProtocol <SLVModelProtocol>

- (NSUInteger)numberOfItems;
- (UIImage *)imageForIndexPath:(NSIndexPath *)indexPath;
- (void)getItemsForRequest:(NSString*) request withCompletionHandler:(void (^)(void))completionHandler;

@end
